Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758482;
	b=QXB0X4OOQqC3dd2x1JEheYCL7rj3SlU7xL43r5SovRI0GvUi7jVwaLJ9sfXUxx6QQ9Sl
	 sf3yvVJWnj52HXn7w3p+BbmzU7rDVUWQzMuv/7GLYDB+oSrcUaDnr8YVojnyJyh+EWJs9
	 QYG7DSI+0UMsoVc6gCagFBxQUXGb++DBwWWlpYBrSmiHzxmZX9K2e5BjS8iRYDxzFFU2u
	 aEDhUqciYdV5GMfOexQFL3+BVjwQzM1gPROkLrHfZc8DU/WhsEL9Y1cJwcanKMsCyO6NG
	 iYwjnE2ziUFc++Z0Tir1lK5brFEqXt5es2vBAtlcwuffss3xVR3RAbQLDhqIcNzKGZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758482;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=odk/mzR0xsHPTAbLVck69u08+bRdzQx3gTTydRhw0HM=;
	b=yuMJ0V7kBn+MF9ynX6GuzmjmrU957r8NhR76ks7biQFgKUzJ6COOhkdtUALmS7TINVOr
	 qCVctqy3srgROWuOBaA6JWyYTRR5Yp2zvlsS0Nx2C91d8S2Hc5PtwlKQ7PnsdLiERGgj+
	 9Vysub6ujZZMuM4P9bKFXPXqH/+kOP7RuEVXkGXzFFBRxf3D2Qyg8EXaQC7FC4HRbsuQQ
	 /NufkoJ+naBxCncu6LfQLzDBDBEyfYlrtHHuaiZCdcpIv4SP/euPzsOll25BnIqID1k/P
	 5CtFT6P9uXabV6+DKUfm+5slBZeCWbPTqQUGqOOTABE2L5ZRVPJq1ceXrRgR10t69/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C6B606A326;
	Wed,  4 Nov 2026 02:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31C6B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXvvgPlepqwnU+AA--.9648S2;
	Wed, 04 Nov 2026 10:14:39 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: cxgbit: drop the cnp reference when the close reply never comes
Date: Wed,  4 Nov 2026 02:14:48 +0000
Message-Id: <20261104021448.1468404-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXvvgPlepqwnU+AA--.9648S2
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrGry3Kr4kWw1DtF13Jwb_yoW8ZFyfpF
	sYkry5AryDGrWUtr18Jws29rySvanayry3Cr95Cw4kuw4Yv3yqyr10yw12q3y5u34vgr12
	qF4DZF1xX3yqy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
	6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU5EQ6tUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAMBA2rqY+S58gAAsB

__cxgbit_free_cdev_np() takes a reference on the cxgbit_np before asking
firmware to remove the server socket, and cxgbit_close_listsrv_rpl()
drops it when the reply arrives.  cxgbit_wait_for_reply() can also give
up before any reply is received: it returns -EIO straight away when
CXGB4_STATE_START_RECOVERY or CXGB4_STATE_DETACH has cleared
CDEV_STATE_UP while the request was in flight.  That path is not the
-ETIMEDOUT path, so the function continues, frees the server TID and
returns without dropping the reference.  As the TID is gone, the reply
handler can no longer look the cxgbit_np up and the reference is leaked,
keeping the np allocation alive forever.

Tell the two -EIO sources apart with completion_done():
cxgbit_close_listsrv_rpl() completes wr_wait before it drops the
reference, so a finished completion means the reply owns it.  If the
wait gave up without a reply, drop the reference locally once the TID
has been freed.

Fixes: 9730ffcb8957 ("cxgbit: add files for cxgbit.ko")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 146705845fa3..91787bca3ff1 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -558,6 +558,15 @@ __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
 
 	cxgb4_free_stid(cdev->lldi.tids, stid,
 			cnp->com.local_addr.ss_family);
+
+	/*
+	 * A reply carrying an error status also returns -EIO, but that reply
+	 * has already dropped the reference taken above.  Only a wait that
+	 * bailed out before any reply arrived still holds it.
+	 */
+	if (ret && !completion_done(&cnp->com.wr_wait.completion))
+		cxgbit_put_cnp(cnp);
+
 	return 0;
 }
 
-- 
2.34.1

