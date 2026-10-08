Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE73B8D78
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503656; cv=none; b=pnaj7vrNfh8m75JJKmE3xgB5/rHi9ERt9kpdNgR8XsZvBFbvBCc7XN0ZwchrPxYFE7ci78x6hg5XE6jxBs22XEdxl596f6fWre8tjTebxL1sENHsEGC/PAKnkQrLorb++u6bJa7b/4cs+NksGesZ3/dUmvfdRHHhBt+hdx6BmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503656; c=relaxed/simple;
	bh=tAdh45B6ZHFVqj4WgSvf0WZhKctd2Lk2TZ1YVcBta8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S+En+Ram7Fyi7iYfD3baG7oin2oZadAs2MQoHO+dk85Or4VgS3kEtPcJTWygHeNqQG9T25vVEbxP26eLbag3JCsbHVzP0NFwq4+BjB6s1AB8UtsNceqpOBGICn3rWEUeZ16CLvuH8/5amxYxRhT50KKRS+jmbc3SBLI6zpJdu20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sA4laCNU; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sA4laCNU"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91429072866so1408346d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 16:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503654; x=1792108454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiKuR1cop6zWSqjy7NaZ294spzxiEHuaWQoI/VIIui8=;
        b=sA4laCNUhcWfPeT9fR7XPwk1EL0t4oGRftvZpWbGyzi9CUGqxGCUqGOTnnJMuYx83S
         PLXdYK+croYAi45ECIGloTuncUiJE0quNkkAZuAAHhPmwtvltrFi0bc6GfYc2I7c0w4P
         stmhupR6N1FWYTs1u9lKVIIRGu7d8UglDhct0l9IPeCizAgruVw59841ouAnNmsPOkfE
         Pm8FgneRNtlNavTuWPzMe5XUS6M5Bl2XJlHj3YjasEjKcLS2kuOnOp+eqPK8RI5q3iu2
         3IG25RWgpMMb5uDQxTDF1reRgCANyEJVmchcl4n2wfn+klRTwSw/R/C9Z0TOHWaRq5w4
         QJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503654; x=1792108454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiKuR1cop6zWSqjy7NaZ294spzxiEHuaWQoI/VIIui8=;
        b=1QYkVThQon87gOv1Fl5pk/7n4NuEbwE25vXl7yyR0TLrhVXU9bjtNt9Krc4D0fNpdu
         WSnMU85BRVw2rlSXAQuDyx162+HlvmRz8GY/1es1gwX9WSMAUo1nYVE+JejdHlRQlnvo
         oFRtoFncegva1AuyIkzgbXRM+QLmlNUoEx0CwjfpIXHnJXg7rSWwfYopW78Ek/ffpg1t
         tp1ZxQzoIw6I1KwZl6jDmulBU+dWmFjt3AfKkmDL2OT8Qdo5qUPPSo+4eaKLzNRQwp2a
         p7wvU15ThGuEH2olFr4opdVqEveM7f0+Ypv2Cp78CmTlgchap9KHlgap6TqLPji/26Mp
         ks8w==
X-Forwarded-Encrypted: i=1; AKwUvBy/h5TDZYO82VVH+TtXKroQ23OAoHeeC3gzgPX/Tiuh1tEUElbK+YlPcE/SGIFKD480js9yedfRiE2g@vger.kernel.org
X-Gm-Message-State: AFq9FYKZxebhye4ORDJTQDt6uwE/VLwjTXz46XDK4wNp1jCWfN6HFpMA
	+EsxNZeMLHyHw8wmFQhQM/zAiThi80g/XRCqDhqXAUChxGRphOQsYDok
