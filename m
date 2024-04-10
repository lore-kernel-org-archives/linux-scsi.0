Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ADF8F4E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 02:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716319; cv=none; b=JICUDpwb/1xrTrfL02OkzJZPAtAKeM5v3xE/ePncrqChRsSaQOIHylnVbi5jThzqhzmhb+ULXx4szSR3RMH7qCuN9mtz3xlFkTjhE+2zMvnKBNAASuzzVLSdhv0oc9oNOs8e8dxxZZdTTqyst8+Tnie7lqOhdcina1xbT4DAc48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716319; c=relaxed/simple;
	bh=qYbI18yUD5HzoNjKR0lGr4s6EGttBI6+PzDO8Wigddw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NZUySC5mAIPZd5DthFQsDJb52w53xaJ/yKgmXIDSRJOweuvOB4LvwhSvCzNX3lG3blOMZNul/DfVd6vDWtpJ/JyWbEjGe+2wSvdrJ1dQJ05mSljC2JW1qo1Pz/yYCiNI68lsywT08LhP7TWzevAMWASTd4BgUiLR06y+nQPCl7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=SIMSFdFr; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SIMSFdFr"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6ea243406f0so607787a34.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 19:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712716317; x=1713321117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oDjOHXgs0t5VffxEwXD7O3lIN0U2S1tp9J0ba2VzLZ8=;
        b=SIMSFdFrpV24Dh4osCye8cAKO24bfcBL8ygq21+sqtVuoIQGv5yo0hhV5V+g+mf8h2
         QHxa1uxV19PVOlS4jjce98p+XTgSPYeZAdoX02Rf/caMvnDsUcvniIF0frD42hEsFs1U
         0o31dhrpeqoSPjURsMSuuKH6kJ0Z/OMb5xSPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716317; x=1713321117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDjOHXgs0t5VffxEwXD7O3lIN0U2S1tp9J0ba2VzLZ8=;
        b=c3YW6HDjSjsbpjWcSJssyVXNI7QU12SJpNhWH+LVXf7Pgpbh5WiOotYvbjq6vsyOh4
         B6/gRuQn1Q31jumJJjgxjgfLp7OSN7bsk7wFPLAgYpj11+Mu6GineVR1TZ4MRLRkUuoO
         A+r/iwI+le/tWZ4GXt3tYnUA39wDohBcTR584HSw4+7G26jh2SHPhm2Gy+9F4TEByTtz
         JQ238h04P0KpJDYP8IayJ8b/d0mkv3KblIQUkuowV/UD57vc8EkTlEF/vvgrG+nORpXA
         LwBAlMaKOVagZ0YsYh0Qvyrhj4n4wAAQaiDDTp8HPCUuwSfrMiGSUIUvlTcfJSClkcnd
         NCaw==
X-Forwarded-Encrypted: i=1; AJvYcCUADuOPK2fti3UXBpB9XP0ymB00PExG0S0Cv7LxsxEnwjhGL7jZZAniLtIc0jLfbJox5oHbemDYJDoqLydr/qariPZornjRRWNPEw==
X-Gm-Message-State: AOJu0Ywb9xcfs53u7m+WZQtgzCn+EcVF0tS7+xtUBpUYlntVkSzGfHW1
	QwZnXHrGr5ap/pR4OESscIDSpIJvNjnZzFAGJs9O7xuYyY9pAM0Uq3UgYwJJaQ==
X-Google-Smtp-Source: AGHT+IEdVhbRhVxvlZGEV8PD92wXU0c32qZIHbZHZuV68VzxpmadMn0ygTyKEdkj2djHOvXGtGGRJw==
X-Received: by 2002:a05:6871:e414:b0:22d:fcf9:f771 with SMTP id py20-20020a056871e41400b0022dfcf9f771mr1454166oac.25.1712716317026;
        Tue, 09 Apr 2024 19:31:57 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x6-20020a634a06000000b005dc491ccdcesm8687444pga.14.2024.04.09.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 19:31:56 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andy@kernel.org>,
	linux-hardening@vger.kernel.org,
	Charles Bertsch <cbertsch@cox.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 1/5] string.h: Introduce memtostr() and memtostr_pad()
