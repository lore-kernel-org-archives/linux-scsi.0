Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC815B55D;
	Wed, 26 Jun 2024 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424890; cv=none; b=DC6z2nlXDTdZYUGzjebyPYFc9ExENqTtmdxLa2bq6WYdFrX9iwLRlzKSwrcEJk+EV31/clCTh4gdAQkpP067+JtUWlp5z2u53Y0dcnkZ0iKsU2JPf2WLcaaltgYMMuTNdWaCQYT1FWOhNTU4iRDTD94P/ROXbBpVVZFeHiZOm0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424890; c=relaxed/simple;
	bh=2SyEIZRwoD9Q+scRUl3XBQp6V3M4r5BLXo2ZgFirchI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk3rbuFBpescrottkyHIbxIB+D9K39w3HAFuF+pFiBgpOMNlElHJJ/DpPce5+GEkgh2Vz8BOwmh0G9uSm8oEsu++Iz0mqyyCCyleNwyA4VSUsf9EcuRDRR8dDOxsSvxFjgPTFa8Of2y0ZIz/MReC98O4MMIv9vT8RHR0AV7H7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvJCGxDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvJCGxDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D69C4AF0A;
	Wed, 26 Jun 2024 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424890;
	bh=2SyEIZRwoD9Q+scRUl3XBQp6V3M4r5BLXo2ZgFirchI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvJCGxDZT3Vq8ZqjHfG8J0BCqjGkuUV3/QhyX7Qj0n8Min8ejVRyGmoH2s9x9RsC6
	 R2lRDOH4XEfZCuY96ABMTiuJYcr7iPr4LebgK3UB6f+RdTP6xWYKEavfxEUJLRFWyj
	 XZznAvB8ezzuzsO8bD4A8U0hnsSLVcgHKRSHVIiUoaYO97d1h/QyuhQWMeyW6ESCM+
	 +m061ifVesLWmNcLF8k45S8zUi1RAZYLUdAeSG0taySVtZLy5Kb10bt9cjigl2XNn+
	 wc8DuTYjBWUYpLIzgl9CM9dMxlrcHCMwbDjV/t75e55oCaYUPUsnmWb3rDvC2aqge6
	 V0SAUr6MKJA+Q==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 06/13] ata: libata: Remove unused function declaration for ata_scsi_detect()
Date: Wed, 26 Jun 2024 20:00:36 +0200
Message-ID: <20240626180031.4050226-21-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=820; i=cassel@kernel.org; h=from:subject; bh=2SyEIZRwoD9Q+scRUl3XBQp6V3M4r5BLXo2ZgFirchI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwh1rJRxC54vredxMtboUeGnL7NdPO5vkcqp7C4O1b vJevryzo5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABPxncnwz+px9uPk1MbVp7Yu O88stvcLk4J3wt+I73J6i/pMJAPqShgZ3hXLxG5h933J/JNL5Mm8RWWN2rdCRQ6+tBDQuBcT7iX DCwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Remove unsed function declaration for ata_scsi_detect().

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

