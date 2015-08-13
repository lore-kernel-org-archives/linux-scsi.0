From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH 2/2] bfa: Fix incorrect de-reference of pointer
Date: Thu, 13 Aug 2015 06:41:52 -0400
Message-ID: <1439462512-1911-3-git-send-email-anil.gurumurthy@qlogic.com>
References: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37683 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbbHML2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2015 07:28:31 -0400
In-Reply-To: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Tested-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
---
 drivers/scsi/bfa/bfa_ioc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 4e71044..98f7e8c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3878,7 +3878,7 @@ bfa_sfp_show_comp(struct bfa_sfp_s *sfp, struct bfi_mbmsg_s *msg)
 		bfa_trc(sfp, sfp->data_valid);
 		if (sfp->data_valid) {
 			u32	size = sizeof(struct sfp_mem_s);
-			u8 *des = (u8 *) &(sfp->sfpmem);
+			u8 *des = (u8 *)(sfp->sfpmem);
 			memcpy(des, sfp->dbuf_kva, size);
 		}
 		/*
-- 
1.7.10.4