X-Gm-Gg: AYBFou2eQzmP+wMqika63ZImsXThfYV64Ut7KS4GxL6hxsTV+DFUEYiZTJaPgGNfXwe
	pbNawgMM2nv7ritG6aXXuKHefFjQFfgzRpflNu6QzUQ85Niqtbc40Y7+HFD1P37CovarkqZQoz9
	YtGqdMg1C8peMC1YqDyISV+XuTnMkXbnwgk2GeviSGKshyWEsqUtYCFlBdjcrEBFRU2rSgG/XD2
	bY1wxDEO6lhodCUiZubCnrUn6/+qEdOiOlGkE/Zsn0P3jgpJ8AFaDWZV/aFEmGKGhngqweEPOGV
	f7rHedfROuBOFAdjFGbg0e2uaCGfnL/Edx74CxbIZd8rZ+3H/MvOrmm8wukO+dNxuRj7slqkMNd
	SESeLTX1y4NfIDD8gHNICAbsy71HpYNi1fybGV5QTGn47mwKRFcmNwZd5pMha5iJr6nQP7AeI9j
	q+RTMy3ButWl5va1rw0M5/gHvCboOjwWr4IP2II+Zoo3ZS37SSSOeV5573SPJwzbqfhQ5/oVdRr
	bTYspH51damSL30iXgolTgDuNgYsGWF7oqkxmKwyyYa7njfBvYBUa+BYXVHh1er1uzfUjV+7Jcs
	Kh+2WBhEa7ypbtl9w30icKCIvJJ3Fg==
X-Received: by 2002:a05:6214:4017:b0:914:3ef6:ec0a with SMTP id 6a1803df08f44-91b55500ce2mr6371526d6.3.1791503654285;
        Thu, 08 Oct 2026 16:54:14 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:13 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 0/3] scsi: target: rd: Fix oversized ramdisk allocations
Date: Thu,  8 Oct 2026 19:54:06 -0400
Message-ID: <20261008235411.56641-1-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

A ramdisk page count set through configfs (rd_pages=) has no upper bound.
syzbot found that a large value makes rd_build_device_space() attempt a
single sg table array allocation above the page allocator's maximum
order, which triggers a WARNING. Patch 1 rejects page counts that
exceed system RAM and allocates the array with kvzalloc so that valid
large ramdisks also work.

A page count close to system RAM still passes that check, and the
backing pages are allocated with GFP_KERNEL, which invokes the OOM
killer instead of failing. On a 1 GiB VM, rd_pages=250000 panics the
system with "System is deadlocked on memory". Patch 3 allocates the
backing pages with __GFP_RETRY_MAYFAIL so that enabling such a device
fails with -ENOMEM instead.

That makes the failure path in rd_build_prot_space() reachable, and it
leaks the partially allocated protection space when pi_prot_type is
written again. Patch 2 fixes that first, so that patch 3 does not
introduce a leak.

Tested on an arm64 QEMU VM with 1 GiB RAM, with the syzbot reproducer,
normal and NULLIO ramdisks, DIF protection space, device removal, and
rd_pages=250000. The leak was checked with kmemleak by making
pi_prot_type=1 fail under memory pressure and then writing it again:
two unreferenced objects from rd_init_prot() are reported without
patch 2, none with it.

Changes in v3:
- New patch 2 to release the protection space when its allocation
  fails (Sashiko AI review).

Changes in v2:
- Allocate the sg table arrays with kvzalloc_objs() so that ramdisks
  larger than 512 GiB do not hit the same WARNING (Sashiko AI review).
- New patch to avoid the OOM killer when the backing pages cannot be
  allocated (Sashiko AI review).

v2: https://lore.kernel.org/all/20261008223712.49827-1-sanan.hasanou@gmail.com/
v1: https://lore.kernel.org/all/20261008215709.46014-1-sanan.hasanou@gmail.com/


Sanan Hasanov (3):
  scsi: target: rd: Fix oversized sg table array allocation
  scsi: target: rd: Release protection space on allocation failure
  scsi: target: rd: Don't invoke the OOM killer for ramdisk pages

 drivers/target/target_core_rd.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)


base-commit: 6c377d19d4a5116d9bec5203aa3c6c11523e7898
-- 
2.48.1

