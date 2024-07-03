Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACA5188CD1;
	Wed,  3 Jul 2024 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032294; cv=none; b=hczDMop4awKoqC+oklgbE5YnWoji1fAg89/FzGlpE4agZSKJfiGosfxT0vrx/CElzRZA+WT8nBS/znRJZzWKFYpZeM5YzZoZrY8tjAz4FWTn0sce8TFdwcbNylPpDgdYt0A5Eb1QjauxzPdEwU7iSy2U8uS+N2gHhBIXWhLA6sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032294; c=relaxed/simple;
	bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK37SOUDMmTvKaAY88UxTVjEh1tbV5hDphg7EWAdGRUuNtePYmpp7cx4RENqjhOIeKlG1jPQGOA76Kf5x6hZo05K8o1B09yfMrh+yLhTfCruzAxbw+rk04dJTqajnqly64bV7Fb0XtMaEw/BksnsTi4WvhR1W4JcvsUm+kRVU5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzlFBa/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzlFBa/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ECCC4AF07;
	Wed,  3 Jul 2024 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032294;
	bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzlFBa/52O37fMp/Dph/twoIY1g2HstcpRFYMM3cnr/XM5PQppmKhMPWCXsxhI5Rl
	 AN/lKBC5ZoUIb6gpWVRpbUHumL6PcxTEuxch7gi/RaL2u7rdDCc+tlAmVQHwAArjfp
	 Ddu4aA2JGPw/QvGUBY06Gwzi0yrEEaILy1/RmEo9G8mLd0QHvq4svLt3x438ibiQNl
	 OFv+PzdcZOfEpbb/TJfECbmQPB8e58kRJhDQ/4iSKYjTmeHle7mk2rQEOP9ug0Q75X
	 n39xCHEbhVDGAbn7NjMleLvCtLtVDbsdgkkyCnalRh3xpUAV94r2EM7MBOXTUporXJ
	 CC19mfM7v20Jw==
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
Subject: [PATCH v4 2/9] ata: libata: Remove unused function declaration for ata_scsi_detect()
Date: Wed,  3 Jul 2024 20:44:19 +0200
Message-ID: <20240703184418.723066-13-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=916; i=cassel@kernel.org; h=from:subject; bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa53Dvr5T1kNRUMLewzM0Tm3iFY87yN/d19N9d2irx9 gl/yXL7jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzkrisjw3T2HOEa6eildmes HZd+8nuzI1+B18u0zHftecNfcjnNrxn+WbetFLZk1V9UfUg8cQub9IR7uVrnTi9rXWQale9c33q HBwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Remove unused function declaration for ata_scsi_detect().

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 include/linux/libata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 586f0116d1d7..580971e11804 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1082,7 +1082,6 @@ extern int ata_host_activate(struct ata_host *host, int irq,
 			     const struct scsi_host_template *sht);
 extern void ata_host_detach(struct ata_host *host);
 extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_operations *);
-extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 			  void __user *arg);
 #ifdef CONFIG_COMPAT
-- 
2.45.2

