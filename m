Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C702CC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B8D61A29
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbhCYAeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239333AbhCYAds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 20:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C710C61A0F;
        Thu, 25 Mar 2021 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616632428;
        bh=EryXWRMQraDwQ/gaFR/hHA4a1M92px7o/Hn5Xf12+Ig=;
        h=Date:From:To:Cc:Subject:From;
        b=W0wNCTlDvKwDSW2kPabuE7WuEQ6AWtGzEdL+Oh3KzQCOMQG7+hJRi0x8JhZna9aci
         cD+ck7YcCBtowdGD8fYo7TU5OYoqqzTaSji08KY2ARjNpMG71W3Eaf6xPPt8x39jSr
         DLyHKXuIrbdA4yE5v5mZbCBa1jytOjbFNYv4Wxj8CRTJccgsiouOjCByajpyFeD42D
         v10S0BqAPomHb5j1rttfhl+wCYpbQ7ZWe1sNtgrIq3fGSU6lUOuVVcuUIkah+uB1bY
         aDWs784wV6N+t2x+SUUfuL+rZX9fc9BdBnitnfDlkv6JQXYYOL6+I4zZqtqT0CKjRm
         B4Y702sheAAOA==
Date:   Wed, 24 Mar 2021 18:33:44 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: mptlan: Replace one-element array with
 flexible-array member
Message-ID: <20210324233344.GA99059@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct _SGE_TRANSACTION32 instead of one-element array.

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warning:

  CC [M]  drivers/message/fusion/mptlan.o
drivers/message/fusion/mptlan.c: In function ‘mpt_lan_sdu_send’:
drivers/message/fusion/mptlan.c:759:28: warning: array subscript 1 is above array bounds of ‘U32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
  759 |  pTrans->TransactionDetails[1] = cpu_to_le32((mac[2] << 24) |
      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/message/fusion/lsi/mpi.h | 4 ++--
 drivers/message/fusion/mptlan.c  | 9 +++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
index a575545d681f..eccbe54d43f3 100644
--- a/drivers/message/fusion/lsi/mpi.h
+++ b/drivers/message/fusion/lsi/mpi.h
@@ -424,8 +424,8 @@ typedef struct _SGE_TRANSACTION32
     U8                      ContextSize;
     U8                      DetailsLength;
     U8                      Flags;
-    U32                     TransactionContext[1];
-    U32                     TransactionDetails[1];
+    U32                     TransactionContext;
+    U32                     TransactionDetails[];
 } SGE_TRANSACTION32, MPI_POINTER PTR_SGE_TRANSACTION32,
   SGETransaction32_t, MPI_POINTER pSGETransaction32_t;
 
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 7d3784aa20e5..3261cac762de 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -72,9 +72,6 @@ MODULE_VERSION(my_VERSION);
 #define MPT_LAN_RECEIVE_POST_REQUEST_SIZE \
 	(sizeof(LANReceivePostRequest_t) - sizeof(SGE_MPI_UNION))
 
-#define MPT_LAN_TRANSACTION32_SIZE \
-	(sizeof(SGETransaction32_t) - sizeof(u32))
-
 /*
  *  Fusion MPT LAN private structures
  */
@@ -745,7 +742,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 	pTrans->ContextSize   = sizeof(u32);
 	pTrans->DetailsLength = 2 * sizeof(u32);
 	pTrans->Flags         = 0;
-	pTrans->TransactionContext[0] = cpu_to_le32(ctx);
+	pTrans->TransactionContext = cpu_to_le32(ctx);
 
 //	dioprintk((KERN_INFO MYNAM ": %s/%s: BC = %08x, skb = %p, buff = %p\n",
 //			IOC_AND_NETDEV_NAMES_s_s(dev),
@@ -1159,7 +1156,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 			__func__, buckets, curr));
 
 	max = (mpt_dev->req_sz - MPT_LAN_RECEIVE_POST_REQUEST_SIZE) /
-			(MPT_LAN_TRANSACTION32_SIZE + sizeof(SGESimple64_t));
+			(sizeof(SGETransaction32_t) + sizeof(SGESimple64_t));
 
 	while (buckets) {
 		mf = mpt_get_msg_frame(LanCtx, mpt_dev);
@@ -1234,7 +1231,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 			pTrans->ContextSize   = sizeof(u32);
 			pTrans->DetailsLength = 0;
 			pTrans->Flags         = 0;
-			pTrans->TransactionContext[0] = cpu_to_le32(ctx);
+			pTrans->TransactionContext = cpu_to_le32(ctx);
 
 			pSimple = (SGESimple64_t *) pTrans->TransactionDetails;
 
-- 
2.27.0

