Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F67E130A7D;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=C5nQgRDvAjwp78pavi8/KswGHLxl2LQeVbEO/hqzjlbPBeB0arJ7q/1Az+9xXh29nbW/L1r1uwk3jxeAr0rXDI4uryttE/opwt3mn9jj2puTxcYZrzXeEXQggdGlkOMNpQSrrr3S+xi6w7l53/VyJbn6FB9+51NI6dhQaYCm0mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=AU4TtQLPUdYghKYrNhONEb5bDCAkZ0FgafFKK4ZzDeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q8h4UQXiZyhoSuJMWZ1HzFrCuA15j7blAktj7VcBC/Sl3z88Cu9viR24ONhJwAKBqrOu2lh+/U6MFgzhHuGZ+gFjR3RwNSqaQ4BkrU7FRG1qve/HXPQ/cCMopB/YgFfFcs/UdJJibklCAnYqdVQrFIouMadZR2Q8w4smVjePXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISqZHQ6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISqZHQ6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3142DC4CEF2;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=AU4TtQLPUdYghKYrNhONEb5bDCAkZ0FgafFKK4ZzDeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISqZHQ6X9bEOFfl/1QaPI0iUHHJOCrar0Oi7tQvo379zrUeGILh17VA6n9KHRl8MJ
	 UswQ5HWsIpXjqVyVxLnCcCuEPH7sy2x/r8tIIXaHhoT+ffyoTsK1xCVCxg7gFZurSz
	 VtLZkc4QyA6wyE68OKYZ5ClN4updhXb0CxVgVgqGFuC1dhP6JL2NlFkV26W4+i/LoH
	 1A/W//Fatt9Bvgjc2pKdt92FUwsltQajY5ut5gWjxj98lfeRqnOe7zZ/wmCtfLWkKp
	 Ii4OwfJ/PaQSPPeneXfIaRTxPb/DFxP9ooxnLDpFEs/9aIq6BVl5uWVtsTx+YJdfgM
	 rh67TfpHPV0Iw==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	Erick Archer <erick.archer@outlook.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
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
	kernel test robot <lkp@intel.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 07/10] uapi: stddef.h: Introduce __kernel_nonstring
Date: Thu,  6 Feb 2025 17:00:16 -0800
Message-Id: <20250207010022.749952-7-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=976; i=kees@kernel.org; h=from:subject; bh=AU4TtQLPUdYghKYrNhONEb5bDCAkZ0FgafFKK4ZzDeY=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxVLUp5s3XfF6NPUBW9uL1kopuLAm3TZaMdFvfOc/ k6fluTadJSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEykv5zhD//3/UYFBW7RbMqH 9vQc7f4gJTtBhv2zRd6SLtWtTOqVLAx/hSzUTbrljHYlNjXcS2zlXHIp88XPU4ZhLw3Fdj4Nm3a IBQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In order to annotate byte arrays in UAPI that are not C strings (i.e.
they may not be NUL terminated), the "nonstring" attribute is needed.
However, we can't expose this to userspace as it is compiler version
specific.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Cc: Erick Archer <erick.archer@outlook.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
---
 include/uapi/linux/stddef.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 58154117d9b0..0e7d289b7c2e 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -63,4 +63,10 @@
 #define __counted_by_be(m)
 #endif
 
+#ifdef __KERNEL__
+#define __kernel_nonstring	__nonstring
+#else
+#define __kernel_nonstring
+#endif
+
 #endif /* _UAPI_LINUX_STDDEF_H */
-- 
2.34.1