Date: Tue,  9 Apr 2024 19:31:50 -0700
Message-Id: <20240410023155.2100422-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240410021833.work.750-kees@kernel.org>
References: <20240410021833.work.750-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5667; i=keescook@chromium.org;
 h=from:subject; bh=qYbI18yUD5HzoNjKR0lGr4s6EGttBI6+PzDO8Wigddw=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmFfoaWcXhAXAR6w2spjXqaHGKBlcFEUONxSERz
 FNEYkxToeaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZhX6GgAKCRCJcvTf3G3A
 JvUID/4kTVp7HimIZ7tPMOmwhBcYn3WrBON4y0CkYzZF0SQ+9kN7HWBLvgWaXqggaohXQvhnpmk
 6MUOm4FVqA0KREKxu5e5YJguWsoxoa373Zzo8h6cFGBiPB8flDpyfNNCIp1oS4YZb0YpbJrEOw8
 19NcJ/+IyMO31sMnB0PyTCohzwwZvNK2gte6sNtQ2gIXwMrBRcYBuULnrx06FamvNCK9fxG5lCO
 SUcYif1jkyrQWMyeq22IkN5My6M9I78KQzakBeL0fPfGLfgCZLdC5JGxWXZn8wysSuCsKeY5zxP
 5qmlP3Fox+NU59rrSOU2bI1Rz1JarVbDI2mMM5a6usTbjYaO3YEdaOSxVpn3rgoJwcw0Ph/95Ur
 rliHIyJdE7v11/RmAeZ9lnh4CPK7I0PUBwvIhu45VQpgrPe9MV0hp2Glh6J0APUZSOPMc4cYsGR
 R7Wi8KtAWxA5IXiaEJC04jnxDbtllWUipnZ8MZGr6HOvDaoqwzX2XGIW+uzfNCH8VfZiEcpws1X
 535CbiDDpbwF6YoRYunW1Q41Fs7yi6MPdcloKlqQ8rC8NIW35j/JWgwa6bLMbb5sPEpDejRcqiK
 XMvwfsy+yQOOoAf+LYUwOFxNAKauXCOHobRw29Q60nTmUYZIIMpd5jphYrMihQqcP5BHRIEpoSl a4Lgz+lLrPXu7NQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Another ambiguous use of strncpy() is to copy from strings that may not
be NUL-terminated. These cases depend on having the destination buffer
be explicitly larger than the source buffer's maximum size, having
the size of the copy exactly match the source buffer's maximum size,
and for the destination buffer to get explicitly NUL terminated.

This usually happens when parsing protocols or hardware character arrays
that are not guaranteed to be NUL-terminated. The code pattern is
effectively this:

	char dest[sizeof(src) + 1];

	strncpy(dest, src, sizeof(src));
	dest[sizeof(dest) - 1] = '\0';

In practice it usually looks like:

struct from_hardware {
	...
	char name[HW_NAME_SIZE] __nonstring;
	...
};

	struct from_hardware *p = ...;
	char name[HW_NAME_SIZE + 1];

	strncpy(name, p->name, HW_NAME_SIZE);
	name[NW_NAME_SIZE] = '\0';

This cannot be replaced with:

	strscpy(name, p->name, sizeof(name));

because p->name is smaller and not NUL-terminated, so FORTIFY will
trigger when strnlen(p->name, sizeof(name)) is used. And it cannot be
replaced with:

	strscpy(name, p->name, sizeof(p->name));

because then "name" may contain a 1 character early truncation of
p->name.

Provide an unambiguous interface for converting a maybe not-NUL-terminated
string to a NUL-terminated string, with compile-time buffer size checking
so that it can never fail at runtime: memtostr() and memtostr_pad(). Also
add KUnit tests for both.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Cc: Justin Stitt <justinstitt@google.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: linux-hardening@vger.kernel.org
---
 include/linux/string.h | 49 ++++++++++++++++++++++++++++++++++++++++++
 lib/strscpy_kunit.c    | 26 ++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 793c27ad7c0d..bd42cf85a95b 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -424,6 +424,55 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
 	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
 } while (0)
 
