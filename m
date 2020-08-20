Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DC9C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 00:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE996207FB
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 00:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597881880;
	bh=5nk3NJXNopBSzjnj7Lpg8MhVeJiX9H+Pd26H61xczsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=meDJjDxcZid+77BluXFjzVEBXUbuixZfThqD8HQoaiC2+awLadROAuQLtQoVlBspf
	 3MABnTlQzQYQ8I62d87j9sKQ+5aGauZgwlwOmZJ94eOSOmoYg5rWB/4nW/CNQ8FvYn
	 pGCK83+f94Ep2pFDI+wjNkWXFL6EukTwKtvRfed4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgHTAET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 20:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgHTAER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 20:04:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB0522B40;
        Thu, 20 Aug 2020 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881856;
        bh=5nk3NJXNopBSzjnj7Lpg8MhVeJiX9H+Pd26H61xczsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxDLCV7nduGMllaRZiPXda5fTOcYEeb525dF1bpAq4GMiZMNYbK15eHxcfHX8Q5QN
         7/2D7QL4Ebq56Ybwno5Vxh9iGmd9RupcblSI8iZc+EX+YhfZXBELuFzloiFuCzkDPX
         S+GD5qa6GE8aGI5SzWCjElsRSdWKS9hk0IROjSSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/10] scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases
Date:   Wed, 19 Aug 2020 20:04:03 -0400
Message-Id: <20200820000406.216050-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000406.216050-1-sashal@kernel.org>
References: <20200820000406.216050-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit ec007ef40abb6a164d148b0dc19789a7a2de2cc8 ]

In fc_disc_gpn_id_resp(), skb is supposed to get freed in all cases except
for PTR_ERR. However, in some cases it didn't.

This fix is to call fc_frame_free(fp) before function returns.

Link: https://lore.kernel.org/r/20200729081824.30996-2-jhasan@marvell.com
Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Santosh Vernekar <svernekar@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 880a9068ca126..ef06af4e3611d 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -595,8 +595,12 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	mutex_lock(&disc->disc_mutex);
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
 		goto out;
-	if (IS_ERR(fp))
-		goto redisc;
+	if (IS_ERR(fp)) {
+		mutex_lock(&disc->disc_mutex);
+		fc_disc_restart(disc);
+		mutex_unlock(&disc->disc_mutex);
+		goto out;
+	}
 
 	cp = fc_frame_payload_get(fp, sizeof(*cp));
 	if (!cp)
@@ -621,7 +625,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 				new_rdata->disc_id = disc->disc_id;
 				lport->tt.rport_login(new_rdata);
 			}
-			goto out;
+			goto free_fp;
 		}
 		rdata->disc_id = disc->disc_id;
 		lport->tt.rport_login(rdata);
@@ -635,6 +639,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 redisc:
 		fc_disc_restart(disc);
 	}
+free_fp:
+	fc_frame_free(fp);
 out:
 	mutex_unlock(&disc->disc_mutex);
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
-- 
2.25.1

