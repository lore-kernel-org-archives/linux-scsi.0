From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH v2] drivers: scsi: scsi_lib.c: use SG_POOL instead of SP
Date: Wed, 04 Dec 2013 10:42:41 +0800
Message-ID: <529E96A1.3060400@gmail.com>
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com> <52955913.3060809@gmail.com> <529B60FF.7030601@acm.org> <529BD584.7060504@gmail.com> <1385945387.20150.2.camel@dabdike.int.hansenpartnership.com> <529C5D89.8050809@gmail.com> <20131202213243.GA20646@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62873 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3LDCk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 21:40:28 -0500
In-Reply-To: <20131202213243.GA20646@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rkuo <rkuo@codeaurora.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@acm.org>, Bottomley@parallels.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

the macro SP is too common to make conflict with others, so recommend
to use another more readable and non-conflict macro SG_POOL instead of
(and recommend others do not use SP either).

The related warning (with allmodconfig for hexagon):

    CC [M]  drivers/scsi/scsi_lib.o
  drivers/scsi/scsi_lib.c:46:0: warning: "SP" redefined [enabled by default]
  arch/hexagon/include/uapi/asm/registers.h:9:0: note: this is the location of the previous definition


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/scsi_lib.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..19967fa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -43,28 +43,28 @@ struct scsi_host_sg_pool {
 	mempool_t	*pool;
 };
 
-#define SP(x) { x, "sgpool-" __stringify(x) }
+#define SG_POOL(x) { x, "sgpool-" __stringify(x) }
 #if (SCSI_MAX_SG_SEGMENTS < 32)
 #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
 #endif
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
-	SP(8),
-	SP(16),
+	SG_POOL(8),
+	SG_POOL(16),
 #if (SCSI_MAX_SG_SEGMENTS > 32)
-	SP(32),
+	SG_POOL(32),
 #if (SCSI_MAX_SG_SEGMENTS > 64)
-	SP(64),
+	SG_POOL(64),
 #if (SCSI_MAX_SG_SEGMENTS > 128)
-	SP(128),
+	SG_POOL(128),
 #if (SCSI_MAX_SG_SEGMENTS > 256)
 #error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
 #endif
 #endif
 #endif
 #endif
-	SP(SCSI_MAX_SG_SEGMENTS)
+	SG_POOL(SCSI_MAX_SG_SEGMENTS)
 };
-#undef SP
+#undef SG_POOL
 
 struct kmem_cache *scsi_sdb_cache;
 
-- 
1.7.7.6
