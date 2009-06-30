From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: sbp2: add support for disks >2 TB (and 16
 bytes long CDBs)
Date: Tue, 30 Jun 2009 20:27:59 +0200 (CEST)
Message-ID: <tkrat.90ae964a94712510@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
 <49FEFF7A.3090603@s5r6.in-berlin.de>
 <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
 <4A4908C4.1070705@s5r6.in-berlin.de>
 <tkrat.a60470e5bddd2db4@s5r6.in-berlin.de>
 <tkrat.518b97167f27772a@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39048 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZF3S2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2009 14:28:22 -0400
In-Reply-To: <tkrat.518b97167f27772a@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Ronald <Ronald@ioi.com.tw>

Increase the command ORB data structure to transport up to 16 bytes long
CDBs (instead of 12 bytes), and tell the SCSI mid layer about it.  This
is notably necessary for READ CAPACITY(16) and friends, i.e. support of
large disks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -201,6 +201,12 @@ static struct fw_device *target_device(s
 #define SBP2_CYCLE_LIMIT		(0xc8 << 12)	/* 200 125us cycles */
 
 /*
+ * There is no transport protocol limit to the CDB length,  but we implement
+ * a fixed length only.  16 bytes is enough for disks larger than 2 TB.
+ */
+#define SBP2_MAX_CDB_SIZE		16
+
+/*
  * The default maximum s/g segment size of a FireWire controller is
  * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
  * be quadlet-aligned, we set the length limit to 0xffff & ~3.
@@ -312,7 +318,7 @@ struct sbp2_command_orb {
 		struct sbp2_pointer next;
 		struct sbp2_pointer data_descriptor;
 		__be32 misc;
-		u8 command_block[12];
+		u8 command_block[SBP2_MAX_CDB_SIZE];
 	} request;
 	struct scsi_cmnd *cmd;
 	scsi_done_fn_t done;
@@ -1146,6 +1152,8 @@ static int sbp2_probe(struct device *dev
 	if (fw_device_enable_phys_dma(device) < 0)
 		goto fail_shost_put;
 
+	shost->max_cmd_len = SBP2_MAX_CDB_SIZE;
+
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 

-- 
Stefan Richter
-=====-==--= -==- ====-
http://arcgraph.de/sr/

