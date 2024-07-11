Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684DB16DC17;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=K15YL9Oe5OS+NX0oqRgBU5LHTj3t98imi27vk1oVPolhEFpGUP8K8DGgwje3qab/R65cn5PDZ7cYsu0IidY/w9agv+qo/Latjte779eyIhbX+eOH9JuQkBSfKKCPnAyu2xxd3mcudfQu5tPnLIalaOg+lsJ04s185NtE6zf4hRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=tlFNtdPXIsjyicZF+y3g8YyRlX+dG+Y/x87VFaz+p5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T4cE6uWe5X8TgfrI9My929mOogXpI6EjLUL1CGHeU9UA4hm2rVvRawq7ISguWYLr2N+/mNVPozPetw7qy3U1Dvo6sJsr6e/MZZmygeq3AuyWD7EN/7zHg6nX0T0X7qqngSnCAspG298Pyz1/K5DVYv58NkfAA6NRag62g4bomYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kW0d/7d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kW0d/7d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16062C4AF07;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=tlFNtdPXIsjyicZF+y3g8YyRlX+dG+Y/x87VFaz+p5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW0d/7d5Alt7O+762Ma05vwt7bgo9oDQJ6QTTq8Qo8BKakNtMkX1fn1Nop+s9R9F5
	 UByrDK+FEb1qFagvYD/xuP1mJUsv2zdDyZu/3BmoEUEMNP4zuHWprJP/uZyiL34Kbj
	 mdb2KwuchxnHdqnx9BSF4olEPu6dpmh36KgHfu/mGm6u9cVUdYKQAt2pxzsAcmIKc5
	 F/J50PJBJxFyJ4t2kju2csbyfO+pqaWOmBriKHILUt6XcqqHQwJYJTw/eBVg+mV1TM
	 eye10XbHwTebPYxOxXT4INhYMRmAGB/hwaiQpff4aqms6LuapihEIA8jNdJCv/+Pk/
	 fRojRIZ/NKxXQ==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] scsi: message: fusion: struct _CONFIG_PAGE_SAS_IO_UNIT_0: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:16 -0700
Message-Id: <20240711172821.123936-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2852; i=kees@kernel.org; h=from:subject; bh=tlFNtdPXIsjyicZF+y3g8YyRlX+dG+Y/x87VFaz+p5w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBYzm99u/pI8tnb58UexRVIlgpTl/2by8ge3B JVT1Tp83WaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWMwAKCRCJcvTf3G3A JndXEAClVG8hZ1gvChJQI1q05OsMAnd5K6vjz1iD0F1YVbxf1Io/lmnMbvyQkBaGIbUUyD5HX0C nswXfB9Tn4RouUs1NfnAZbgEC010eVqzKW3ploKcZ4ocLCLLR2T31lssRQH/pXT7uFEgx9k5HUP 8QzvJ5gbkmzLB0/QYNSrJC2yYaOXqdC3jsoc/O4vQaTX6OmF3AO4e1u4ge1c5AaS6bmD4m259b2 3M6nzZRF8lLRwJ28YZtLNG9vDEYmql1fI793PCklXIgVd6BRzx73/6QyDKAhSAbHPDxiM66LyqD S3iQOdU3PLKKrX9zSs+Bgsa2lRVlS8BzPWnzcL9s0lE2/BcfKn6Opx+I60wDUO1lou4drEOhHyh pSoKFYXZCfb+/4s39zakPEWR3UxCLafSHrQUB9kj4Wt5MvK0jhFgmZBPf9gOKpzI7kJuG8XCw9P EJjR7Iv4UYsKoXpLOLF9sOtkLVbPeqDzwGl+Sp3EcLYzijksTvw/lxK2qv10kNHUW2tGGnfiRNW EcV20TAb8rw5dUvwiqg3tIQFsT+LxOB2O6isQAhj2yWMlP6mdD8R+0vn6r26JQEX5+BptDHUJNi bR85cDX96CrdOONyK/FY02wJM5y56X3CW4YiIm5PGFRnYLilfKIedWmqsIBItAZR/NFRPMDLf09 K+WvqVTsAa4tEGg==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _CONFIG_PAGE_SAS_IO_UNIT_0 with a modern flexible array.

Additionally add __counted_by annotation since PhyData is only ever
accessed via a loops bounded by NumPhys:

lsi/mpi_cnfg.h:    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[] __counted_by(NumPhys);    /* 10h */
mptsas.c:       port_info->num_phys = buffer->NumPhys;
mptsas.c:       for (i = 0; i < port_info->num_phys; i++) {
mptsas.c:               mptsas_print_phy_data(ioc, &buffer->PhyData[i]);
mptsas.c:               port_info->phy_info[i].phy_id = i;
mptsas.c:               port_info->phy_info[i].port_id =
mptsas.c:                   buffer->PhyData[i].Port;
mptsas.c:               port_info->phy_info[i].negotiated_link_rate =
mptsas.c:                   buffer->PhyData[i].NegotiatedLinkRate;

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
---
 drivers/message/fusion/lsi/mpi_cnfg.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index f59a741ef21c..c7997e32e82e 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2547,14 +2547,6 @@ typedef struct _MPI_SAS_IO_UNIT0_PHY_DATA
 } MPI_SAS_IO_UNIT0_PHY_DATA, MPI_POINTER PTR_MPI_SAS_IO_UNIT0_PHY_DATA,
   SasIOUnit0PhyData, MPI_POINTER pSasIOUnit0PhyData;
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength at runtime.
- */
-#ifndef MPI_SAS_IOUNIT0_PHY_MAX
-#define MPI_SAS_IOUNIT0_PHY_MAX         (1)
-#endif
-
 typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
 {
     CONFIG_EXTENDED_PAGE_HEADER     Header;                             /* 00h */
@@ -2563,7 +2555,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
     U8                              NumPhys;                            /* 0Ch */
     U8                              Reserved2;                          /* 0Dh */
     U16                             Reserved3;                          /* 0Eh */
-    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[MPI_SAS_IOUNIT0_PHY_MAX];   /* 10h */
+    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[] __counted_by(NumPhys);    /* 10h */
 } CONFIG_PAGE_SAS_IO_UNIT_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_0,
   SasIOUnitPage0_t, MPI_POINTER pSasIOUnitPage0_t;
 
-- 
2.34.1

