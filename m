Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30111DA313;
	Wed,  3 Jul 2024 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032300; cv=none; b=ENGlo+Dlz1GHTrkVllZw6Hs/rOW6Qmoa3U2VkBk0LGoQ3N8nVtNdwaYiRzSd8/iXvc2Gfq7nerKSMO7aZtxdbE8Sfb85oj55Nvhy5DUT6m49IBqXFQEBOXoL9FAhUANmpLDTPLLvdiffh8TU4zUAh3NxYcqbBJOiRBqRykcy43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032300; c=relaxed/simple;
	bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IguhSQAV7ZIhmWxCFX1RpelqGbVXtV0ZAad7HFXyRsHJRLBCeSg8dz0uvfDU924RI0bE6yzOCn+lptxigfuE+RsXWtGVr9USZ0WtgbT7prcBNYoDh8fb6rKJUdYeyAa4F3OLYea2/raB2ZzJvu8zxP2IopHDtD2C+BYiLYDNMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jU+kF2F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU+kF2F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718DFC4AF07;
	Wed,  3 Jul 2024 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032299;
	bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jU+kF2F+1IRMPGdcEL5pvYTKRYOLB+TDnOSTZghMDIqdzaZ8ebyCdpXqScTBwhxhu
	 3viSVIsr8YTtAyjkl6NCUd14uQOCkMgN4tSOSuCw4y0vyIAhD4ZRdfHtJ6tOkHTQUl
	 e1q/EEB6ywzOm+6+sirtxaGE2oTYxT2OabLxgvt18bzdYAtxB+PNS7938ktEeN3iwc
	 UEWaDPeeuEck6YKjj5CmbcLSUm/a0fyIDBk80HmDb6MxVCaECc7sCzQIP+9/vefhCj
	 lLYwfF0jZgIvwzX2PY3oT+9sPVTc0SE3nGHJCDoNQxUOKNJqXtbSBB+6mC5bnJeIjo
	 YQj+QD9XnSUYw==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 4/9] ata: libata-sata: Remove superfluous assignment in ata_sas_port_alloc()
Date: Wed,  3 Jul 2024 20:44:21 +0200
Message-ID: <20240703184418.723066-15-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=822; i=cassel@kernel.org; h=from:subject; bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa53BzF9luvqZuwtOyNWcui829BO7Z67Zk9PyYxTalO YXnJdfCjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExEMoGR4XtPdFqsRWu484F2 warcxHOn3j/0NK1ceX5lffKD1QE+HowMV4v5ctfv/Ve6V/hT+HxVxnrJ+4/bGR1b98k+8+QL7hT lAAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ata_sas_port_alloc() calls ata_port_alloc() which already assigns ap->lock
so there is no need for ata_sas_port_alloc() to assign it again.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-sata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index e7991595bfe5..1a36a5d1d7bc 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1228,7 +1228,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 		return NULL;
 
 	ap->port_no = 0;
-	ap->lock = &host->lock;
 	ap->pio_mask = port_info->pio_mask;
 	ap->mwdma_mask = port_info->mwdma_mask;
 	ap->udma_mask = port_info->udma_mask;
-- 
2.45.2

