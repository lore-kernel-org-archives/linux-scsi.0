Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDD4C3A5A0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 14:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE182076A
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587219256;
	bh=zxMAMCUGege0v8kJLkpgkDzKu7rKYEby4bGm0U/va+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RZcjKbShgDKXsyWK6qcWGbHJYSzRiDmvaMFR67C4gTc2AHmvaejImS+IPWGDdsh87
	 LVLfkpwCv+vFYpYTsqQ2atyWLm2gpIdgZkbFzTBMOSUGjPiWlyrRb4U5A10mb7nIKH
	 blNRtxUatbj7gi/m59W/rpVpzybG/8uwA659PDvs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgDROOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 10:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgDROJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 10:09:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C4722244;
        Sat, 18 Apr 2020 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587218965;
        bh=zxMAMCUGege0v8kJLkpgkDzKu7rKYEby4bGm0U/va+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8w0MxMpFI8w6ILcyWO/RI23kuxoQZZcDLuWLgsFGcM1M3+GdqAiSMcb1ll8LEJoi
         GM5SkLtfIvZqffa1w/v/ZKopfjcnSD9Gy9ZZvTNDTpFBU+9AINx3xwuLhTIDwdz7Co
         RFQ1aft3o61fbW27CHu/Xxz+WijRI9lqLhOjFW+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 12/75] scsi: libfc: If PRLI rejected, move rport to PLOGI state
Date:   Sat, 18 Apr 2020 10:08:07 -0400
Message-Id: <20200418140910.8280-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 45e544bfdab2014d11c7595b8ccc3c4715a09015 ]

If PRLI reject code indicates "rejected status", move rport state machine
back to PLOGI state.

Link: https://lore.kernel.org/r/20200327060208.17104-2-skashyap@marvell.com
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index da6e97d8dc3bb..6bb8917b99a19 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1208,9 +1208,15 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		if (!rjt)
 			FC_RPORT_DBG(rdata, "PRLI bad response\n");
-		else
+		else {
 			FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
 				     rjt->er_reason, rjt->er_explan);
+			if (rjt->er_reason == ELS_RJT_UNAB &&
+			    rjt->er_explan == ELS_EXPL_PLOGI_REQD) {
+				fc_rport_enter_plogi(rdata);
+				goto out;
+			}
+		}
 		fc_rport_error_retry(rdata, FC_EX_ELS_RJT);
 	}
 
-- 
2.20.1

