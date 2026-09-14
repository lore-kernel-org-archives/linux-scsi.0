Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B8242DA20
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397355; cv=none; b=eItwIv3vZBiXZ87Mek8FHhMVmgxuwrPAb8fe/yxoLp1X/Ng1cRD2YnYCl+8varXMk97/rZtYZ8aQVyXzK4lQu5fL6S7R5KDatIFGy3RoX/gIlBEUuYk1GzfbALsQspmKk373QqG9tyz7LCr5ImnlozinuUt6X3NlLekFqBs7YTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397355; c=relaxed/simple;
	bh=k26uIRovR8ASjMAmHta7ocgCT0tjZOPFISTSDL4m7S0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HNr67JRyZqfdy8nKpPHucdHVjjtrABTz22Rkb2uf4WGbmTzcY3oz7CHLFao0Ve55y/FwdN/CLO0o59enPEo74vwN60ywFPRAGyuf7Ee7vwC7A8Qluloh8QYILu73x5sSElgiYQIPTAXDIPaeekuoDN7xXDl6b+53okbJ0L0jy74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pFoYMT7O; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pFoYMT7O"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8645a62066dso7042217b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397353; x=1790002153; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQeduY4gfW9f3BsS4N5apPZIrElHEQzsJgerYHbJ6y8=;
        b=pFoYMT7OfKZzg2RtRXWkBHCwLOBT8ZrRAVT1tZ5guMu6o+JeVMaN4dwE8M0c5IPxnn
         3lN2FJz01x7KZkk8OD1xP/Zqg1Col3fM8wjAlbp24wke2UelwsgkjejR7az8e95h0eQg
         xUxv6y9l5t9g44WBPBCg/PyxiE+K1fcDLH8Lu/gUimuOTW2PcI5Sf3yX6rADpQXjBN2Z
         NDKJsiU5JUthN8iA4B4/jN33tgWARvIg2JWAyZOKGAkatEUBvpi1qwD12vUpqV0bkYC+
         3KSetOxiRkOa9Rw+FswNDO9FW9uVADHO0mTstoIHZU8oNZvpTEKyPVyOmLgUvy6+tQpK
         DSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397353; x=1790002153;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bQeduY4gfW9f3BsS4N5apPZIrElHEQzsJgerYHbJ6y8=;
        b=LCzxSK5SjJyyU/r8RmoC5Hexqa1wVA9Ech3a3oxWU+j2TENXoJp9wWw8dfSlTeQ0Mq
         HyVJoopiB980Tm1LlS8PVH1ihff96FWUvJWbRtdpGrcZ61tSiApGs6S3pYFs3LRtxtzh
         8pRJKrzbffvdxysKLfhixXzGdIqhmNmvsjDwARioeItS5vWSAH/LhvHoewfJAgLV+3tz
         ZgFv7egacGBUr/eEM0zinQ5KxBR/doWkBswNscO3OTYqmA2+EWo2fjYmWMbkyKVZDTuZ
         3msqyfVmJ2ZeFIVI68jtNXtTcnzCgrGipqdWamSZ/3IEcs2qNongS4m4r7QVZcPz58ch
         M6bA==
X-Forwarded-Encrypted: i=1; AKwUvBz2MMq5+BomL86TN7w3Uy4QcJlPYGBVlM8K4u83LfULfzHiBDJWYwtswb92Vn5wHT17jDhdtzLANoND@vger.kernel.org
X-Gm-Message-State: AFuF++l+5WG/Zia3VMfLlmvRQMF9bYiaU0/5R5BeCz6ykQa3ZifNzGo1
	zScwoCEA1P/bmZVGuTTMpS2TeZoE0Qs9UY1O0YuZ4oJySc/P6f93iZ+ipwc7Lyuwx0av7FO77t8
	TZ0hONswqX8Lpv8gePQLfQg==
X-Received: from pfei1.prod.google.com ([2002:a05:6a00:c041:b0:86a:5448:367e])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:88c8:0:b0:868:4538:c44f with SMTP id d2e1a72fcca58-86f852000c9mr6197049b3a.12.1789397352142;
 Mon, 14 Sep 2026 07:49:12 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:49:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144910.931518-1-stanleyjhu@google.com>
Subject: [PATCH v5 0/3] rpmb: Fix request serialisation and teardown races
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	shyamsaini@linux.microsoft.com, alex.bennee@linaro.org, 
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

