Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA013B29F;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=m41yOO/GetYoYJQ9No4M+BBTbSPeQOWjyZfAmCF9Av/KdJbuI1QJSlJOzEWWITIl4p4TUgpydj4qLsYM5spYygdKrMogBn9PIrvFuzuRidjLawQC5tUo9Qm8OKDFz+cdpTY52KFGWaEwYheiOPqEdxuv4YXHS0WyqtM7SrZgoow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=OD080QOcsvmWmkyEpokD8TJxBS24XHP/FqYv3Q/+7eQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OC6Tl+yTKWXIiffr4oknt7nLCbXCz7PmIOv5DelHL2GNJcjWjvMPmQWCasRUE3WwQMFJc4/q7Xc6xSPhT/4ZatCkU5OYRLb+XpQZGUf62fY4YD5/C7e7n+Vwjq5JZex3uxSYCe7zErMRyvXJAamhXUaqFG7aGNqctRWgcoIjOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4xkj2HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4xkj2HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D03C4CEF3;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=OD080QOcsvmWmkyEpokD8TJxBS24XHP/FqYv3Q/+7eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4xkj2HNHL0fP3uLxXElWkqOEMghzdy+9+fMKprTafPGPgA8dQLUGLz6FkHfoS28R
	 sR418rmGcDPxnomHC7EVpWCfCW+CX8EQBEf17uOXZ6CY/dP5XbGtAvKzFx8joaC6jH
	 Yz4nK0nLWKP4ObeHKKFDvjNiIBHa+mvTHD0/gD18v8w0IWk9+jTNcaCX2HogJtPpMq
	 IrsKj3jMLdKe6dxKqE5w7bQKQS0sv+jYLTGEVD4xipjwsPOl9GtU9jFzYyK4monSIE
	 cBGFuuwO4DNGnO+v8wpUm9H7JssjR/tuOxFns5OFK0kFsIIICot8StIXGThzOU5Ekn
	 8l0TGUKl+AD7A==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
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
Subject: [PATCH 09/10] compiler.h: Introduce __must_be_noncstr()
Date: Thu,  6 Feb 2025 17:00:18 -0800
Message-Id: <20250207010022.749952-9-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1662; i=kees@kernel.org; h=from:subject; bh=OD080QOcsvmWmkyEpokD8TJxBS24XHP/FqYv3Q/+7eQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLo5VM/jrvuzHT8t+U5qBbdwzFMtU1rI7yr439WeE0M eZqjoVGRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwERWSDP893F8yq70KFA4Olrv 1sQXuh/mnj5cefTo2kp/q+2FDz5IvmJkOLNdd/ZkvbDdr6+cypnQ+jZBQH/PjaS9ysffvD06aZK dGAsA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for adding more type checking to the memtostr/strtomem*()
helpers, introduce the ability to check for the "nonstring" attribute.
This is the reverse of what was added to strscpy*() in commit 559048d156ff
("string: Check for "nonstring" attribute on strscpy() arguments").

Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/compiler.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 1c0688319435..c89070a2f964 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -229,9 +229,25 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define __must_be_byte_array(a)	__BUILD_BUG_ON_ZERO_MSG(!__is_byte_array(a), \
 							"must be byte array")
 
+/*
+ * If the "nonstring" attribute isn't available, we have to return true
+ * so the __must_*() checks pass when "nonstring" isn't supported.
+ */
+#if __has_attribute(__nonstring__)
+#define __is_cstr(a)		(!__annotated(a, nonstring))
+#define __is_noncstr(a)		(__annotated(a, nonstring))
+#else
+#define __is_cstr(a)		(true)
+#define __is_noncstr(a)		(true)
+#endif
+
 /* Require C Strings (i.e. NUL-terminated) lack the "nonstring" attribute. */
 #define __must_be_cstr(p) \
-	__BUILD_BUG_ON_ZERO_MSG(__annotated(p, nonstring), "must be cstr (NUL-terminated)")
+	__BUILD_BUG_ON_ZERO_MSG(!__is_cstr(p), \
+				"must be C-string (NUL-terminated)")
+#define __must_be_noncstr(p) \
+	__BUILD_BUG_ON_ZERO_MSG(!__is_noncstr(p), \
+				"must be non-C-string (not NUL-terminated)")
 
 #endif /* __KERNEL__ */
 
-- 
2.34.1

