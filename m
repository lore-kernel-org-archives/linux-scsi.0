From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] csiostor: remove unused variable in csio_process_fwevtq_entry()
Date: Fri, 15 Mar 2013 18:01:07 +0800
Message-ID: <CAPgLHd-HDkjb6OPH+46KQo3fwP-_H78S+G6CcqdwgvgrXoOHkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:60233 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3COKBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Mar 2013 06:01:10 -0400
Received: by mail-bk0-f54.google.com with SMTP id w5so1444952bku.13
        for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2013 03:01:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, naresh@chelsio.com, jj@chaosbits.net, arvindb@chelsio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable 'data' is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/csiostor/csio_hw.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index a0b4c89..1936055 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3565,7 +3565,6 @@ csio_process_fwevtq_entry(struct csio_hw *hw, void *wr, uint32_t len,
 			  struct csio_fl_dma_buf *flb, void *priv)
 {
 	__u8 op;
-	__be64 *data;
 	void *msg = NULL;
 	uint32_t msg_len = 0;
 	bool msg_sg = 0;
@@ -3581,8 +3580,6 @@ csio_process_fwevtq_entry(struct csio_hw *hw, void *wr, uint32_t len,
 		msg = (void *) flb;
 		msg_len = flb->totlen;
 		msg_sg = 1;
-
-		data = (__be64 *) msg;
 	} else if (op == CPL_FW6_MSG || op == CPL_FW4_MSG) {
 
 		CSIO_INC_STATS(hw, n_cpl_fw6_msg);
@@ -3590,8 +3587,6 @@ csio_process_fwevtq_entry(struct csio_hw *hw, void *wr, uint32_t len,
 		msg = (void *)((uintptr_t)wr + sizeof(__be64));
 		msg_len = (op == CPL_FW6_MSG) ? sizeof(struct cpl_fw6_msg) :
 			   sizeof(struct cpl_fw4_msg);
-
-		data = (__be64 *) msg;
 	} else {
 		csio_warn(hw, "unexpected CPL %#x on FW event queue\n", op);
 		CSIO_INC_STATS(hw, n_cpl_unexp);


