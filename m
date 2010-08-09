From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: fix compilation warning
Date: Mon, 9 Aug 2010 05:14:07 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128E7CC61@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:29164 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab0HIMOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 08:14:11 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, Ravi Anand <ravi.anand@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following warning:

drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_get_flash_info':
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'mid' may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'mid' was declared here
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'fid' may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'fid' was declared here

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 1b85235..e031a73 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1953,7 +1953,8 @@ qla4_8xxx_get_fdt_info(struct scsi_qla_host *ha)
 	uint16_t cnt, chksum;
 	uint16_t *wptr;
 	struct qla_fdt_layout *fdt;
-	uint16_t mid, fid;
+	uint16_t mid = 0;
+	uint16_t fid = 0;
 	struct ql82xx_hw_data *hw = &ha->hw;
 
 	hw->flash_conf_off = FARX_ACCESS_FLASH_CONF;
-- 
1.7.0.5

