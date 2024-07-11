Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12AB16DEA6;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=QcItFva2clQQqZ1qYBW+E/o02bNKTNYHrBC8xJIUCt1XdsAfJ3aijYNHJGKMrdXcNfBy6q9TigKKaG72oeDsPKi8ZHmnKBC2wH5Ez/FN0mw3fB1Fc4o05Uo9xJH1uoVA1jCD5B2WBOmGWVVP4KKf3/QEo4eGUvpYQSR78b66u7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=uTVAghxsaNEV213sw1BkmG0oj7wQ6hN2vTa2+UY7Ohg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IyIX3RjbjcSLLgPXm116xLNi5M2kgBc65JKAKnBGmErJ1V5DQRGhQDq6MzIR88UOxX25Z8eY5KxQ7Z2W/1fKav05EtSIHpTLOPZ2KxyPwAzRMU3PvezF0UvEcmE8MCT3+To4vkjJeqlgZuHK1Ervu8vX9UAMitLVMNP5kUPZjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYhFHcqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYhFHcqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74156C4AF11;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=uTVAghxsaNEV213sw1BkmG0oj7wQ6hN2vTa2+UY7Ohg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYhFHcqdccBoKu8q64Hd84+hJUzs2L87MSgWqsSRxM7zbJ5huUChzXkf9XWR3Yir1
	 naI+INKAiCvrMNmm8pQT92fXuOCvbyVg/ODon5njZjTBnCxu6IZL25sXuwnZmuNLak
	 +eRFDeGfQ3JHP5jerIPG5MV07DG9aF0IDgCv7b0PQHJccFmfYf9mdbVt42NLIAqR+B
	 aehz3fC2PYxXTu8MCaQeYTp5uqOmlbo0U7T8Gp4ULzZaccAbDGtBwa4IEBSU+iZYO5
	 N2iDduVTFg8FJe/10Z/dZWVsp7UkQzUo6sbmpY28zLRgQjdR7VADYF+lUWtlwyVBze
	 xsxseDJ94hkgw==
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
Subject: [PATCH 6/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_4: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:20 -0700
Message-Id: <20240711172821.123936-6-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2278; i=kees@kernel.org; h=from:subject; bh=uTVAghxsaNEV213sw1BkmG0oj7wQ6hN2vTa2+UY7Ohg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBY0xRaGMDDwrHBvkFQhoh6p0v0bM0OTDoFto 6yTjD2pKmyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWNAAKCRCJcvTf3G3A JiGUEACBxXVIes36bWRWlOikkcY2Xnpx0VBDqLTtI4KGlXy4oJyTD0nUBaG2yeSRvJ18jZcwR9B gMiVUXhzleFQcTuKywR6dXpGHIWwmzMwe2P3u4p7ISVg3xBVfxgS2l74QKx9tC47BSAODnI1Agl ffX2QIZ/Pvkzk/HU4mvaxIS4hw285aGxxI7nLLw+/arJJi/9xSR16OXecltT1xit/MBt3OXwHT/ l4Hd3HzSVRqUbtBotU7x1tzeSyhLrRY5l18np33Ha6BZPWCGVgBxcmeA6qBARs4ySEg14T/DOSj 4jox4WztvKG+oikdjNaj0HB/cJnxtuIP9kKmqrLKMIBTvIbxnUjXKd6vV/9C6NtORvqxlT10Gdd Ycqpv0Fd4xoRy/zabFSsdXyO2+AW48JpQ0RYVEK3NvtIaWv+8Zi000Zh1B7dGzLOzxbwkE71FFU znWY89bdvHQctXL0y6Sb2zahbHS1QY6xydkwmeyIVFywgYq2pu/nRuklQm7zfgY2v8O6vL9bVc2 Rirn8DOW1cKfO6gyg3yCMJpKmjRmScO74Y0oIuN0ngeqbC7Ee5vjKhwGHgiUpVKddmmReX5yd4z eNs+YNnDQ4mtlkOLNVXnEtl1/gEQYU4IlGDXlesRbors5iTmrdndBlZ62jowy4d7Ao4oJlKBBJV 0FfZx//tzAKxYsQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _CONFIG_PAGE_IOC_4 with a modern flexible array.

Additionally add __counted_by annotation since SEP is only ever accessed
after updating ACtiveSEP:

lsi/mpi_cnfg.h:    IOC_4_SEP                   SEP[] __counted_by(ActiveSEP);  /* 08h */
mptsas.c:        ii = IOCPage4Ptr->ActiveSEP++;
mptsas.c:        IOCPage4Ptr->SEP[ii].SEPTargetID = id;
mptsas.c:        IOCPage4Ptr->SEP[ii].SEPBus = channel;

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
index bac49c162165..1167a16d8fb4 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1077,21 +1077,13 @@ typedef struct _IOC_4_SEP
 } IOC_4_SEP, MPI_POINTER PTR_IOC_4_SEP,
   Ioc4Sep_t, MPI_POINTER pIoc4Sep_t;
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength at runtime.
- */
-#ifndef MPI_IOC_PAGE_4_SEP_MAX
-#define MPI_IOC_PAGE_4_SEP_MAX              (1)
-#endif
-
 typedef struct _CONFIG_PAGE_IOC_4
 {
     CONFIG_PAGE_HEADER          Header;                         /* 00h */
     U8                          ActiveSEP;                      /* 04h */
     U8                          MaxSEP;                         /* 05h */
     U16                         Reserved1;                      /* 06h */
-    IOC_4_SEP                   SEP[MPI_IOC_PAGE_4_SEP_MAX];    /* 08h */
+    IOC_4_SEP                   SEP[] __counted_by(ActiveSEP);  /* 08h */
 } CONFIG_PAGE_IOC_4, MPI_POINTER PTR_CONFIG_PAGE_IOC_4,
   IOCPage4_t, MPI_POINTER pIOCPage4_t;
 
-- 
2.34.1

