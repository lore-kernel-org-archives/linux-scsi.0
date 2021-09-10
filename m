Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B92C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF5B61108
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbhIJAoG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234398AbhIJAXS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10B0610A3;
        Fri, 10 Sep 2021 00:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233327;
        bh=1s48qfc84dtCcoBzLsBwjVjE0Ybz2OhWliyLTBOc5FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X51R0cjWx6vgEUFzER6q9gf+Kfw4WqCXdxdqKA4R/4MK0XWGIq6eInb3Ex8WbpaPx
         hYHOwWUwvDeDXVbjPWHZtrcd3UfoOj2Luwf8V8ycDTvSkyopizcW4O9ccUrca0cvWR
         qZOaRQLaN4zDBou7kbDwI8pv2KZUEdnAab2eW7uoIlV1MHybsO+abhgmae+qQeYeeZ
         G/DBpLpJF3QKeWAPyCJ8QZvhcBjMR9TfR0Ee4KSD6tJzqtsZWcuIwjDbdS8m7GtjRt
         jURZXQULTb0xZQYC9J9Y5Hj9XmOwFeooR0DGTlSAnzkJCDlmMqZeyGHM8f520FPzmm
         UYLkyVUn0Jy1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/37] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
Date:   Thu,  9 Sep 2021 20:21:23 -0400
Message-Id: <20210910002143.175731-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 0f99792c01d1d6d35b86e850e9ccadd98d6f3e0c ]

The return value of transport_kmap_data_sg() is assigned to the variable
buf:

  buf = transport_kmap_data_sg(cmd);

And then it is checked:

  if (!buf) {

This indicates that buf can be NULL. However, it is dereferenced in the
following statements:

  if (!(buf[3] & 0x80))
    buf[3] |= 0x80;
  if (!(buf[2] & 0x80))
    buf[2] |= 0x80;

To fix these possible null-pointer dereferences, dereference buf and call
transport_kunmap_data_sg() only when buf is not NULL.

Link: https://lore.kernel.org/r/20210810040414.248167-1-islituo@gmail.com
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 55fe93296deb..17811bb07e9f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -622,17 +622,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			buf = transport_kmap_data_sg(cmd);
 			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			}
-
-			if (cdb[0] == MODE_SENSE_10) {
-				if (!(buf[3] & 0x80))
-					buf[3] |= 0x80;
 			} else {
-				if (!(buf[2] & 0x80))
-					buf[2] |= 0x80;
-			}
+				if (cdb[0] == MODE_SENSE_10) {
+					if (!(buf[3] & 0x80))
+						buf[3] |= 0x80;
+				} else {
+					if (!(buf[2] & 0x80))
+						buf[2] |= 0x80;
+				}
 
-			transport_kunmap_data_sg(cmd);
+				transport_kunmap_data_sg(cmd);
+			}
 		}
 	}
 after_mode_sense:
-- 
2.30.2

