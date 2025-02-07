Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AD913C9A3;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=tY+mEuCqnnjnMdcj0WB/rpeJ5bFZW5JDy77HV+kr+zcFmym40Ovu7T7eQ2/1cbW4Di+DvqQqVqyO4DKAq3mTmnBoXFRpZHA4z2oFUwnaUI0McO83e8PaSw5YCQQ7kXoZPxUPvJZTq2asbDRvl3QZnf1t9+oGf/C6l0NEkiajdc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=Opu1xXyyZ3aCe64Oqm1K1/bSvXQOECiF/s4lP93IAgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kiy2EQfA+3hnvzVpx/FJQ4id/5Z2g6VOGC1xlQOcihj5+wlpT3sJj2jXYyFjtGlB7HuOj7KIl5zir3uKQ34A/3Nu1CAT9qWuZZJQFwZRCHks98yX982fkU+11tHSb5+8KCMKZhbKdzpL6y/0agp5URd4MX2FP4VVoQy8HVUlHpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5T51yNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5T51yNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F3CC4CEF4;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=Opu1xXyyZ3aCe64Oqm1K1/bSvXQOECiF/s4lP93IAgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5T51yNscCYGt1Edn/A2clAER9RG9za+q2NWF0ds3FvOGP3Gm64us8UWo6wdz5gRj
	 QwyU/+MHcPG0QHTbSwqSKxEIz91aellUc/HQGKfxhSvse7LXa3QuCM+aq+3osYHNcI
	 S4y2Efpcd62r099O53jJ/nt9YhyM0vIKuUppXrqDuLz2CUCQUJTg1ii7DaabB0t/z6
	 vRYjzcLLdKRdILI79jwnfg5KvR8kqmOaxDYQObBEGZUVOtstXzPO2t6pQaez3tJDYw
	 PPy2hPh0bWu29g5djjfrJBXi5oBTFPV73BsPJ2RhAmDbh6UWMvsZZgiSGk4SoHUAnP
	 XkcJPHZjzZEjg==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 06/10] x86/tdx: Mark message.str as nonstring
Date: Thu,  6 Feb 2025 17:00:15 -0800
Message-Id: <20250207010022.749952-6-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1065; i=kees@kernel.org; h=from:subject; bh=Opu1xXyyZ3aCe64Oqm1K1/bSvXQOECiF/s4lP93IAgM=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxVb/a45ye1N3nZuqsmMqdt3iX/LT7mgOIuZk9miY tKcyQynO0pZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACbCoMDwV+aBrT9ffG/FQZ6r uj1PbPwD7nH58IRq8pqwzop7MbOHgZFh6sOyGdatOv9PRHA8uLy6X+Rxw6H7l6a1iEf+kXrNbfm MEwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for strtomem*() checking that its destination is a
nonstring, annotate message.str accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-coco@lists.linux.dev
---
 arch/x86/coco/tdx/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 0d9b090b4880..977ab1ffa3fe 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -170,7 +170,7 @@ static void __noreturn tdx_panic(const char *msg)
 		/* Define register order according to the GHCI */
 		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
 
-		char str[64];
+		char str[64] __nonstring;
 	} message;
 
 	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
-- 
2.34.1

