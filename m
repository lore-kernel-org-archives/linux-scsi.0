From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 16:04:19 +0200
Message-ID: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43564 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbaFYODV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 10:03:21 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so7971945wib.12
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2014 07:03:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

A struct member variable is set to different values without having used in between.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..fdf7bc3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1643,7 +1643,6 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
 	strcpy(stats->custom[2].desc, "eh_abort_cnt");
 	stats->custom[2].value = conn->eh_abort_cnt;
 	stats->digest_err = 0;
-- 
1.7.10.4

