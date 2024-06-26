Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9483118A93E;
	Wed, 26 Jun 2024 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424901; cv=none; b=bYjoUpAqGcTcUNcd74Sk5Of3iVICrwfripge5gtQ98dEPVBxRqljOTB9Qw/krtcl34sawhew4iBLRojG+mxNK8m1AELWi0g/gziD6HCJdDBmwNCQBdqgnI2hRzjDNmx/55hn8HnkD0/0BMtW4VVTxughUiusU0XAB+rzgD/8nIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424901; c=relaxed/simple;
	bh=KQ3dNKT37gMd3OcJbj2qIxQav+yEREEO+aRB22o7Cjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnGU1jH6993ObICZTAO66eImpsCE3RT851BkGrfL3TKrNpZMKbacP/7QsBWvvSI0jBBf/JKgNFYCbS4J/Fyl+F/3WRmB+Uc2M/yOzVrLC4VjLv5wuP+f0OWC2RAGP/8n47CiDeS6l8ORWEotvg70DLEGgR7NoD/DIwne1rLfh5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cd8foiQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cd8foiQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFD4C116B1;
	Wed, 26 Jun 2024 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424901;
	bh=KQ3dNKT37gMd3OcJbj2qIxQav+yEREEO+aRB22o7Cjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd8foiQSgd2+eWVhKfEyhIMlerEW4zWTs3EG+f6dwgTQ012m6BAXa34VeKZaJ/m4C
	 CZWPsi0YNP451JhqrOvzpUSlWrBnxEjkg20ddVmXrUb8Q8tpyivXRiUwepwq2yPvHc
	 AxrzqRghFlkVcyh6DbQ/UjAlYe1ha+DhqJpkG6VqdR3Vlq2xihmxRolYGzNBhMKvT1
	 l9fIHmB1jTaqj1W0NY2qNoYwjr4UwKtAqDrIrmI+jwbBJyEN9efeQh+71i/ls2o8Wn
	 nm6ndTSlbpmxbSq91wRQf9tMe9btAtUYqdRFaKBCUV/whNdePZhiM92+xtDtPGjKBU
	 6djENK+JVfPZw==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 08/13] ata: libata-sata: Remove superfluous assignment in ata_sas_port_alloc()
Date: Wed, 26 Jun 2024 20:00:38 +0200
Message-ID: <20240626180031.4050226-23-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=776; i=cassel@kernel.org; h=from:subject; bh=KQ3dNKT37gMd3OcJbj2qIxQav+yEREEO+aRB22o7Cjo=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwp0Ktv9y8NKMcW3VfvN4le6htbKNKXINO9O37P09+ QxfvGpXRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACYSGsXIcDV1Z96yTBHnshzp TR88ivJPr4iXr+xqq53utjjzbmA5D8NvlncqxlLhM4qSBCdJzxGy69pakrmOe1WxalS+a8MMkz3 MAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ata_sas_port_alloc() calls ata_port_alloc() which already assigns ap->lock
so there is no need to ata_sas_port_alloc() to assign it again.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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

