From: James Smart <james.smart@emulex.com>
Subject: [PATCH] bsg: correct fault if queue object removed while dev_t open
Date: Sun, 14 Nov 2010 11:12:04 -0500
Message-ID: <29a2a8aa-1e3b-463b-ad7d-3e214f0f6105@exht1.ad.emulex.com>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:9568 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756142Ab0KNQMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Nov 2010 11:12:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: carl.lajeunesse@emulex.com

This patch corrects an issue in bsg that results in a general protection
fault if an LLD is removed while an application is using an open file
handle to a bsg device, and the application issues an ioctl. The fault
occurs because the class_dev is NULL, having been cleared in
bsg_unregister_queue() when the driver was removed.  With this
patch, a check is made for the class_dev, and the application
will receive ENXIO if the related object is gone.

Note: this patch is related to the prior scsi_transport_fc patch which
correct a bsg infinited queued request issue:
http://marc.info/?l=linux-scsi&m=128330809428540&w=2

-- james s


 Signed-off-by: Carl Lajeunesse <carl.lajeunesse@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 bsg.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff -upNr a/block/bsg.c b/block/bsg.c
--- a/block/bsg.c	2010-11-14 10:31:52.000000000 -0500
+++ b/block/bsg.c	2010-11-14 10:32:12.000000000 -0500
@@ -250,6 +250,14 @@ bsg_map_hdr(struct bsg_device *bd, struc
 	int ret, rw;
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
+	struct bsg_class_device *bcd = &q->bsg_dev;
+
+	/* if the LLD has been removed then the bsg_unregister_queue will
+	 * eventually be called and the class_dev was freed, so we can no
+	 * longer use this request_queue. Return no such address.
+	 */
+	if (!bcd->class_dev)
+		return ERR_PTR(-ENXIO);
 
 	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
 		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,


