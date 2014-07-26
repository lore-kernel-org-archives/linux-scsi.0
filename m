From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: scsi_tgt_if.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:30:03 +0200
Message-ID: <1406413803-7917-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48896 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaGZW2i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 18:28:38 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so2644932wib.15
        for <linux-scsi@vger.kernel.org>; Sat, 26 Jul 2014 15:28:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-kernel@vger.kernel.org

If you are going to use memset before strncpy you must copy sizeof -1

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/scsi_tgt_if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..7dc98eb 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -190,7 +190,7 @@ int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 itn_id,
 	ev.p.it_nexus_req.itn_id = itn_id;
 	if (initiator_id)
 		strncpy(ev.p.it_nexus_req.initiator_id, initiator_id,
-			sizeof(ev.p.it_nexus_req.initiator_id));
+			sizeof(ev.p.it_nexus_req.initiator_id) - 1);
 
 	dprintk("%d %x %llx\n", host_no, function, (unsigned long long)itn_id);
 
-- 
1.7.10.4

