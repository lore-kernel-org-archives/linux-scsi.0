Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794579674;
	b=MMQS8Gbq/RISozcP+7ECnXdSnKYrjh4At6QZZIP3GZimm3fR+BNcXUmbHWAqvqhmnq0d
	 jbwVvjNvyCSAgC0f+TVvLPycoi5bjJVdc9y0v09yQyFZKHyDqOFr0JP1s2AQRuWhgE2zL
	 eZUcLe7j9hXOdOod005ybJb9LlLmC70wF8E/AqLrHY15/6OGSgmUCHw7zcWPfqzFf4i6P
	 ujx0aUZ4ZslWMit/10a9I/GZPiELxFYiN729LgTmnD6jrVTOKXwRSYmT9IsX7yQqlQ0QO
	 h0YgFWYD/iDPk3q8VZOG+IfMyTkUDEHFtlrUaiLnNFeIw1/y8gl/Wq0cDf5btj4k6Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794579674;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=DxWC+pcSmHofo/IdAoJOznXzCrZSe1TqYJbrRyVivSA=;
	b=ufK2aELETBiFiplKSw/8v7CaWwSHj1Jd75MDTJE6tvQSk6iyLcM3sN/qwbuDiqABHTf2
	 TrtlG544NzQybKuEhJ6Xhx15U7v1ZHoeZc5V8dymlionN/H9dxB5c5Qy0Ue+Ap7mde3N6
	 uAz6dxCCuRG9x5aj68QiR2r8uE6Qg1n3TrTbXodinDmvgRf2D88V3VaRBfNf84F4w+tuF
	 tgaOFghY9IhKbsskbSLt5pdLQbloweGaRtX84FNKb6O8CsvU8XuncuiBKvRKJU2v113Il
	 i4fvzX94Qu9C6ZaEkSn+LFtA1bjXIoJin1Y7/SLQLrn/qAsPLB82i2bf3t4u8S4EncQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=THoYaZJ1;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED2D606A327;
	Fri, 13 Nov 2026 14:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ED2D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=THoYaZJ1
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 549b5a8a5;
	Fri, 13 Nov 2026 22:21:06 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-ETH-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qedi: Fix potential PF parameter leaks on allocation failure
Date: Fri, 13 Nov 2026 22:21:05 +0800
Message-ID: <20261113-4e14e563a1-scsi-qedi@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1d54895ce03a1kunmce7f27b048ba9
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHh1CVhpMTE5ISkgfGUxLT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=THoYaZJ1kEZoGMg/ODGTcUDmzlfiDtBYEGbhU/a/9rSb0vwbRS8KkTNhLQZ6bvy5XxDbELWmD+WH/KWyqdqytakEjyioTBrV0BFleTE3uxPUXVQ8tNg6EwcZyzxX51vzflxwMN1qaGsYODuq9kGlMKhS2D0eq2ZrtrUtddTU4FQ=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=DxWC+pcSmHofo/IdAoJOznXzCrZSe1TqYJbrRyVivSA=;
	h=date:mime-version:subject:message-id:from;

If global queue allocation fails, the caller skips PF parameter cleanup.
The CPU queue DMA buffer and the global queue pointer array can remain
allocated. Release them after the partial queues have been unwound.

This issue was found by our static analysis tool under development.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/qedi/qedi_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f394fcbb97e7..c73f9769549e 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -854,6 +854,12 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	rval = qedi_alloc_global_queues(qedi);
 	if (rval) {
 		QEDI_ERR(&qedi->dbg_ctx, "Global queue allocation failed.\n");
+		dma_free_coherent(&qedi->pdev->dev,
+				  qedi->num_queues * sizeof(struct qedi_glbl_q_params),
+				  qedi->p_cpuq, qedi->hw_p_cpuq);
+		qedi->p_cpuq = NULL;
+		kfree(qedi->global_queues);
+		qedi->global_queues = NULL;
 		rval = -1;
 		goto err_alloc_mem;
 	}

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
