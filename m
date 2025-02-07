Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C313BAE4;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=tDyPtcCvzwAwh39QyhJmihn/cNWnnFnGrbZBD7HsnGeW6VAn3sWrrmoMuKa2DRMIsgGE4ePBKPGUGFYlHFGyYh6pMGFL99lWbY3/Ygez1GDFk/TSgrTuIqnJHvOR9S0Z4IyXIVYXgPtxCAAXknq9omdyn8d0S8ysHVLA/HxsEKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=CbM+GnN2ANWE4Vaa6vW+0UlcVuo8j7mn5KKDXvIqbBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IapRX5rFNobvE5Wb95Gn+NCZUGeSbMsywC3zov8yLM9A2foHpIbXmaW5ummKCpRV+BWLvS4z//goCkIQgq2+lgmOu2Rt40Tv2anGM1qi7Owc3VbALBHKviqn8kz8VMLxzd3sJM+AaoxR+a4fRkYpVt0cleuKlLQdtmhuINlNaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr6304fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr6304fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51079C4AF0F;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=CbM+GnN2ANWE4Vaa6vW+0UlcVuo8j7mn5KKDXvIqbBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr6304fwYeeuZX2bZra7G3/Z6F7SDGU+yPYFysuApvvLQ78eLazkWtxw2rXUBF8Jp
	 L8cijDC6lpAngQLp6PJKujxEn/Bdf963Ej6mZgNFG1Aawv2z9F3kp/57meY5/9jYg4
	 i7J7yBE6dZPkn0is1yZmZ4EGPVrAW2H7y+izwbjdRJaKtqsXiFKotZ3wnFjbhq8fKr
	 8TBKS9/WRC0cpWedQfE9j8jV7Dm5pCM8NB5IiH3hqVn21PPazHdYa5RDTiTfpL4xuk
	 f0TfUwyBhvDZTBLxKJUFW+pnth3OQaoiIK4m5R+ENtKqWvs5C8v3EhCZx7vpxyWgW7
	 P+JN0kvDAi58A==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Subject: [PATCH 08/10] nilfs2: Mark on-disk strings as nonstring
Date: Thu,  6 Feb 2025 17:00:17 -0800
Message-Id: <20250207010022.749952-8-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1048; i=kees@kernel.org; h=from:subject; bh=CbM+GnN2ANWE4Vaa6vW+0UlcVuo8j7mn5KKDXvIqbBE=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxV3RF3+srip7wUnS9GrT/Uvj0t4nNrjt4nJdFH9/ 6asj6EXOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACai84rhr9DLb6s795Rcl3v7 za1JXsPfK19jcnJQKu9iQZfXBoknIhkZtruvZYuL/3jdUpdxg2f7eYdDJlfjG6do2U5c/pJnGas cCwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for memtostr*() checking that its source is marked as
nonstring, annotate the device strings accordingly using the new UAPI
alias for the "nonstring" attribute.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
---
 include/uapi/linux/nilfs2_ondisk.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index c23f91ae5fe8..3196cc44a002 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -188,7 +188,8 @@ struct nilfs_super_block {
 	__le16	s_segment_usage_size;	/* Size of a segment usage */
 
 /*98*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-/*A8*/	char	s_volume_name[80];	/* volume name */
+/*A8*/	char	s_volume_name[80]	/* volume name */
+			__kernel_nonstring;
 
 /*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
 	__le32  s_c_block_max;          /*
-- 
2.34.1

