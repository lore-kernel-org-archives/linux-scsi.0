Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E22417F6;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=hRlcWJsiZAo27QDV70EQERFU76Mw1a58BM9jtv2O6zTeqTTv2h6e7Y1m0rnTC9UzLLGZEo7ZSKeHgZGx/96DwiKNjjf+I2gUCV5yVmDGb6s8/SAl8LxHdS9H/g2VHxLdXB35D3Qoyz+0s93PVw6ZDj2KlpzrUyBi6cIw8rqLr58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=V/auFlplC4lNkwyu5TsfDCGYYHQ1U9JN/b/NDVqoD00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rx0Ul4NGq/zHUG03EmD7Wnt2QSfyvlKaqqZNqPtyIr4JIQMme9Wl5SitLq0HERBVZfRS2YHsEPQJ8SU803u27mxkZqyeR18dQ4g9izkjQQ46IAKi2PdORdHtLJz5PRUn/adgU2DFG+AfD9aAONVcB7M+lWr1QV8xvYi20qoISn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5cIRmNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5cIRmNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0EFC4CEE5;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890022;
	bh=V/auFlplC4lNkwyu5TsfDCGYYHQ1U9JN/b/NDVqoD00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5cIRmNa5X35xmajVBLOhiGFfSp2lvzvXBoiBeT1Tt2OUX3yuMiFPcc8ddVzZGPpO
	 yLMO98/Z6MwLIUsL8wFm+A12crw+lebpAagqrT8fz870tdSYW+T4Lpvmlzy0htbl+b
	 Zv6AZyHSQapUYt1NtQqmsnSGcVIMAyLX8drKpTZbfo15xzkUfOQi0shDVDAeBAsgKV
	 3ilaKPe93nxFgPMxSZF1IrkURPCPSH7jrbdqSfBcR7lAENV3MHOGoYthWWcxLvpuvf
	 n3uI786lBewgzRyYljbOTa+zmHOzRHHhIBcD6LBmGV4VsMf4EUaQUEfWuG4qGkxOoN
	 Pu3QNMjmVr0xg==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Erick Archer <erick.archer@outlook.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 03/10] scsi: mpt3sas: Mark device strings as nonstring
Date: Thu,  6 Feb 2025 17:00:12 -0800
Message-Id: <20250207010022.749952-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295; i=kees@kernel.org; h=from:subject; bh=V/auFlplC4lNkwyu5TsfDCGYYHQ1U9JN/b/NDVqoD00=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxWqNi1nvPp8fmr5YTfTptvFD+s+f215tPHkviT+e UwOZdpOHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABORNGb4X3nzaKNp352Lyss+ ODf/tZzZuvmA4GzfOu/W1zm/Fj3J+Q5Ucesn/7by+VG7zwfK1sw5OG2r8qqO/McPnWYwFcx4LWv NCgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for memtostr*() checking that its source is marked as
nonstring, annotate the device strings accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 587f7d248219..d123d3b740e1 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -606,7 +606,7 @@ typedef struct _MPI2_CONFIG_REPLY {
 
 typedef struct _MPI2_CONFIG_PAGE_MAN_0 {
 	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
-	U8                      ChipName[16];               /*0x04 */
+	U8                      ChipName[16] __nonstring;   /*0x04 */
 	U8                      ChipRevision[8];            /*0x14 */
 	U8                      BoardName[16];              /*0x1C */
 	U8                      BoardAssembly[16];          /*0x2C */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index d84413b77d84..dc74ebc6405a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -328,10 +328,10 @@ struct rep_manu_reply {
 	u8 reserved0[2];
 	u8 sas_format;
 	u8 reserved2[3];
-	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
-	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
-	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
-	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN] __nonstring;
+	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN] __nonstring;
+	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN] __nonstring;
+	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN] __nonstring;
 	u16 component_id;
 	u8 component_revision_id;
 	u8 reserved3;
-- 
2.34.1

