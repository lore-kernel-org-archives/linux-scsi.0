Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758443;
	b=k8zC5Eod5cDg3hpGFv3azzcLkL6Jds82eX9pG03qZ5j4J2yjzqIJLXxnLBcbda8mtLXQ
	 rc8m6neu/cnF3uEu/9Iwnx4dkH8FdB//WXZKUAp0J1xGAzBNTkyjuatr1gepe6Izb+Y07
	 42cq9G6p9JEBbNiWzu2Hhu/UvyRrZnn34na/ado0N6koBB8Z7OBrQQG5TNHqYfrohkvSA
	 im8ZuO53qdW0VOSpinR5+/MkYA4rC3pE99cSGyNBGjqfIKVHFeFpqE7Hw7QWiTWihbxSs
	 620+iPBn2B8X0KlHblZpHy2KBa9RM2IqkPAS3LLszjz2G1KjbrOlI8jI53iXorn4NjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758443;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=ZCmr+uYghBbyE5jXTOwUOc6YUdUfKAaVr1gZCAtKAHs=;
	b=FVmW3Ba8+qAaUMP0PG1nIA+5OoG2GEvSOm6KwR2cj1tZyyTMy1nIV7Y1qsUCHrjN7EZ+
	 Xy8bzmknCeSXYpYtgfG0SHux2xYBuXsMm8lgcdQdzNYGwlQmJuzlnLCWAt2HKnZZFXk6o
	 vvxxvBkY03X+3fOGVbxsRH8Pq89wcNkbw+yu3MMOrCiSI1nGuTKfViRZi3pC2gz1spzb0
	 pKELqtwUvNFpZn8BBPYG5IZINAX/WIJmSecNcZewbfknu6h7dLrw6EG262Gewn3zJWzIn
	 RwK2WFBmaWTu9y3IeObGBNq5rs6ryfAQZEB662xK7Ybsr59g9w1TW/aziYBmMSo4I+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2391606A32C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2391606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABXf_nllOpqCHQ+AA--.27346S2;
	Wed, 04 Nov 2026 10:13:57 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: free the Scsi_Host for invalid adapters
Date: Wed,  4 Nov 2026 02:14:06 +0000
Message-Id: <20261104021406.1467932-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABXf_nllOpqCHQ+AA--.27346S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWDCFy7Cw18ZFWUZF1rXrb_yoW8AFW3p3
	yvya4akr98Kry7Kwnruw13ZF1FkanFya9YgFWvga4qga1UKFy8KrWIvryjqF10yrZYk3WD
	trs0qr97ua4UGr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvvb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxUgoanUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwQBA2rqZFi3fwAAs1

_scsih_probe() allocates the Scsi_Host with scsi_host_alloc() before
decoding the device ID.  When the adapter reports one of the invalid or
tampered Aero/Sea device IDs, the probe rejects it and returns directly
from inside the switch without releasing the host.  A device with such
an ID therefore leaks the Scsi_Host, and the driver core is left with a
probe that failed after several allocations.

Put the host before returning from both device ID checks.

Fixes: f38c43a0e900 ("scsi: mpt3sas: Detect tampered Aero and Sea adapters")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2274adb624f6..f58843331f58 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -13442,6 +13442,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Invalid",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_INVALID1_3816:
 		case MPI26_MFGPAGE_DEVID_INVALID1_3916:
@@ -13449,6 +13450,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Tampered",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
-- 
2.34.1

