From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 6/18] fusion: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:15 +0200
Message-ID: <1401117687-28911-7-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: benoit.taine@lip6.fr, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/message/fusion/mptbase.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 570b18a..6417a3f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6004,13 +6004,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
 
-	mem = kmalloc(iocpage2sz, GFP_KERNEL);
+	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
 	if (!mem) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 
 	mpt_read_ioc_pg_3(ioc);

