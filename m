Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE61264612;
	Sun, 30 Aug 2026 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788096250; cv=none; b=lN31amSkcK3DZyJi3CMrs+TE+2ezjFvqqE6UYNRZRbWrRVdtwgRJK6Ae5zrNbMyqwgxM9nUCK56DXjm8DiBSsq6p6lHlijurnoNSFYbl+FVf0YJp/pwmkKywiziLtysfKQeBoD5+cz5IiGRB762FscWUHGjNVfUUyr9sXj30jDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788096250; c=relaxed/simple;
	bh=qlRyVLiWOfSGXWeRkK4L68tZCwILGwMCRHJ4h5FUx+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JkVgdoBBzXuaPdMFWqSKu59NLbMRqYxfIiC5PX0gnuQFV0UYw3jWHpnP5XGzF390vZzisETegvOePO0+y2FG2CBtJ7DZNkKpYDUOao+dPlRBmQla4TabrE1p2jq4nT0VuIh5AF83Yn63gh8KzBid1djjyd74Eg7TSptKXggBHac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADn8T_2LpRqCAybBg--.16943S2;
	Sun, 30 Aug 2026 21:24:06 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iscsi: cxgbit: bound LRO fragment aggregation
Date: Sun, 30 Aug 2026 21:24:04 +0800
Message-ID: <20260830132404.5053-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADn8T_2LpRqCAybBg--.16943S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGrWUKryftFW3tFW7Wr18AFb_yoW5Wr4UpF
	4vka4UGr4qqrZ3Xw48ArsrCr4Sv3yFyrZrurySkw4Iyr1a9rWDWF1SkF1aya15G395C3yU
	JF42vrWUGw4qqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUxcT
	PUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

cxgbit_lro_skb_merge() appends header and data fragments to a persistent
partial-PDU skb without checking its own nr_frags. Source skb fragment
limits do not bound the accumulated destination across LRO fragments.

Reject an overfull merge and reset the partial aggregation state on
failure.

Fixes: 9730ffcb8957 ("cxgbit: add files for cxgbit.ko")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 3698f2eb097e3..b5c66c4ebe07c 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1420,7 +1420,7 @@ static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
 	skb->len = 0;
 }
 
-static void
+static int
 cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 {
 	struct sk_buff *hskb = csk->lro_hskb;
@@ -1429,6 +1429,15 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 	struct skb_shared_info *hssi = skb_shinfo(hskb);
 	struct skb_shared_info *ssi = skb_shinfo(skb);
 	unsigned int len = 0;
+	u8 nr_frags = 0;
+
+	if (pdu_cb->flags & PDUCBF_RX_HDR)
+		nr_frags++;
+	if (pdu_cb->flags & PDUCBF_RX_DATA)
+		nr_frags += pdu_cb->nr_dfrags;
+	if (hssi->nr_frags > MAX_SKB_FRAGS ||
+	    nr_frags > MAX_SKB_FRAGS - hssi->nr_frags)
+		return -EMSGSIZE;
 
 	if (pdu_cb->flags & PDUCBF_RX_HDR) {
 		u8 hfrag_idx = hssi->nr_frags;
@@ -1489,6 +1498,8 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 		hpdu_cb->ddigest = pdu_cb->ddigest;
 		hpdu_cb->pdulen = pdu_cb->pdulen;
 	}
+
+	return 0;
 }
 
 static int cxgbit_process_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
@@ -1499,7 +1510,11 @@ static int cxgbit_process_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 	int ret = 0;
 
 	if (!pdu_cb->complete) {
-		cxgbit_lro_skb_merge(csk, skb, 0);
+		ret = cxgbit_lro_skb_merge(csk, skb, 0);
+		if (ret < 0) {
+			cxgbit_lro_hskb_reset(csk);
+			goto out;
+		}
 
 		if (pdu_cb->flags & PDUCBF_RX_STATUS) {
 			struct sk_buff *hskb = csk->lro_hskb;
@@ -1524,8 +1539,11 @@ static int cxgbit_process_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 			goto out;
 	}
 
-	if ((!lro_cb->complete) && lro_cb->pdu_idx)
-		cxgbit_lro_skb_merge(csk, skb, lro_cb->pdu_idx);
+	if (!lro_cb->complete && lro_cb->pdu_idx) {
+		ret = cxgbit_lro_skb_merge(csk, skb, lro_cb->pdu_idx);
+		if (ret < 0)
+			cxgbit_lro_hskb_reset(csk);
+	}
 
 out:
 	return ret;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

