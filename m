Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF927735;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=VfEdzhzdPRCDUAlEhqhuSS93K02CkaDpiVlI2yyDm67r+shnhLOp0rczPdT74HuETvhLK21qt5D4/NOrTIg+jPzFhg3ogml0olb7o3NFu7eHTq6HM0AK79FzIJ64vnXgCbUMEgdtTnJYpUqGCPZupoVAJ8yvPK8d2qs12OqPS3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=FW3cCFVFQ9UxOSFMNhwCs/UdzXxwEvz5yZH5h49ti2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dk68uFi3qIzdPFg40dANtMTa11Bp7AmnnFis/wrWuhmibLn1aMaDwoNzmk922Xu8YwaHWKVyfaTB5i0hNdvSBlQeujIjjRezLg/TqNVfzyQihYswBzOtu4PSlZoOT8jtsEznoRawU7ySQBlTc/E0HQ8RYzBXlw4YhT9vE2G32+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzP1dxz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzP1dxz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE59C4CEE3;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890022;
	bh=FW3cCFVFQ9UxOSFMNhwCs/UdzXxwEvz5yZH5h49ti2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzP1dxz9lwmjvHPqiw9l278vpnXmGce84c1WI7Pwg9RzYXFwUyTp4mBB1UPZWJa5u
	 7wtMk9I61Xktx/iA/TP337SkRYMgfLoFhlH32XeUL+zOPEOX8ki4wXMoC06IzK46fZ
	 iEd8RgKKUhMGHTznVk6qws2yjucXtGGCEjEdPmkf+DUAGh7JD+FoXIxiYIMQDIvwoQ
	 yOE47L0TehY+R3VZUTPw92zI6v7LrYeWzZJHnRN28kuoCR2VCVj+mbYMjLJkgEIrV+
	 zPfu09ru1Gl8QDXBtcGaCeFc+x6NQRkPb7rlimFTrF/vdSBi7dIM3vOEOXa3n69xDa
	 HLB3goUYac2cw==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
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
	MPT-FusionLinux.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 02/10] scsi: mpi3mr: Mark device strings as nonstring
Date: Thu,  6 Feb 2025 17:00:11 -0800
Message-Id: <20250207010022.749952-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=kees@kernel.org; h=from:subject; bh=FW3cCFVFQ9UxOSFMNhwCs/UdzXxwEvz5yZH5h49ti2g=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLo+U9FopxhVrvZ7/uEMml/WRCbfdWtl19s9bt+XZQ7 yJLs9mrjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIm8vc/I0JQs9M+QXUP9ae8U I/28RIYT4p3HtJ+0Rfwy5VexueZ6mZHhz4JE1ecqXFfyj8ltUJ36QMe65U6LofSVDSsrjxRrbP/ GDgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for memtostr*() checking that its source is marked as
nonstring, annotate the device strings accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 0ba9e6a6a13c..c8d6ced5640e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -105,10 +105,10 @@ struct rep_manu_reply {
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

