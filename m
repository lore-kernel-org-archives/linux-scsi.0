From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3] scsi: bnx2i: bnx2i_iscsi.c:  Fix variable which was
 set to the wrong value
Date: Thu, 26 Jun 2014 21:07:54 -0500
Message-ID: <53ACD1FA.8050600@cs.wisc.edu>
References: <1403802633-23726-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45637 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaF0CIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 22:08:09 -0400
In-Reply-To: <1403802633-23726-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/26/2014 12:10 PM, Rickard Strandqvist wrote:
> After some discussion, all agreed that the previous value was incorrect.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This is better but still sort of incorrect as userspace would be getting 2
bogus entries at indexes 0 and 1. be2iscsi is also broken but it actually
was telling userspace it had no entries when it had one. The patch below
fixes both drivers. Tested here with both drivers.


[PATCH] bnx2i, be2iscsi: fix custom stats length

The custom stats is an array with custom_length indicating the length
of the array. This patch fixes bnx2i and be2iscsi's setting of the
custom stats. They both just have the one, eh_abort_cnt, so that should
be in the first entry of the custom array and custom_length should then
be one.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index fd284ff..8616281 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -914,7 +914,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	stats->custom_length = 1;
 	strcpy(stats->custom[0].desc, "eh_abort_cnt");
 	stats->custom[0].value = conn->eh_abort_cnt;
 }
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..9bd9b81 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
-	strcpy(stats->custom[2].desc, "eh_abort_cnt");
-	stats->custom[2].value = conn->eh_abort_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	strcpy(stats->custom[0].desc, "eh_abort_cnt");
+	stats->custom[0].value = conn->eh_abort_cnt;
+	stats->custom_length = 1;
 }
 
 

