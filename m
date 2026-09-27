Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613435AC07
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486246; cv=none; b=s9+i3MeUdjaSswLgs8RQCpmGzFKcKOb5xEJme2Sujj6KdnaLkc/XWWZU+HxGX3Ct8+RzQsXZE8MxT/WvGOvOk4LC/SlLpHCkPtPrGZcEYcuPYhYqD2+ak9wl1vqQ73R5tOnoY2fPSphXb6tDySD57S8prto9MCNFLTo1zzi81zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486246; c=relaxed/simple;
	bh=nWYyEn3FlxnbDE5hfPTdOkEDIO47hQrt3IWc+5iB0G0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AAjjmnVC8rLL1JexCPmkxo6fsAq+aN8lan+1fL1b1bNYE4CAhUu6upXU7E6GHj4zHwqvq5Vs/vIGX1j1nQDz4cFHc51UrlvqzwJRJNrHsHjsQxK/wpmPYqvDGwLHyK6eKks8iiUHwemkp79JGQ/rotZShcO5NgnZziuzvv445jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pc15xYtH; arc=none smtp.client-ip=74.125.229.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pc15xYtH"
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd025d06so1398918c88.1
        for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 22:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790486244; x=1791091044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fYllJEMjqSI9dmThGcCAG+WXxe2fhi4B+5VSXcbhrlk=;
        b=pc15xYtHMkXyln8PLqM50TBJpeK8NQI1vbmHUZ9vKdY6G7P3LJhAUzrEh6D+kSplJR
         NQMgfhFab+awep1voN/hVZ4/Q84K6oj9yAi8neT/i4kLyZ0lKeU16uInYmxRC35duhgL
         ULAW5+Jro6HaqHslL5V/sUPyPQ4kuOPL6gfrurocq7LhFul6eaYf5g3fKavmp7SsHjco
         +XGQ4me41b1WTZIgKyqG3+r37W+AeVspTyv62+t9XHFVudBZL58kE4KwzJwGo9a0k1kn
         VXaB+01nzQXdATLH2OJ61uZSyH+RsBuKacuUpqkKMQAvcp39CDEpquRv/6zuw2ctiZRn
         RIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790486244; x=1791091044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fYllJEMjqSI9dmThGcCAG+WXxe2fhi4B+5VSXcbhrlk=;
        b=dLoLY6wEc3Nr84LHzAwksQSPcSOSoH7MUEN2x3Bv//YdZoHn2uzqPATtmzO/N+I/4Y
         FSKGuHSnr+WAs7uNBDerUWVrqAAoRUNpy/WecpZ6Je6c5B+2hyirQCgGk9U0pWog2NhL
         DRbqLacjODIji1Q6WQxTmOdPEaMXTXjcRsU2MjltnAbcdf5ovdxquz/4A3Y2G/aJvTG6
         8mXbtLF562PUkOiBEt9GqRerG+Nkoj9b48vmY0prtIkofVWrBjanXK/Y1j3s277WUBhe
         G+x8URC/pzZEXAPuRugQ68nO48thZ5UsJ6p5wC0FLJCBJ/CcN3SGmOLLyZKjCIDJ2BWc
         t2iQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmQ/uXuiUKieV4zli+OGhDyryo5YaIZiHQOsfHTQDlL7S48iXq19IHhIMLtuUzXrIZew0P/TJY5gG7@vger.kernel.org
X-Gm-Message-State: AFq9FYLwUGMYRTC9aHvSkTFOO+bXUEWK3YGFdwORFpZaZbjGP74zmVar
	JUoWuBjhOYy7ODxPw1H+Ckm+Mlw9FYd/a5XujbbZxTctoce7mmuaHEdN
X-Gm-Gg: AYBFou292ZkSJHPrQHI4dlv/swD41mOw0MnJj5GLvyy9Y1J2AVR2dbgZTzhYvXWLRyQ
	qfpV172CExvy2Go7dvV70u9w/dApW1QwNRqBH0fgqE0ObwIJwu8ml1iTm5GJCLlz1EAk2f7GSVk
	Vl5JeWqgAN+LapoerGCwK+Hf/J45xd+GVZQOq9oEhp0NzrngmKQVyjqpPzWVXNpVm1xaud+GzFy
	cQeemF+WXtQgdFD5m8JjG+DYBbB8hkhPSGGEUuEoYlessxgSG49P/eWRlncbHbO+vILUGQqPUGN
	ZISaodzMwd+z7oxUnQxfdPf/CImzCw4Fs9vcf+hCdgmueu3/cwcqSelF+13SEJtwQpXplRbweu0
	AhQrLTlqVGV/wHv2LtF9YEFbmdEbIEDE3Mg86RppPdZC4gi6QhwoNVBKDlYLAwBGVm6Al9w2yHV
	BW2vzgEb1emF7xa1vZC9z8hcYr5CitvH/IgL+F+LYDgG5+/x7guoZUKUHEdEQtQO2h0D0WZdnWr
	istdCKy8iONcPkKgTI3ug+760A+nkoa4isaap6oRcj6uaeKGTtgSuHHvg8cp3mCsNLtIp2x1bJG
	2kXIXLIgtKIQH4DNCz9yVUInlrrRz4Gk6SASM1TEj+k8lJZLV+o2l4LqBwsTm6boMTdB1VXhXw=
	=
