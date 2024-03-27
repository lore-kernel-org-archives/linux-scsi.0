Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E97B152DF9;
	Wed, 27 Mar 2024 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561772; cv=none; b=WebH2aOsYrN7gNd0jNK5TCcyRba9t3CVubhY/FQgjxbQHBrXDvmUf4DWiQgaNpM8ZUc5ncpnD3mSHarO9sGOcZEgwl8XajE1XSZdYDGeCq0E3OQqhJBvROKyLnDQ1vuAPrJKugOnwL8SVFXug32GxSvRU4TuImXen7KnJlCCAeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561772; c=relaxed/simple;
	bh=8SLk4f8b7uruEB2q9UhwKeH7Ju0yMWwEkm9l67Jz80o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=indtsNF03scPC09Oc3VIe20xfDmnIyUZefFlVTOw3DoWP38MxUXic1W28W7L6qFT54J5B4PNlz78ze8M2cvD+Cy9wCp0nFo3iPErv+QlIwEWkE6AT1F5fMfXKUxCt9K6R1cSasaYWZ7eZqgt/sCGW1SHU52Vx+8aasB2hdS2fpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C80C433C7;
	Wed, 27 Mar 2024 17:49:29 +0000 (UTC)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 2/2] scsi: qla2xxx: drop driver owner assignment
Date: Wed, 27 Mar 2024 18:49:21 +0100
Message-Id: <20240327174921.519830-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240327174921.519830-1-krzysztof.kozlowski@linaro.org>
References: <20240327174921.519830-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PCI core in pci_register_driver() already sets the .owner, so driver
does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e2f52210f60..6a1900e96a5a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8156,9 +8156,6 @@ MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
 
 static struct pci_driver qla2xxx_pci_driver = {
 	.name		= QLA2XXX_DRIVER_NAME,
-	.driver		= {
-		.owner		= THIS_MODULE,
-	},
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
 	.remove		= qla2x00_remove_one,
-- 
2.34.1

