Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758442;
	b=2bWlEMOMDu9y4OCpBrVI3HiTeXAe2L8C92t2/wiTA191b71TJpwBtuKkQni84uIFgZYN
	 FNjmHlNUoOaUevrU/5ou+P/hbsaoK4Ob4ngTAuyMQ3QVGLWZ1BPVnPD5SH7pGwQCf+RPm
	 uIeKDnDxD7kATv3+FEUrU/mZ86JV8toHgM5XgSVNG321vjFAfsJiDJ5exeLzAuv78nTWL
	 Jb5qBYaLAkVqMglGybmpElmc1ONVrYJ9qJmwILxpR/PiojwWFrsyZwQkI2Oh0sxFfm9ju
	 iMqtId6zGvF3R+Kk7FAasmOy8pybJrlplXFTTlFA6b1jp41iIln/ty1RKHYVsQ5MXVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758442;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=ZgnYBFLaVw1VkhY3aucMjiYOWyVz6JcVwZC33GDLi6U=;
	b=I1evIPOhWn3cGiO1RuZUVo8bpEB5B6nTPoa/i4caQA9v2KTuKamR1BQ58Br1rlgUpByN
	 QeeX6vvcVzkX4VX+6F4bYJg3ypJpyrt6jZqMEIXdR45vm8TUbm9+8kSk3rbbU0dZEZPuG
	 nekPn5FOVsTdt84RsxUjr1pqOKh1iW3rGK0ANTs4Gjs2sAMJFM2aPQpS7XM2JvMXm6aix
	 xclXXkHKHCko2OLuq0XN9VB/dx1vhk38a5x2Edk7IGz2K9KhgKENLLhaUM5YRLZKEwxIy
	 fwktL6iYqW+4jDDJp6yRIPjzNtNa9Cj6xS/GGCFeAtaxwsqj2RglNfmU334yWV+40wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22FE606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F22FE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABHb_nolOpqIXQ+AA--.28901S2;
	Wed, 04 Nov 2026 10:14:00 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: myrs: drop the scsi_device reference in myrs_log_event
Date: Wed,  4 Nov 2026 02:14:09 +0000
Message-Id: <20261104021409.1467951-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABHb_nolOpqIXQ+AA--.28901S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr1UGw45WrWfWF1fWF1xKrg_yoWkGwc_W3
	yYvrZrW348AF40kFyxtrnxZF9xuFsrW3yrCw4jqr95CrW8ZF92vr4UZFZY9rWUWw48Crn8
	Xw1qyr4F9w17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb2AYjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07be3ktUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgUBA2rqY4K6rwAAs1

myrs_log_event() looks the physical device up with scsi_device_lookup(),
which returns the device with an extra reference that the caller has to
release with scsi_device_put().  The 'P' case only uses the device to
print the event and to update the cached device state, but the reference
is never dropped, so every physical device event leaks a scsi_device and
prevents the device from being freed.

Drop the reference after the device has been used.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/myrs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 1192b01fab8e..1f248501a611 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -877,6 +877,8 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 				break;
 			}
 		}
+		if (sdev)
+			scsi_device_put(sdev);
 		break;
 	case 'L':
 		shost_printk(KERN_INFO, shost,
-- 
2.34.1

