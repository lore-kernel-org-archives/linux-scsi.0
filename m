Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758453;
	b=QCoppy/6oHZK7CScFsI8YUnoYxe9jtWrf65W1xGh8uFIdnwrkcIeP6fvUa4wVuKLI6Vx
	 IsMFZu302OJX6FPNYMqzHfdSDoFvBgKqM+AaiEamNvDWmdX5kvcblBYHubrCXqaQqJne4
	 SdThjZOLRxrpn7eFaxolKlydM06Y3mqJBok5uwTrMs/dEKC3d5Y5mxK5iq+Y7Smli+ByH
	 JT4IzgE19nRfnXdbpvUGL7k/RSHbT2t/3cKkVLvXuL8Eg1xsHczmOY1SnR5NmwcnxbVJd
	 +ViMaB7+ekXFrbXdLhMtrz9CsKVHRdcJHD6xtA8gXxX61alY2fOkSqkmRRZ5ixlxlfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758453;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=c4Il6/IXpu1iQ1ioiPuLwIkBuJa8CBZ1UyPt/Cuvq0k=;
	b=tyCCylnAukYFk+3HJ/IVsKUz2On8ExyRSEHI8c9dkOIUe+TXLq+Wf8epTu6YfPTMr7YL
	 4CHxnu0OHpZwrwAdnCNIW5tjsQ42vAIQKL8HHEwY2gmxsmdCiaXSyQBdXLnVs46lciHNL
	 ufxl8RxCr95eR3yYKBb43um2s7wjYeSUwE2TXZa4Pv8ZjyzuGoCAOaxv2jTRgHIGQilxm
	 iosukA0QQJxVYz3IsUZXxDbrIxy9XSOU5Qkw7i4xvHEQwXbEBZEFK3KS3uHo3qrppPsCF
	 wazaLY6lSUfkY2vxL44Jt857Py6lViItjWX8L5CS9hh0UEbyE3MMDE1VPCu0WJtaWtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC1C606A330
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCC1C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAXP_nvlOpqenQ+AA--.9576S2;
	Wed, 04 Nov 2026 10:14:07 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: fix tgtdev refcount leak in mpi3mr_get_port_id_by_rphy
Date: Wed,  4 Nov 2026 02:14:16 +0000
Message-Id: <20261104021416.1468114-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAAXP_nvlOpqenQ+AA--.9576S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1DGFyDAFWfCF4rGw4UArb_yoW8CF1fpF
	s7Wa45CrykWFWxZr1kGF4UWF4ag3W7W3yfGFW0k34kur1FkFW3CF4YgryqvF10yFn7JFy8
	Zr1UJa48Zw4DtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvvb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxUgoanUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgABA2rqY4K62gAAsF

__mpi3mr_get_tgtdev_by_addr_and_rphy() takes a reference on the target
device it returns.  mpi3mr_get_port_id_by_rphy() only drops that
reference when the target device also has a hba_port, which is cleared
by mpi3mr_remove_tgtdev_from_sas_transport() and by the failure path of
mpi3mr_report_tgtdev_to_sas_transport(), so such a device loses the
reference for good.

Drop the reference whenever a target device was found and use hba_port
only to fill in the port id.

Fixes: 8e45183978d6 ("scsi: mpi3mr: Bad drive in topology results kernel crash")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index f1e34329f5a2..0277e2913d75 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2571,13 +2571,16 @@ static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *
 		}
 		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 	} else if (rphy->identify.device_type == SAS_END_DEVICE) {
+		struct mpi3mr_hba_port *hba_port;
+
 		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 
 		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
 			    rphy->identify.sas_address, rphy);
-		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
-			port_id =
-				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
+		if (tgtdev) {
+			hba_port = tgtdev->dev_spec.sas_sata_inf.hba_port;
+			if (hba_port)
+				port_id = hba_port->port_id;
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
-- 
2.34.1

