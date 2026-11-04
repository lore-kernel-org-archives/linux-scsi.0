Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758429;
	b=dbMS9u/kz2xioTqSEFCWxYIAAJhntZFO6fvWP3qnlc5PRkWyRvUlVZ+C45rPVTvONmyt
	 vRKsbXG6HcUDwKuh82hqQD6yqFPGxx5UURDEShbmy6fA6LGHa9W3EHj/LlQtJ4X1oTYRJ
	 jq6OwovzCJn3PK8c3Wih1fZilOJAoAc3Qt7sZjbR3g5WO2V9qs/yJCf21MAHWqW9wE+Tv
	 6kgSKEcLdsgq1E8MLE//JUKY0rynXIM5/gIHN7DxulO7i5sVqC349rPKPQeXGXpP8x+G9
	 ygtH8qzsR9wyRw1aMnOiRwIvRyb5mKEmX1oSHOtYOHvvrEYaOp+lSslltsIRmb3B8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758429;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=7bqoy96C4XQe3xOc9KiYo5/YVKLPvFVsNsLwcqiTCxc=;
	b=oO7H1Tiph9PiwRP/6zEaRIqWW+l/Hz9XX5TiC2Iq7R16vbEQSdGu6M79wXFLe1nYit0J
	 qO5uicAlmOXx+2432yiJZw5txFYJDZmw01wgnAvWoDxANFb7koI97VfFFlGyRq1FcIk6i
	 cTgUJlCvM9d8BxOPAkJCrXAhMinMFqVDuu4+ziFjNwCDXjeERoJtnvjkDrpY8w9R5e3/b
	 kCH90NaRkLzfiuNvTD5Yr/czzRetC0elim0MPJYdvQ8biGJnuxZfK1HjyGScJ0aydf14c
	 uxfYRmfDISt8KZCEk0oqqKfscSuFo8vyXbAuyzEXDrAK6Fiw5VXJICfD7QUDhiVOjrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949A606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9949A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABXg_3XlOpqhXM+AA--.27409S2;
	Wed, 04 Nov 2026 10:13:43 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: drop the sas_device reference on port add failure
Date: Wed,  4 Nov 2026 02:13:52 +0000
Message-Id: <20261104021352.1467740-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABXg_3XlOpqhXM+AA--.27409S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW3tw1DAFW8Ar1UZF1UJrb_yoW8Xw4Upa
	s8Ca45CF98Gw4I9rnrGw13Zry5J3W7C3s8KFW0vwnYkr1UJFySqry0vrs0qF1DArZ3Ja98
	JrWDJrs5WF45GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x07b5lk3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgUBA2rqY4K6RgAAsc

mpt3sas_transport_port_add() takes a reference on the sas_device of a SAS
end device with mpt3sas_get_sdev_by_addr(), but only drops it after
sas_rphy_add() has succeeded.

If anything in between fails - no parent device, sas_port_alloc_num() or
sas_port_add() failure, rphy allocation failure, sas_rphy_add() failure -
the error path frees the port and returns without releasing the
reference, so the sas_device can never go away. The pend_sas_rphy_add
flag set for the same window is left behind as well.

Drop the reference and clear the flag in the shared out_fail path.

Fixes: d1cb5e495e53 ("mpt3sas: Refcount sas_device objects and fix unsafe list usage")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..38259dae9109 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -866,6 +866,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	sas_port_delete(port);
 
 out_fail:
+	if (sas_device) {
+		sas_device->pend_sas_rphy_add = 0;
+		sas_device_put(sas_device);
+	}
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
-- 
2.34.1

