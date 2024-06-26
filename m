Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32B18A93E;
	Wed, 26 Jun 2024 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424929; cv=none; b=Hw9tcDeVd7ssHLt1L3oBdQCn+Hs6/NPERoSTiVhb9yVMaEkY9t1zGGvjXaCRfyRo3H0hk8TaoXecsd1ksUFKClxr4aGjsWoaViORwxrUo1C1v34ypXI0pYk2eiAsd/8UgtHWiBrpS/nqqlkZ8lyteZzLoU2o/oM+BIh+dTP4cmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424929; c=relaxed/simple;
	bh=UAY0ldpH6pilPESHp2oE7IoyK/F1c5egr25Iq7TAGmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPMfXB4ZvEN0Ib3ZzWaXk89X4vMwGFKYl44koU1fAsKmmGWAJznzbkoAwn3HMBgQqGsuWzb++K3a9HRDrhlFv4CfUMt4DTplg25NwSj/xqw+VTXmieyAQIk5qAQUta14i+OAyAtDB6GPPvvfEkU+XarbMO7lkfy0OmRRLQxInDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAUuHnyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAUuHnyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3B6C32782;
	Wed, 26 Jun 2024 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424928;
	bh=UAY0ldpH6pilPESHp2oE7IoyK/F1c5egr25Iq7TAGmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAUuHnyb3lHfF2pinK95cNgCDa+TSZD/v9fDNzi1boJ6GR6h4G4tKIFUXi00fo0oY
	 apIDyjLV86iCVvU8Gq7COf7R0Qqx3FzioIza2CbllnD7DZAVqBYD25gmcKPwHunnQi
	 jX5VO/VLTdvSi7TqOX54LfdcZ8jT9yXatpKl89dROmQloISgZmpL6CSYDSvKGwo896
	 7uZ65eAVplObuuwIr7719/Cdb0iG/xRVkTyXBFOq0FGUOstsgSs5Bqeh9kSv1KD/M0
	 xJGQ5T/jYOCiNsVp54RBJmLX3we38yDqGEtbQJiTT+tYI3uuQHYKqOn71jTJOfgXSf
	 eOH0HJewIo2zQ==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 13/13] ata: ahci: Add debug print for external port
Date: Wed, 26 Jun 2024 20:00:43 +0200
Message-ID: <20240626180031.4050226-28-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=cassel@kernel.org; h=from:subject; bh=UAY0ldpH6pilPESHp2oE7IoyK/F1c5egr25Iq7TAGmE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwl0OKmSze751+e/3x2OW45fo++U8PUn/r+2cLM76c jObWVRIRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACayoIqRYeLnFv2rLQZfwyyE c33m9u+/tnWJZGeC2eGU1ec3Xr3hL87wzyR/kwqzdOmqf10Jux9uXF9X/OrB3oJ3t+adzXhccCJ 9GRsA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Add a debug print that tells us if LPM is not getting enabled because the
port is external.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/ahci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fc6fd583faf8..a05c17249448 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1732,8 +1732,10 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 	 * Management Interaction in AHCI 1.3.1. Therefore, do not enable
 	 * LPM if the port advertises itself as an external port.
 	 */
-	if (ap->pflags & ATA_PFLAG_EXTERNAL)
+	if (ap->pflags & ATA_PFLAG_EXTERNAL) {
+		ata_port_dbg(ap, "external port, not enabling LPM\n");
 		return;
+	}
 
 	/* If no LPM states are supported by the HBA, do not bother with LPM */
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
-- 
2.45.2

