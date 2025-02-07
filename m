Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1D12C470;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=ez9QZ5bo7K5ThoYPbZmo0fPmeMi058iDi7m/8ZLIQNaKcRdSPPX5VzgqwyYzTFo740MYDrvx/gZJVQB9b3iFuKeN4okmkGAs32XEe1nkG+DMzUJBs1TeNyR/Fria6H946zFJkdRgmbaP5VE1ceC1AdCJ6Mv+OK3XRmTGecXXfAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=K/07rfCFA4BfrBoFR8MW3miwLviZUsM4VUjLPRUHQSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NDtAwvitC+HKP5V024DxmPI7ubjxa/Ub8Uj/lrWJnj+jeuY+/2tpWCCzmEpm6q1stwwB5AZJhj1MEVne7QGz4Gm87doX7qRVM8CL8IyC1lcCpfvWt/KYAVZ4wgYDaB3mBw2e/v7iUq82h7YlIImD6+QEyAapAbjMjoZ8mnx38L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqkdQDHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqkdQDHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44699C4CEE6;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=K/07rfCFA4BfrBoFR8MW3miwLviZUsM4VUjLPRUHQSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqkdQDHi32+fVMBhJIDpDTsAD2KQxIW6emKqDpEwDIeNEsKRSUE3Jdo7K7nnI2L+b
	 UhJgJLVG9dUctxMfqz8+aA5yZcS6NWu7beIJo6jlapVkpPjfb0vBYzfX/2F3YyFOdU
	 qL/GbOB4z4wQA69Xp12J7bOE1HQeP6I6iWZbDHJmMQ3WMAYUCtcvUt98ISXzU2ZqL1
	 TKhfr6HXq2vd296XeXUa2nGaR/oAGU2HWjMS2EMz7a6QRbZ+bc07fqt9Yr1cdiW79d
	 +pYPhK1tpMPtgB+9SpPJG2+dCuvRM2/zcGg6H8ns4ObNPRxlcDz0By9PjUwZyVCT+3
	 2WYJpzowanURQ==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
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
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 10/10] string.h: Validate memtostr*()/strtomem*() arguments more carefully
Date: Thu,  6 Feb 2025 17:00:19 -0800
Message-Id: <20250207010022.749952-10-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2779; i=kees@kernel.org; h=from:subject; bh=K/07rfCFA4BfrBoFR8MW3miwLviZUsM4VUjLPRUHQSk=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLo5WkWqvKtx3a+ezM9LfZXLZVF1S28bTHnSzv5Fyfe SC9+ZxHRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETmXWJk6GU+ymF/TDzEnnUJ z98paYVBW1b09Ci9/W40l/Hq1ZB9qxkZ/grIVM+9nq/nfq96Owvf5erEL48nZzz9es/+TVJKtu0 EDgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Since these functions handle moving between C strings and non-C strings,
they should check for the appropriate presence/lack of the nonstring
attribute on arguments.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Andy Shevchenko <andy@kernel.org>
Cc: linux-hardening@vger.kernel.org
---
 include/linux/string.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index fc5ae145bd78..26491a2f8010 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -412,8 +412,10 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define strtomem_pad(dest, src, pad)	do {				\
 	const size_t _dest_len = __must_be_byte_array(dest) +		\
+				 __must_be_noncstr(dest) +		\
 				 ARRAY_SIZE(dest);			\
-	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_len = __must_be_cstr(src) +			\
+				__builtin_object_size(src, 1);		\
 									\
 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
 		     _dest_len == (size_t)-1);				\
@@ -436,8 +438,10 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define strtomem(dest, src)	do {					\
 	const size_t _dest_len = __must_be_byte_array(dest) +		\
+				 __must_be_noncstr(dest) +		\
 				 ARRAY_SIZE(dest);			\
-	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_len = __must_be_cstr(src) +			\
+				__builtin_object_size(src, 1);		\
 									\
 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
 		     _dest_len == (size_t)-1);				\
@@ -456,8 +460,10 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define memtostr(dest, src)	do {					\
 	const size_t _dest_len = __must_be_byte_array(dest) +		\
+				 __must_be_cstr(dest) +			\
 				 ARRAY_SIZE(dest);			\
-	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_len = __must_be_noncstr(src) +		\
+				__builtin_object_size(src, 1);		\
 	const size_t _src_chars = strnlen(src, _src_len);		\
 	const size_t _copy_len = min(_dest_len - 1, _src_chars);	\
 									\
@@ -482,8 +488,10 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define memtostr_pad(dest, src)		do {				\
 	const size_t _dest_len = __must_be_byte_array(dest) +		\
+				 __must_be_cstr(dest) +			\
 				 ARRAY_SIZE(dest);			\
-	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_len = __must_be_noncstr(src) +		\
+				__builtin_object_size(src, 1);		\
 	const size_t _src_chars = strnlen(src, _src_len);		\
 	const size_t _copy_len = min(_dest_len - 1, _src_chars);	\
 									\
-- 
2.34.1

