From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 04/17] bfa: Fix WARN_ON condition check
Date: Mon, 13 May 2013 02:33:22 -0700
Message-ID: <1368437615-9867-5-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50359 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab3EMJwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:52:00 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

The WARN_ON condition check in IO completion path is wrong. IOtags
returned by the firmware is compared with driver/bfa iotag after masking
the retry count bits.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 27b5609..d7385d1 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2882,7 +2882,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
-	WARN_ON(BFA_IOIM_TAG_2_ID(ioim->iotag) != iotag);
+	WARN_ON(ioim->iotag != iotag);
 
 	bfa_ioim_cb_profile_comp(fcpim, ioim);
 
-- 
1.7.12

