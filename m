Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4672DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Dec 2021 17:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbhLJR5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:57:24 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:60025 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241133AbhLJR5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Dec 2021 12:57:22 -0500
Received: from ubuntu-CJ.passengers.t19.sncf ([109.190.253.13])
        by smtp.orange.fr with ESMTPA
        id vk5Vm4O22OvR0vk5WmaHTK; Fri, 10 Dec 2021 18:53:46 +0100
X-ME-Helo: ubuntu-CJ.passengers.t19.sncf
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 10 Dec 2021 18:53:46 +0100
X-ME-IP: 109.190.253.13
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     james.smart@broadcom.com, ram.vegesna@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de,
        dwagner@suse.de
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] scsi: elx: efct: Avoid a useless memset
Date:   Fri, 10 Dec 2021 18:53:35 +0100
Message-Id: <9be7d5beb437583f8d975d168ac5c3e32fb6e465.1639158677.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'io->sgl' is kzalloced just a few lines above. There is no need to memset
it another time.

While at it change a kzalloc into an equivalent kcalloc to increase the
semantic and avoid an open coded arithmetic in a memory allocation
statement.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1 --> v2: s/kzalloc/kcalloc/

 drivers/scsi/elx/efct/efct_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
index 71e21655916a..109483f3e3df 100644
--- a/drivers/scsi/elx/efct/efct_io.c
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -56,13 +56,12 @@ efct_io_pool_create(struct efct *efct, u32 num_sgl)
 		}
 
 		/* Allocate SGL */
-		io->sgl = kzalloc(sizeof(*io->sgl) * num_sgl, GFP_KERNEL);
+		io->sgl = kcalloc(num_sgl, sizeof(*io->sgl), GFP_KERNEL);
 		if (!io->sgl) {
 			efct_io_pool_free(io_pool);
 			return NULL;
 		}
 
-		memset(io->sgl, 0, sizeof(*io->sgl) * num_sgl);
 		io->sgl_allocated = num_sgl;
 		io->sgl_count = 0;
 
-- 
2.32.0