+/**
+ * memtostr - Copy a possibly non-NUL-term string to a NUL-term string
+ * @dest: Pointer to destination NUL-terminates string
+ * @src: Pointer to character array (likely marked as __nonstring)
+ *
+ * This is a replacement for strncpy() uses where the source is not
+ * a NUL-terminated string.
+ *
+ * Note that sizes of @dest and @src must be known at compile-time.
+ */
+#define memtostr(dest, src)	do {					\
+	const size_t _dest_len = __builtin_object_size(dest, 1);	\
+	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_chars = strnlen(src, _src_len);		\
+	const size_t _copy_len = min(_dest_len - 1, _src_chars);	\
+									\
+	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
+		     !__builtin_constant_p(_src_len) ||			\
+		     _dest_len == 0 || _dest_len == (size_t)-1 ||	\
+		     _src_len == 0 || _src_len == (size_t)-1);		\
+	memcpy(dest, src, _copy_len);					\
+	dest[_copy_len] = '\0';						\
+} while (0)
+
+/**
+ * memtostr_pad - Copy a possibly non-NUL-term string to a NUL-term string
+ *                with NUL padding in the destination
+ * @dest: Pointer to destination NUL-terminates string
+ * @src: Pointer to character array (likely marked as __nonstring)
+ *
+ * This is a replacement for strncpy() uses where the source is not
+ * a NUL-terminated string.
+ *
+ * Note that sizes of @dest and @src must be known at compile-time.
+ */
+#define memtostr_pad(dest, src)		do {				\
+	const size_t _dest_len = __builtin_object_size(dest, 1);	\
+	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_chars = strnlen(src, _src_len);		\
+	const size_t _copy_len = min(_dest_len - 1, _src_chars);	\
+									\
+	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
+		     !__builtin_constant_p(_src_len) ||			\
+		     _dest_len == 0 || _dest_len == (size_t)-1 ||	\
+		     _src_len == 0 || _src_len == (size_t)-1);		\
+	memcpy(dest, src, _copy_len);					\
+	memset(&dest[_copy_len], 0, _dest_len - _copy_len);		\
+} while (0)
+
 /**
  * memset_after - Set a value after a struct member to the end of a struct
  *
diff --git a/lib/strscpy_kunit.c b/lib/strscpy_kunit.c
index a6b6344354ed..ac0b5d1678b3 100644
--- a/lib/strscpy_kunit.c
+++ b/lib/strscpy_kunit.c
@@ -126,8 +126,34 @@ static void strscpy_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, strscpy(dest, "This is too long", ARRAY_SIZE(dest)), -E2BIG);
 }
 
+static void memtostr_test(struct kunit *test)
+{
+	char nonstring[7] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' };
+	char nonstring_small[3] = { 'a', 'b', 'c' };
+	char dest[sizeof(nonstring) + 1];
+
+	/* Copy in a non-NUL-terminated string into exactly right-sized dest. */
+	KUNIT_EXPECT_EQ(test, sizeof(dest), sizeof(nonstring) + 1);
+	memset(dest, 'X', sizeof(dest));
+	memtostr(dest, nonstring);
+	KUNIT_EXPECT_STREQ(test, dest, "abcdefg");
+	memset(dest, 'X', sizeof(dest));
+	memtostr(dest, nonstring_small);
+	KUNIT_EXPECT_STREQ(test, dest, "abc");
+	KUNIT_EXPECT_EQ(test, dest[7], 'X');
+
+	memset(dest, 'X', sizeof(dest));
+	memtostr_pad(dest, nonstring);
+	KUNIT_EXPECT_STREQ(test, dest, "abcdefg");
+	memset(dest, 'X', sizeof(dest));
+	memtostr_pad(dest, nonstring_small);
+	KUNIT_EXPECT_STREQ(test, dest, "abc");
+	KUNIT_EXPECT_EQ(test, dest[7], '\0');
+}
+
 static struct kunit_case strscpy_test_cases[] = {
 	KUNIT_CASE(strscpy_test),
+	KUNIT_CASE(memtostr_test),
 	{}
 };
 
-- 
2.34.1