This merges two series that were both last posted as v3:

  [PATCH v3] rpmb: core: Guard frame requests and teardown with mutex
  https://lore.kernel.org/all/20260910015515.1991789-1-stanleyjhu@google.com/

  [PATCH v3 0/2] scsi: ufs: rpmb: Fix bus registration and device lifecycle
  https://lore.kernel.org/all/20260910015503.1991119-1-stanleyjhu@google.com/

They turned out to be one problem. The UFS patches make RPMB registration
work again. Registering RPMB devices without the core fix triggers a
use-after-free on any unbind that races an in-flight request. Landing them
as two independent series would leave that window open in between.

The order is chosen so that no commit enables RPMB registration before the
lifetime handling and the serialisation are in place:

  1/3 fixes the generic core. It fixes the teardown race on eMMC today
      and carries a stable tag. It has no effect on UFS on current
      kernels, where nothing registers.
  2/3 fixes the UFS device lifetime. Still nothing registers.
  3/3 removes the never registered bus, which is what makes UFS RPMB
      devices appear again.

drivers/misc/rpmb-core.c and drivers/ufs/ are not in the same tree. 1/3
has no build or runtime dependency on the other two and can be taken on
its own; 2/3 and 3/3 must not land before it.

Verified on QEMU arm64 with KASAN, PROVE_LOCKING and SLUB_DEBUG_ON, against
a UFS device advertising four 4 MiB RPMB regions. Two kthreads on different
CPUs issue RPMB_GET_WRITE_COUNTER against the same region 20000 times each
and compare the nonce echoed back. A third thread holds an rpmb_dev
reference and keeps issuing requests across a host unbind. OP-TEE is the
only in-kernel consumer of rpmb_route_frames(), so an out-of-tree module
stands in for it.

  tree                  rpmb_dev  stolen responses  unbind
  --------------------  --------  ----------------  --------------------
  3/3 alone             4         16512 of 40000    KASAN use-after-free
  3/3 and 2/3, no 1/3   4         17030 of 40000    KASAN use-after-free
  all three             4         0 of 40000        clean

The intermediate points were booted and unbound as well. After 1/3 and
after 2/3 no rpmb_dev is registered, so neither test applies to them, and
neither point reports KASAN.

UFS RPMB is not a feature that never worked. bus_add_device() only began
rejecting devices on an unregistered bus in commit 36f35b8df697 ("driver
core: reject devices with unregistered buses") in v7.2-rc1. Reverting that
commit on the same base, with none of these patches applied, brings all
four rpmb_devs back. All four are still in /sys/class/rpmb after a host
unbind that leaves /sys/class/scsi_device empty. So 2/3 fixes a leak that
is live on v6.19 through v7.1. 3/3 restores what v7.2 disabled. Both
carry Cc: stable again. For a backport the three must be taken together
and in order: 3/3 without 1/3 re-enables registration with the core race
still open.

Upstream QEMU answers SECURITY PROTOCOL IN/OUT on the RPMB well known LU
with INVALID OPCODE. The three rows above therefore also needed a local
QEMU change that implements the authenticated frame state machine. I can
post that to qemu-devel separately, and send the test module to anyone
who wants to reproduce the numbers.

Changes since v4, mostly from Bean Huo's review:

  https://lore.kernel.org/all/20260913033633.3159296-1-stanleyjhu@google.com/

- v4 dropped Cc: stable from the UFS patches on the grounds that the
  feature has never worked on any released kernel. That is wrong, as
  explained above, and both tags are back
- shortened the patch 1 and 2 commit messages
- documented that the rpmb_dev mutex also serialises requests, not only
  guards against teardown
- patch 2 keeps list_del() and the two dev_info() calls, and drops a dead
  rdev check, so its diff is smaller
- corrected the JESD220F section references in patch 1
- picked up Bean Huo's Reviewed-by on all three patches

Changes since v3:
- merged the two series and reordered so registration is enabled last
- dropped the incorrect Tested: line from the core patch
- dropped Cc: stable from the UFS patches; the feature has never worked on
  any released kernel, so there is nothing to backport (wrong, retracted
  in v5 above)
- rewrote the commit messages around the measured results

Stanley Jhu (3):
  rpmb: core: Guard frame requests and teardown with mutex
  scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF
  scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus

 drivers/misc/rpmb-core.c    | 34 ++++++++++++---
 drivers/ufs/core/ufs-rpmb.c | 85 ++++++++++++++++++++-----------------
 include/linux/rpmb.h        |  5 +++
 3 files changed, 79 insertions(+), 45 deletions(-)

-- 
2.55.0.1007.g17ff1f9808-goog

