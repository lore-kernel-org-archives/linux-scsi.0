From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/15] qla4xxx: remove "ha->retry_reset_ha_cnt" from
 wait_for_hba_online
Date: Wed, 6 Oct 2010 22:48:24 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406786@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37497 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0JGFs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:48:27 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

remove "ha->retry_reset_ha_cnt" from wait_for_hba_online as its
initialize to zero at driver init time so it could always return
QLA_ERROR from wait_for_hba_online() without waiting for hba to
come online.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6e59b59..56962e5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1966,8 +1966,6 @@ static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
 
 		if (adapter_up(ha))
 			return QLA_SUCCESS;
-		else if (ha->retry_reset_ha_cnt == 0)
-			return QLA_ERROR;
 
 		msleep(2000);
 	}
-- 
1.6.6

