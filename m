Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61F1B4F0F;
	Mon, 19 May 2025 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747644984; cv=none; b=QS7CHNn9+9LNcPmNVQdeTqXkc2KqLh3xMmv4TKKdXffHfac8OGnF4a13a1LjXdt7V9e3/0KJ0sLvrB2Ryoa6enKprlD2aDatBB042+Fr3JDlX/u/kEvGwU6Irz9JWe92zqokuRXEexFyDYtODWrKWS/maUULqM17K0mwNgG/y6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747644984; c=relaxed/simple;
	bh=qpouYrWqzs13/DTjXJBCi/42yy5oibCTN2WW2JVHgdA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ncXkpcpWM2U9meLEX9AvA3PXS4HNgA2c+ucx1fj895nB/e701KyvuetzjqcbSeyjRsATLs9tPJ3euW9rC6eUt1D6fbzYd6xAtbd74BMmHHTTS4j1oHyPsKcUPkNbVuJek5Uskjr9K7gwpB9+R+4JdJJJ83yPi6LLcevS9K6OBeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowABnpykq8ipoTR9sAQ--.11645S2;
	Mon, 19 May 2025 16:56:10 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: satishkh@cisco.com,
	sebaddel@cisco.com,
	kartilak@cisco.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: fnic: Replace memset with eth_zero_addr
Date: Mon, 19 May 2025 16:54:57 +0800
Message-Id: <20250519085457.918720-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnpykq8ipoTR9sAQ--.11645S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW7CFWkKw4UAFy5WFW7Arb_yoW8GF1rpF
	93t3sxCFW7JrWavwsrAan5Cr1avwn3ta4UC348Jas3urWFgF10ka45Jw1vqr95GrnaqrZF
	vFyDJry3K3WrA3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r1q6r43MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUqYL9UUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/fnic/fip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 6e7c0b00eb41..19395e2aee44 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -200,7 +200,7 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
 		return;
 	}
 
-	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
+	eth_zero_addr(iport->selected_fcf.fcf_mac);
 
 	pdisc_sol = (struct fip_discovery *) frame;
 	*pdisc_sol = (struct fip_discovery) {
@@ -588,12 +588,12 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
 	if (!is_zero_ether_addr(iport->fpma))
 		vnic_dev_del_addr(fnic->vdev, iport->fpma);
 
-	memset(iport->fpma, 0, ETH_ALEN);
+	eth_zero_addr(iport->fpma);
 	iport->fcid = 0;
 	iport->r_a_tov = 0;
 	iport->e_d_tov = 0;
-	memset(fnic->iport.fcfmac, 0, ETH_ALEN);
-	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
+	eth_zero_addr(fnic->iport.fcfmac);
+	eth_zero_addr(iport->selected_fcf.fcf_mac);
 	iport->selected_fcf.fcf_priority = 0;
 	iport->selected_fcf.fka_adv_period = 0;
 	iport->selected_fcf.ka_disabled = 0;
-- 
2.25.1

