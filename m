From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 1/3] add fc transport events
Date: Thu, 27 May 2004 00:25:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B597F5.2030501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070804010709090706070408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45828 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261638AbUE0HZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 03:25:51 -0400
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i4R7Pfw07600
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2004 02:25:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070804010709090706070408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

01-add-host-transport-classdev.patch - adds the transport class_device to
the scsi_host structure.

  drivers/scsi/hosts.c     |   22 +++++++++++++++++++++-
  include/scsi/scsi_host.h |    4 ++++
  2 files changed, 25 insertions(+), 1 deletion(-)

--------------070804010709090706070408
Content-Type: text/plain;
 name="01-add-host-transport-classdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-add-host-transport-classdev.patch"

diff -arup linux-2.6.7-rc1/drivers/scsi/hosts.c linux-2.6.7-rc1-hotplug/drivers/scsi/hosts.c
--- linux-2.6.7-rc1/drivers/scsi/hosts.c	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/hosts.c	2004-05-26 23:17:30.217567849 -0700
@@ -83,6 +83,8 @@ void scsi_remove_host(struct Scsi_Host *
 
 	set_bit(SHOST_DEL, &shost->shost_state);
 
+	if (shost->transportt->class)
+		class_device_unregister(&shost->transport_classdev);
 	class_device_unregister(&shost->shost_classdev);
 	device_del(&shost->shost_gendev);
 }
@@ -123,15 +125,28 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto out_del_gendev;
 
+	if (shost->transportt->class) {
+		shost->transport_classdev.class = shost->transportt->class;
+
+		error = class_device_add(&shost->transport_classdev);
+		if (error)
+			goto out_del_classdev;
+		/* take a reference for the transport_classdev; this
+		 * is released by the transport_class .release */
+		get_device(&shost->shost_gendev);
+	}
+
 	get_device(&shost->shost_gendev);
 
 	error = scsi_sysfs_add_host(shost);
 	if (error)
-		goto out_del_classdev;
+		goto out_del_transport;
 
 	scsi_proc_host_add(shost);
 	return error;
 
+ out_del_transport:
+	class_device_del(&shost->transport_classdev);
  out_del_classdev:
 	class_device_del(&shost->shost_classdev);
  out_del_gendev:
@@ -280,6 +295,11 @@ struct Scsi_Host *scsi_host_alloc(struct
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
+	class_device_initialize(&shost->transport_classdev);
+	shost->transport_classdev.dev = &shost->shost_gendev;
+	snprintf(shost->transport_classdev.class_id, BUS_ID_SIZE, "host%d",
+		  shost->host_no);
+
 	shost->eh_notify = &complete;
 	rval = kernel_thread(scsi_error_handler, shost, 0);
 	if (rval < 0)
diff -arup linux-2.6.7-rc1/include/scsi/scsi_host.h linux-2.6.7-rc1-hotplug/include/scsi/scsi_host.h
--- linux-2.6.7-rc1/include/scsi/scsi_host.h	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/include/scsi/scsi_host.h	2004-05-26 23:17:08.000000000 -0700
@@ -475,6 +475,7 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev;
 	struct class_device	shost_classdev;
+	struct class_device	transport_classdev;
 
 	/*
 	 * List of hosts per template.
@@ -497,6 +498,9 @@ struct Scsi_Host {
 	container_of(d, struct Scsi_Host, shost_gendev)
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
+#define transport_class_to_shost(_class_dev) \
+	container_of(_class_dev, struct Scsi_Host, transport_classdev)
+
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);

--------------070804010709090706070408--

