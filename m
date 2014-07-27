From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcbuild.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 17:12:13 +0200
Message-ID: <1406473933-12801-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43482 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaG0PKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2014 11:10:47 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so3166624wib.14
        for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2014 08:10:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And use the sizeof on the to string rather than strlen on the from string.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcbuild.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index dce787f..9294c14 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1249,8 +1249,8 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
 
 	rspnid->dap = s_id;
-	rspnid->spn_len = (u8) strlen((char *)name);
-	strncpy((char *)rspnid->spn, (char *)name, rspnid->spn_len);
+	strlcpy((char *)rspnid->spn, (char *)name, sizeof(rspnid->spn));
+	rspnid->spn_len = (u8) strlen((char *)rspnid->spn);
 
 	return sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s);
 }
@@ -1270,8 +1270,8 @@ fc_rsnn_nn_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 	memset(rsnn_nn, 0, sizeof(struct fcgs_rsnn_nn_req_s));
 
 	rsnn_nn->node_name = node_name;
-	rsnn_nn->snn_len = (u8) strlen((char *)name);
-	strncpy((char *)rsnn_nn->snn, (char *)name, rsnn_nn->snn_len);
+	strlcpy((char *)rsnn_nn->snn, (char *)name, sizeof(rsnn_nn->snn));
+	rsnn_nn->snn_len = (u8) strlen((char *)rsnn_nn->snn);
 
 	return sizeof(struct fcgs_rsnn_nn_req_s) + sizeof(struct ct_hdr_s);
 }
-- 
1.7.10.4

