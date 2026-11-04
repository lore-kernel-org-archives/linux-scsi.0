Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758439;
	b=qF8mCF2oENZfTMIykwqRXplxc2zVl1xR1nuC2foI+SY7gx2fDwF1yktyEnDcHaxs8SbZ
	 UL1uYaLq5D982RQcANCHYMS2IjVoJjjuHT688XOOC/Kfn/+PnxwtIZj1j2IwkudAgKZzz
	 GWilvkCBFrDTwx9S0+Lk1mZQ33BwYJMtIBPBLihusqyU4mDZofvggQFBgndAtH+/G3fPl
	 +/3jBQ127Z24s5AVmXI+UrTY4xLjtRMnsb1gEYjjZK3nWmvPxy2Gb8wmzv3JkJIw5x5nj
	 YlTn0AFsuDokiGHu6w7P9tvJM8nTr80lPwn0MD6O9g5ZoDYeFAMvf5cAqGUmKtXBb7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758439;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=hRK8UHnzL3joUJ7c3Uy8fdxDnQho7fVbo2jPJ64sQ6E=;
	b=JFszEdaWMKGPeF/sHnq2phXQqjoDmuVXmzFuYn9aqJADqaKfWKqYmNVo6H84gtGCLFcC
	 pzYKU0uueolJeG10hk4Ger4xvcAHqD23bRs4+VNcvs0V2QQY33jys9O0zKTSbpsiLfICr
	 5mbHdljsurbPUaoz0PKS8zkMtXDgPPLcJTv59u26dSV/AblDcGMEb9OFyKWhJD2ae/yu1
	 MEVpjKp2gja+FdSY+HuKJQ62JukRvIHLFA6uj61M1ADQEG5sgP0rBFh//MNmQMhWYWX+y
	 EwMzYzOwSe+9KvMW0GYSG8Pqyzlp0LpFERxBKLxy/go+tykznSN+Fhfq2HJ+aNOi2Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5C8606A329
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F5C8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAXP_nhlOpq7HM+AA--.9573S2;
	Wed, 04 Nov 2026 10:13:54 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: drop the sas_device reference after moving a vphy
Date: Wed,  4 Nov 2026 02:14:02 +0000
Message-Id: <20261104021402.1467816-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAAXP_nhlOpq7HM+AA--.9573S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw45tw4rJw4DAF1xKF1kAFb_yoW8Xr1rpr
	WkAa4Yyr98Gw429rnrWw18ZFyjka4Fy3s5KFW8Ka429w4rJa4FqryIvr4DXayjvrZ5KF98
	trsrtr95WFWUJr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x07b5lk3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQBA2rqY-m3QQAAsz

When a vSES device changes its port ID across a reset,
_scsih_update_vphys_after_reset() moves the virtual phy to the new
hba_port and looks the corresponding sas_device up with
mpt3sas_get_sdev_by_addr() to repoint it at the new port.  The lookup
takes a reference on the sas_device, but the reference is never
dropped: only sas_device->port is updated.  Every reset that changes a
vSES port ID therefore leaks a sas_device reference and the object can
never be freed.

Drop the reference once the port has been updated.

Fixes: ffa381d6373b ("scsi: mpt3sas: Handle vSES vphy object during HBA reset")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672db85..2274adb624f6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6415,8 +6415,10 @@ _scsih_update_vphys_after_reset(struct MPT3SAS_ADAPTER *ioc)
 					    &mport->vphys_list);
 					sas_device = mpt3sas_get_sdev_by_addr(
 					    ioc, attached_sas_addr, port);
-					if (sas_device)
+					if (sas_device) {
 						sas_device->port = mport;
+						sas_device_put(sas_device);
+					}
 				}
 				/*
 				 * Earlier while updating the hba_port table,
-- 
2.34.1

