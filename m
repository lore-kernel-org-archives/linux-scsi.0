From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Use of the new attribute modifiers on the 53c700
Date: 23 May 2003 12:41:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053708117.2086.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6oPZbXTiLwmSfJHmlP+s"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:56069 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264093AbTEWQ2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 12:28:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@us.ibm.com>


--=-6oPZbXTiLwmSfJHmlP+s
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


The attached patch illustrates how the new attribute functions can be
used.

The 53c700 modifies the queue_depth attribute so it can be set by the
root user, and also adds a new active_tags attribute which may be used
to obtain the information it currently puts out via its proc interface.

This achieves all I think we really need, which is the ability to have
LLDs provide their own routines for setting the default attributes.

James


--=-6oPZbXTiLwmSfJHmlP+s
Content-Disposition: inline; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/53c700.c 1.31 vs edited =3D=3D=3D=3D=3D
--- 1.31/drivers/scsi/53c700.c	Tue May 20 17:51:56 2003
+++ edited/drivers/scsi/53c700.c	Fri May 23 12:24:10 2003
@@ -173,6 +173,8 @@
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
 STATIC void NCR_700_slave_destroy(Scsi_Device *SDpnt);
=20
+static struct device_attribute **NCR_700_dev_attrs =3D NULL;
+
 static char *NCR_700_phase[] =3D {
 	"",
 	"after selection",
@@ -247,6 +249,9 @@
 	static int banner =3D 0;
 	int j;
=20
+	if(tpnt->sdev_attrs =3D=3D NULL)
+		tpnt->sdev_attrs =3D NCR_700_dev_attrs;
+
 	memory =3D dma_alloc_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
 				       &pScript, GFP_KERNEL);
 	if(memory =3D=3D NULL) {
@@ -2015,6 +2020,55 @@
 	/* to do here: deallocate memory */
 }
=20
+static ssize_t
+NCR_700_store_queue_depth(struct device *dev, const char *buf, size_t coun=
t)
+{
+	int depth;
+
+	struct scsi_device *SDp =3D to_scsi_device(dev);
+	depth =3D simple_strtoul(buf, NULL, 0);
+	if(depth > NCR_700_MAX_TAGS)
+		return -EINVAL;
+	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
+
+	return count;
+}
+
+static ssize_t
+NCR_700_show_active_tags(struct device *dev, char *buf)
+{
+	struct scsi_device *SDp =3D to_scsi_device(dev);
+
+	return snprintf(buf, 20, "%d\n", NCR_700_get_depth(SDp));
+}
+
+static struct device_attribute NCR_700_queue_depth_attr =3D {
+	.attr =3D {
+		.name =3D 	"queue_depth",
+		.mode =3D		S_IWUSR,
+	},
+	.store =3D NCR_700_store_queue_depth,
+};
+
+static struct device_attribute NCR_700_active_tags_attr =3D {
+	.attr =3D {
+		.name =3D		"active_tags",
+		.mode =3D		S_IRUGO,
+	},
+	.show =3D NCR_700_show_active_tags,
+};
+
+STATIC int __init NCR_700_init(void)
+{
+	scsi_sysfs_modify_sdev_attribute(&NCR_700_dev_attrs,
+					 &NCR_700_queue_depth_attr);
+	scsi_sysfs_modify_sdev_attribute(&NCR_700_dev_attrs,
+					 &NCR_700_active_tags_attr);
+	return 0;
+}
+
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
+
+module_init(NCR_700_init);

--=-6oPZbXTiLwmSfJHmlP+s--

