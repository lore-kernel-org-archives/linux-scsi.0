From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Transport Attributes -- attempt#2
Date: Thu, 8 Jan 2004 13:17:17 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108131717.A9700@infradead.org>
References: <20040107185420.GA30627@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:782 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264463AbUAHNRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 08:17:24 -0500
Content-Disposition: inline
In-Reply-To: <20040107185420.GA30627@localhost>; from mort@wildopensource.com on Wed, Jan 07, 2004 at 01:54:20PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

+config SCSI_PSCSI_ATTRS
+	bool "Parallel SCSI Transport Attributes"

>> Scan we replacte the PSCSI/pscsi in identifiers with SPI/spi as used in
>> the t10 standards documents please?  This is a bit shorter and the correct
>> name.  In user-visible string Parallel SCSI is fine with me, but
>> maybe it should rather be

	bool "Parallel SCSI (SPI) Transport Attributes"

 
+obj-$(CONFIG_SCSI_PSCSI_ATTRS)	+= scsi_transport_pscsi.o
+obj-$(CONFIG_SCSI_FC_ATTRS)	+= scsi_transport_fc.o

>> This is wrong.  Currently the option are bool and you'd build them into
>> the kernel even if the scsi code is modular.  Either use scsi_mod-*
>> or make them their own modules using tristate (I still think that's
>> overkill just for the attributes, but jejb seems to like it)

 		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
+
+		class_device_initialize(&sdev->transport_classdev);
+		sdev->transport_classdev.dev = &sdev->sdev_gendev;
+		sdev->transport_classdev.class = sdev->host->hostt->transport_class;
+		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,

>> Out of curiosity:  Why do we need _another_ classdev.  Can't you
>> reuse the current one?

+	error = class_register(&sdev_class);
+	if (error)
+		goto undo_bus;
+
+#ifdef CONFIG_SCSI_PSCSI_ATTRS
+	error = scsi_pscsi_transport_init();
+	if (error)
+		goto undo_sdev;
+#endif
+#ifdef CONFIG_SCSI_FC_ATTRS
+	error = scsi_fc_transport_init();
+	if (error)
+		goto undo_all;
+#endif

> Please put stubs in the header instead of ifdefs in the code.
> (And 1:0 for jejb, with the moular approach this would just go away :))
 
+ out:
 	return error;
+
+	/* Prevent "unused label" warnings when either of the
+	 * transport attributes config options are turned off. */
+	goto undo_all;
+	goto undo_sdev;

>> Yikes!

+int scsi_add_transport_attributes(struct scsi_device *sdev)
+{
+	int error, i;
+	struct class_device_attribute **attrs = sdev->host->hostt->transport_attrs;
+
+	for (i = 0; attrs[i]; i++) {
+                error = class_device_create_file(&sdev->transport_classdev,
+                                                 attrs[i]);
+                if (error)
+                        return error;
+        }
+        return 0;
+}

Please merge this into scsi_sysfs.c, no need for another file.

+	struct fc_transport_attrs *ptr;
+
+	ptr = (struct fc_transport_attrs *)
+		kmalloc(sizeof(struct fc_transport_attrs),
+			GFP_KERNEL);

>> no need to cast here, this is not C++ (fortunately..)

+	INIT_FC_TRANSPORT(ptr);

>> this is just obsfucation, please kill the macro.

+	ptr = (struct pscsi_transport_attrs *)
+		kmalloc(sizeof(struct pscsi_transport_attrs),
+			GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	INIT_PSCSI_TRANSPORT(ptr);

>> same comments as above

+	void *			transport_attr_values;

>>	void			*transport_attr_values;

+#define transport_class_to_sdev(class_dev) \
+	container_of(class_dev, struct scsi_device, transport_classdev)

>> should just go to scsi_device.h

+
+static inline void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}

>> this is callback, thus the inline doesn't make sense at all.  just
>> give spi and fc their own copy - that scales better for possible future
>> additions anyway

+extern int scsi_add_transport_attributes(struct scsi_device *sdev);

>> this is internal to the scsi midlayer, thus should go to scsi_priv.h
>> (or be static to scsi_sysfs.c as suggested above)

+extern int scsi_export_transport_attributes(struct scsi_device *sdev);

>> doesn't seem to exist at all..


+	host->hostt->transport_attrs = pscsi_transport_attrs;
+	host->hostt->transport_class = &pscsi_transport_class;

>> Please set them _directrly_ in the host template. 
>> Currently you're writing to the host template for every found adapter..

+static int
+qla1280_slave_alloc(Scsi_Device *device)

>> should be struct scsi_device *sdev

+{
+	int error = 0;
+
+	error = pscsi_alloc_transport_attrs(device);
+	if (error)
+		return error;
+
+	return error;
+}

>> Okay, this is ugly as hell, as every driver needs to duplicate this
>> verbosely.  Better have a scsi_set_{spi,fc}_transport function that
>> can be called in module_init and then does not only set the calls
>> and attributes (so they don't need to exposed anymore but also a
>> default constructor for the attributes.

+void qla1280_slave_destroy(Scsi_Device *device)
+{
+	pscsi_destroy_transport_attrs(device);
+}

>> I don't think the _destroy_transport_attrs call makes sense,
>> just kfree the transport_attrs field in the core code uncondititionally.
>> If you plan more complex destructors for some reason put a destructor
>> in the host teplate, similar to the constructore mentioned above.

In fact after all the above suggestions it might be useful to have
a struct scsi_transport_attribute instead of stuffing all that into
the host template (sorry for guiding you into that direction).  The most
logical interface to set it would be to have a third argument for
scsi_host_alloc, but we can't break that interface now, so we should
probably add scsi_set_transport(struct Scsi_host *,
struct scsi_transport_template *), then and the driver will do in it's probe
rountine, somewhere between scsi_host_alloc and scsi_add_host a
scsi_set_transport(shost, &scsi_spi_template);
