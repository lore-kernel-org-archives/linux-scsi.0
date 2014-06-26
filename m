From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH v2] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is set more than once
Date: Thu, 26 Jun 2014 13:54:49 +0200
Message-ID: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:40585 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbaFZLxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 07:53:39 -0400
Received: by mail-la0-f48.google.com with SMTP id el20so1746037lab.7
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2014 04:53:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

A struct member variable is set to different values without having used in between.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..4e17a7f 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
 	strcpy(stats->custom[2].desc, "eh_abort_cnt");
 	stats->custom[2].value = conn->eh_abort_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	stats->custom_length = 3;
 }
 
 
-- 
1.7.10.4

