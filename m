Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917F38172A;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=WgKNUSIcyZ4hqWCsSytWnRYeUD0rkIQlTzIh3/x+9NWApmYchfndo+pl1aEBVG2fg1rq3MV7YvdbOq9lRY3Q1EjeMTBdgGsIz1A/bPA3VJv+5cIk8Jm2E+bMMwUFRn1ota5cTVCANrG5FLB8tnFdb0h7Ztn3wRROKpNNAELNyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=4KeQJBNPB0Q5KIE870XgtEtrG/Op6CZMA5oc8jFXtQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mFmcIHLl3RbXy6wAM6usMAlDB/bipu/SN6POtWabMF069njNvorWBriGNATGvlsXC81Dw4P4aeDCxYKFCu7WHFO2Oq9qBJkd2xFg9NpKRzSXBp36VA4AhpZ8AV5/xqzNr/dXeFatVeQBoRTQzNhADEGVSYYu6950NJ7MYnXXij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQ5oTJ+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ5oTJ+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5DCC4CEF1;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=4KeQJBNPB0Q5KIE870XgtEtrG/Op6CZMA5oc8jFXtQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ5oTJ+750ycYbVPLnYKkcV403+k86ysv/nxr+d9xcJ51a5DBaRQn0pb758KbKON8
	 LkRUcPKEjYJLEgBmtFbGbPbXgudrAWjiFB9eTOQFwwyJA58ZtNZSXnLoP2tWhfnUKe
	 uFTeBUTJCw4gr6Yy28+bizKl0uuZ5bVAPu7sDuohUmSY+FuCaNGtY54DVwMn++yFGC
	 29FKuwhuv7Bc1UJRlisuHdUDHgnOd3U/H7NjldrSDt564dBbyswlUud1rppIHwi5uj
	 +SZ3NCwsq35J4ua+TfR3HiswfjPb/4EF0MgnO2qyVYY+FtG7wJc5hcuH5Wc6zE52cv
	 XfEOK/F0INJkQ==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-hardening@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
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
Subject: [PATCH 05/10] string: kunit: Mark nonstring test strings as __nonstring
Date: Thu,  6 Feb 2025 17:00:14 -0800
Message-Id: <20250207010022.749952-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1065; i=kees@kernel.org; h=from:subject; bh=4KeQJBNPB0Q5KIE870XgtEtrG/Op6CZMA5oc8jFXtQA=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxWYZijYhtbMvzDjjcShsmCjbHEFgdIezckh0Us/+ pc+m3C7o5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCKWpxkZXpo8cyzmTj/luFNM v4b9R6H9/Am8UUeWMDqwxa+7L8fcxshwd6WkPUday48YbddpW1eo3rU7z/R2zdr9ChftK4OklRo YAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for strtomem*() checking that its destination is a
__nonstring, annotate "nonstring" and "nonstring_small" variables
accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-hardening@vger.kernel.org
---
 lib/string_kunit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/string_kunit.c b/lib/string_kunit.c
index c919e3293da6..0ed7448a26d3 100644
--- a/lib/string_kunit.c
+++ b/lib/string_kunit.c
@@ -579,8 +579,8 @@ static void string_test_strtomem(struct kunit *test)
 
 static void string_test_memtostr(struct kunit *test)
 {
-	char nonstring[7] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' };
-	char nonstring_small[3] = { 'a', 'b', 'c' };
+	char nonstring[7] __nonstring = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' };
+	char nonstring_small[3] __nonstring = { 'a', 'b', 'c' };
 	char dest[sizeof(nonstring) + 1];
 
 	/* Copy in a non-NUL-terminated string into exactly right-sized dest. */
-- 
2.34.1

