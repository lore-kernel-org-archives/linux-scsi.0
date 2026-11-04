Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758471;
	b=sMWrDyibTchbX8NRFiB5X5aUvYrCg+wOFtb3L6ubfcxAcjffh89jxG33AWdCMh8NUvBV
	 GUcgk08nfExBKOKtYpVM/Vf7JTLRY7RuRxnWdcZt1AW6xB7g0qnlRDqRSDtC1h8rdktM3
	 05p+g1ouL4P0O50tOFzrB3W0DJhU0IZZFeC5esOvDtK1ZUCKy44gRWnEtqprBu6o5UNeL
	 44xSA9IPpdOc7clLxDUxbCvvTt+MT4uSJdmRdM/DeeQH0WavSg4nf+GNFYjFxHEx34w8z
	 Aic7AAxBEB0OtzaJHU+3QGp4bYj34a4fKUHHiSuahiOShcXNNaRTEWbqNdkV7FgcMhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758471;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=zr/dRlDcbbSI31dkALG387K2nqOHrpJfbb+CDeyrySg=;
	b=LQYzjwHJFWj2Y6IP13dKa4Be1Vz+72BxlHIZmkxGMuK0Op2Z7tTeG8eVHx+4bkTDYkL2
	 LPmYRwfjgVsa9QGuJ80TqqkzZN4Pf8TBICpzVoQsWHO+QEp2YWl3952LnoiiOI9NxTtzL
	 GyC3c3xUKjaC9+t1SNPxmyvAtynhUShfLRr8xH3KmGCW9TSedPutFLCbnzOJ8fgYhd+vI
	 epMjFeZr6Qhnn+ABt6pf9LzsFIHRqMc2/zf9TvrhXu8i7z+q0CXiNziBE0Vb5GKhqPcAN
	 zTfT527Jxi8UIVlrwwVoBsiLMr1/n3gZXMAOvfJ4DhbOPuCcZ7AuprHNHOG0B1muIdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F6D606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4F6D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADXAPsElepqRXU+AA--.9505S2;
	Wed, 04 Nov 2026 10:14:28 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: libcxgbi: drop the new socket when the IPv6 source lookup fails
Date: Wed,  4 Nov 2026 02:14:37 +0000
Message-Id: <20261104021437.1468320-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowADXAPsElepqRXU+AA--.9505S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry8Jw4xArWDKr18Kr1DAwb_yoW8Xr4fpr
	WvkFWxCFy8ArW0yrs3Cr4kCa4akaySk3y3Ga9rCw1a9w4rWryfC348A3W7Xr1jqryktw43
	Wr1DAFyUAF42k3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
	6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU5Sg4DUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwEBA2rqZFi4FgABsX

cxgbi_check_route6() creates a socket with cxgbi_sock_create() before the
preferred source address is resolved with ipv6_dev_get_saddr(). When that
lookup fails, the error path calls cxgbi_sock_closed() on the socket.

A freshly created socket is in the CTP_CLOSED state, and
cxgbi_sock_closed() returns immediately for that state without dropping
the reference taken at creation or releasing the CPL buffers allocated by
->csk_alloc_cpls(). The socket and the three control skbs are leaked on
every failed lookup, which can be triggered by a destination that has no
usable source address.

Free the CPL buffers and drop the socket reference directly instead.

Fixes: fc8d0590d914 ("libcxgbi: Add ipv6 api to driver")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/cxgbi/libcxgbi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index b0bffbc38183..c77a01cdda24 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -820,8 +820,10 @@ cxgbi_check_route6(struct sockaddr *dst_addr, int ifindex)
 		neigh_release(n);
 
 	ip6_rt_put(rt);
-	if (csk)
-		cxgbi_sock_closed(csk);
+	if (csk) {
+		cxgbi_sock_free_cpl_skbs(csk);
+		cxgbi_sock_put(csk);
+	}
 err_out:
 	return ERR_PTR(err);
 }
-- 
2.34.1

