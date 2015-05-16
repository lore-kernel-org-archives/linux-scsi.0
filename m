From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 7/7] megaraid: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:53 +0900
Message-ID: <1431760673-7180-8-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36721 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbbEPHSs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:48 -0400
Received: by pdfh10 with SMTP id h10so52171724pdf.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:47 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bc7b34c..509aead 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -759,6 +759,8 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			 */
 			if( cmd->cmd_len == 6 ) {
 				mbox->m_out.numsectors = (u32) cmd->cmnd[4];
+				if (mbox->m_out.numsectors == 0)
+					mbox->m_out.numsectors = 256;
 				mbox->m_out.lba =
 					((u32)cmd->cmnd[1] << 16) |
 					((u32)cmd->cmnd[2] << 8) |
-- 
1.9.1

