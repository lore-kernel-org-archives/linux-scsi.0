From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] tcm: Add WriteCache and DPOFUA emulation bits to MODE_SENSE
Date: Thu, 26 Aug 2010 21:33:11 -0700
Message-ID: <1282883591-10872-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:30347 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753100Ab0H0EdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2010 00:33:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates transport_generic_emulate_modesense() and it's local
mode page callers to report WriteCacheEnabled=1 and DPOFUA=1 for TYPE_DISK
with a supporting capable struct se_device and TCM struct se_subsystem_api
structure.

Note that this patch will return DPOFUA=1 bit capable in the TYPE_DISK
specific area when emulate_write_cache=1 and emulate_fua_write=1 device
configfs attributes have been set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 076faa5..a81b402 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4933,13 +4933,12 @@ static int transport_modesense_control(struct se_device *dev, unsigned char *p)
 	return 12;
 }
 
-static int transport_modesense_caching(unsigned char *p)
+static int transport_modesense_caching(struct se_device *dev, unsigned char *p)
 {
 	p[0] = 0x08;
 	p[1] = 0x12;
-#if 0
-	p[2] = 0x04; /* Write Cache Enable */
-#endif
+	if (DEV_ATTRIB(dev)->emulate_write_cache > 0)
+		p[2] = 0x04; /* Write Cache Enable */
 	p[12] = 0x20; /* Disabled Read Ahead */
 
 	return 20;
@@ -4972,6 +4971,19 @@ static void transport_modesense_write_protect(
 	}
 }
 
+static void transport_modesense_dpofua(
+	unsigned char *buf,
+	int type)
+{
+	switch (type) {
+	case TYPE_DISK:
+		buf[0] |= 0x10; /* DPOFUA bit */
+		break;
+	default:
+		break;
+	}
+}
+
 int transport_generic_emulate_modesense(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
@@ -4991,7 +5003,7 @@ int transport_generic_emulate_modesense(
 		length = transport_modesense_rwrecovery(&buf[offset]);
 		break;
 	case 0x08:
-		length = transport_modesense_caching(&buf[offset]);
+		length = transport_modesense_caching(dev, &buf[offset]);
 		break;
 	case 0x0a:
 		length = transport_modesense_control(dev, &buf[offset]);
@@ -5003,7 +5015,7 @@ int transport_generic_emulate_modesense(
 #endif
 	case 0x3f:
 		length = transport_modesense_rwrecovery(&buf[offset]);
-		length += transport_modesense_caching(&buf[offset+length]);
+		length += transport_modesense_caching(dev, &buf[offset+length]);
 		length += transport_modesense_control(dev, &buf[offset+length]);
 #if 0
 		length += transport_modesense_devicecaps(&buf[offset+length]);
@@ -5026,6 +5038,10 @@ int transport_generic_emulate_modesense(
 		    (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			transport_modesense_write_protect(&buf[3], type);
 
+		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
+		    (DEV_ATTRIB(dev)->emulate_fua_write > 0))
+			transport_modesense_dpofua(&buf[3], type);
+
 		if ((offset + 2) > cmd->data_length)
 			offset = cmd->data_length;
 
@@ -5038,6 +5054,10 @@ int transport_generic_emulate_modesense(
 		    (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			transport_modesense_write_protect(&buf[2], type);
 
+		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
+		    (DEV_ATTRIB(dev)->emulate_fua_write > 0))
+			transport_modesense_dpofua(&buf[2], type);
+
 		if ((offset + 1) > cmd->data_length)
 			offset = cmd->data_length;
 	}
-- 
1.5.6.5

