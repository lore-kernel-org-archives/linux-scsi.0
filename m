From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 14/17] bfa: fix endianess issue for firmware stats
Date: Mon, 13 May 2013 02:33:32 -0700
Message-ID: <1368437615-9867-15-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50630 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab3EMKAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 06:00:33 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Fix endianess issue on Big-endian architecture for firmware statistics

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index c31cb3c..a4f3741 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1858,7 +1858,7 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 	bfa_trc(ioc, len);
 	for (i = 0; i < len; i++) {
 		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
-		buf[i] = be32_to_cpu(r32);
+		buf[i] = swab32(r32);
 		loff += sizeof(u32);
 
 		/*
-- 
1.7.12