X-Received: by 2002:a05:693c:824c:b0:346:7c2c:1d0c with SMTP id 5a478bee46e88-3467c2c2549mr424577eec.17.1790486243877;
        Sat, 26 Sep 2026 22:17:23 -0700 (PDT)
Received: from FT6N242TWK ([223.181.116.210])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341459234a1sm18410338eec.24.2026.09.26.22.17.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 22:17:23 -0700 (PDT)
From: Shashank Mohan Jain <jain.sm@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: rd: Check the return value of match_int()
Date: Sun, 27 Sep 2026 10:47:17 +0530
Message-ID: <20260927051717.71269-1-jain.sm@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rd_set_configfs_dev_params() ignores the return value of match_int()
for the rd_pages=, rd_nullio= and rd_dummy= options and then uses 'arg'
anyway.

match_token() only matches these options if the value is a number with
nothing after it, but match_int() can still fail with -ERANGE: when the
value is 24 characters or longer, on any architecture, and on 64-bit for
most values outside the range of an int.  'arg' is then not written.  It
still holds the value parsed for an earlier option in the same write, or
is uninitialized if no number was parsed yet.  The write succeeds, and
for rd_pages= that value becomes the page count and RDF_HAS_PAGE_COUNT
is set.  On 64-bit, for example, "rd_nullio=1,rd_pages=4294967296"
configures a one page device, and "rd_pages=4294967296" alone uses an
uninitialized page count (0 with CONFIG_INIT_STACK_ALL_ZERO, which is
only rejected when the device is enabled).  A stale 1 also turns on
RDF_NULLIO or RDF_DUMMY for an invalid rd_nullio= or rd_dummy= value.

Return the error from match_int(), as the fileio and pscsi backends do
for their match_int() options.  As there, options that come before the
invalid one in the same write have already been applied.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
---
This patch was prepared with Claude Code (Anthropic), model Claude Opus 5.5
(claude-opus-5-5): the analysis, the fix, the changelog and the throwaway
test described below. The trailer only says "Assisted-by: LLM", as
Documentation/process/coding-assistants.rst describes.

Earlier attempts at this fix were not merged:
https://lore.kernel.org/r/1528779148-42485-1-git-send-email-jiazhouyang09@gmail.com
https://lore.kernel.org/r/20190112053159.99406-1-kjlu@umn.edu
This version follows the review comments there: it returns the error
from match_int() instead of -EINVAL, does not leak 'orig', covers
rd_nullio= (and rd_dummy=, added later), and goes through a single exit
path as the fileio backend does.  James Bottomley suggested
ignoring an invalid option instead of failing the write; I went with
returning the error so that a mistyped size is not silently replaced by
a stale or uninitialized one, but ignoring it (a 'break' instead of
'goto out') would also fix the bug.

Dependencies: none. The patch is correct on its own on current mainline.
It is related to "lib: parser: reject out-of-range values in
match_number()", sent to Andrew Morton:
https://lore.kernel.org/r/20260926012718.15675-1-jain.sm@gmail.com
With that patch, out-of-range values also fail on 32-bit (today they
wrap there, for example rd_pages=4294967296 gives 0 pages), and this
patch then turns that failure into an error instead of a stale value.

Testing done:
- W=1 build of drivers/target/target_core_rd.o with allmodconfig for
  x86_64 and i386: no warnings.
- A throwaway KUnit test (not part of this patch) called
  rd_set_configfs_dev_params() under UML (x86_64 and i386 subarch).
  Without the patch, on x86_64:
  "rd_nullio=1,rd_pages=4294967296" returns success with 1 page and
  RDF_HAS_PAGE_COUNT set; "rd_pages=4294967296" gives 0 pages with
  CONFIG_INIT_STACK_ALL_ZERO and 0xfefefefe pages with
  CONFIG_INIT_STACK_ALL_PATTERN; a 24-character rd_nullio= or rd_dummy=
  value of 0 after "rd_pages=1" sets RDF_NULLIO or RDF_DUMMY (also on
  i386).  With the patch all of these writes fail with -ERANGE, and valid
  values (rd_pages=8, rd_pages=0x10, "rd_pages=8,rd_nullio=1,rd_dummy=1",
  rd_pages=2147483647) are unchanged, on x86_64 and i386.

Not tested: writing to the configfs control file of a real rd_mcp device
with targetcli, and enabling such a device.

Not changed: a negative rd_pages= value still parses and becomes a huge
u32 page count, as before.

 drivers/target/target_core_rd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d4e3..32762199e742 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -545,7 +545,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 	struct rd_dev *rd_dev = RD_DEV(dev);
 	char *orig, *ptr, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int arg, token;
+	int ret = 0, arg, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -560,14 +560,18 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_rd_pages:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			rd_dev->rd_page_count = arg;
 			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			if (arg != 1)
 				break;
 
@@ -575,7 +579,9 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			rd_dev->rd_flags |= RDF_NULLIO;
 			break;
 		case Opt_rd_dummy:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			if (arg != 1)
 				break;
 
@@ -587,8 +593,9 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		}
 	}
 
+out:
 	kfree(orig);
-	return count;
+	return (!ret) ? count : ret;
 }
 
 static ssize_t rd_show_configfs_dev_params(struct se_device *dev, char *b)
-- 
2.43.0

