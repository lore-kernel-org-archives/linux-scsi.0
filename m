Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48DC2D2486
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 03:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789270597; cv=none; b=eXTePvJZ7u168NHXUaDHbAtrrVBGHw7XD+YsY5ADd1jc9sjs6OMGVPe5TeH5bOwtwY1QQCQ8IKmhUYqsmWY4dUEzdrTII0vMzolZxKQTqnYNc/BBxPvz5yt5jUWnb1J78Wt0x40Qy0I3MmhP6Oc+dyI1JQRBsRKoz5IzrsofZyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789270597; c=relaxed/simple;
	bh=sxrD6dFoKrupjfKZa6sGixEbZfg4udNopod7mJ51Zak=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GlrNeeOx3qmmpQ2H9kvgtDHLBn6nMYfpEJzyWZc9YQWuF0arkYP4kztlFZ1FbofwQH75Vb/XWtjnHeJagpJDp8aA41c3w6haNbr61ZOXjp/RqTkkovy4NDGTQHvdB2CI4smaoceUmkuA/JeP0aQvRld8mLgBofq1H51SDBewIWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JKo12CYH; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JKo12CYH"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-381250979d5so2439094a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 20:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789270595; x=1789875395; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x/697aAAcJoRYdXrZYLU2EIjiMJ6xHcAjmEmwYwdbmE=;
        b=JKo12CYHipwm49/wZ4YJ5iwl6WyvpdMd4i/4jeBpCNJl9Ic61RcYoczX6aoT59QugE
         UvpxklCjzz6OAxWZZoOeMbxsdfA3Wf8WaiC0Nj1ac+52h0tU7DIr3yFRxJM08xGPZ9MW
         V3GEu1SUIb6neK+Rqwd+mTt7DLlUfW0WNj3jugih3q6xBUlO6yzZ7nY/BTm9RBLhSaMm
         uoY4xNjT9VIFl1lv22QhFsskv7JgUC5ZqlEdy4mhGHKzxHFYkNPa91fRJEAkoG3MK/rH
         RPzD9YQKkYEn4g5yFWilKU4gBUb/xSy9KyftYbtp4Az2t3egVrvJjLCuMdytnqi76h40
         5edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789270595; x=1789875395;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/697aAAcJoRYdXrZYLU2EIjiMJ6xHcAjmEmwYwdbmE=;
        b=ORqujO3EgpRIodvq0ORKxmtMXdHPIS/y46lJW5mUyYhpwEZ0T4j29+ZunFmYVNFrk/
         9HHwYO768NQG7fI4+Fu23WuRgNuQPc3PaHi2qUkrXe2CJvwNVH39jrduTJVCyX0vS5bJ
         WYa1N8avH+Zmd7/eWXRGRHiPzroia5PlFtjk7pzam3+nGQn+OBpT1IlyrmV7MhuK7kqk
         jP8YQyU57GMDqcGygMTRfHjwyb3+JWhImn5jAJvu8xt+dMWHvI+VUMWg1KiD6UKj5G56
         1qvQiPqQVgZdQsgg6qTuJY1Vk09c4kpQ+9jNNmiOahiEsG+nmANq1P0+1iyeC6Ihtlob
         8XrA==
X-Forwarded-Encrypted: i=1; AKwUvBy0qjV+GeBndJkcoa2MuXsQyb+VSB6AL2k0PPBPCtWqwaXm6b4hwC82jOOpCGXUQ3jpuhtOh9TFF5C/@vger.kernel.org
X-Gm-Message-State: AFuF++nBZwYueEmUer1gBJwHEmtQQuJSqc+nq9nUcuf7Bxj31xjLX+2f
	oGpKdy6MXPWAvXmwmdtFpmuR/Az4JYuGk2qO2dJdyx/vKQfN1T1H3pVWMFjihHPBwNrbi5FBAH4
	2O4drSW2FajjfJPEYraLyXg==
X-Received: from pjzr19.prod.google.com ([2002:a17:90b:513:b0:39d:9bed:76c2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:39a7:b0:398:9bd1:3214 with SMTP id 98e67ed59e1d1-39d9c223eb3mr18915256a91.21.1789270594954;
 Sat, 12 Sep 2026 20:36:34 -0700 (PDT)
Date: Sun, 13 Sep 2026 11:36:30 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913033633.3159296-1-stanleyjhu@google.com>
Subject: [PATCH v4 0/3] rpmb: Fix request serialisation and teardown races
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	tomas.winkler@intel.com, shyamsaini@linux.microsoft.com, 
	alex.bennee@linaro.org, James.Bottomley@HansenPartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

This merges two series that were both last posted as v3:

  [PATCH v3] rpmb: core: Guard frame requests and teardown with mutex
  https://lore.kernel.org/all/20260910015515.1991789-1-stanleyjhu@google.com/

  [PATCH v3 0/2] scsi: ufs: rpmb: Fix bus registration and device lifecycle
  https://lore.kernel.org/all/20260910015503.1991119-1-stanleyjhu@google.com/

They turned out to be one problem. The UFS patches make RPMB registration
succeed for the first time, and registering RPMB devices without the core
fix triggers a use-after-free on any unbind that races an in-flight
request. Landing them as two independent series would leave that window
open in between.

The order is chosen so that no commit enables RPMB registration before the
lifetime handling and the serialisation are in place:

  1/3 fixes the generic core. It fixes the teardown race on eMMC today
      and carries a stable tag. It has no effect on UFS, where nothing
      registers yet.
  2/3 fixes the UFS device lifetime. Still nothing registers.
  3/3 removes the never registered bus, which is what finally makes UFS
      RPMB devices appear.

drivers/misc/rpmb-core.c and drivers/ufs/ are not in the same tree. 1/3
has no build or runtime dependency on the other two and can be taken on
its own; 2/3 and 3/3 must not land before it.

Verified on QEMU arm64 with KASAN, PROVE_LOCKING and SLUB_DEBUG_ON, against
a UFS device advertising four 4 MiB RPMB regions. Two kthreads on different
CPUs issue RPMB_GET_WRITE_COUNTER against the same region 20000 times each
and compare the nonce echoed back; a third thread holds an rpmb_dev
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

Upstream QEMU answers SECURITY PROTOCOL IN/OUT on the RPMB well known LU
with INVALID OPCODE, so the three rows above also needed a local QEMU
change that implements the authenticated frame state machine. I can post
that to qemu-devel separately, and send the test module to anyone who
wants to reproduce the numbers.

Changes since v3:
- merged the two series and reordered so registration is enabled last
- dropped the incorrect Tested: line from the core patch
- dropped Cc: stable from the UFS patches; the feature has never worked on
  any released kernel, so there is nothing to back port
- rewrote the commit messages around the measured results

Stanley Jhu (3):
  rpmb: core: Guard frame requests and teardown with mutex
  scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF
  scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus

 drivers/misc/rpmb-core.c    |  34 ++++++++++--
 drivers/ufs/core/ufs-rpmb.c | 102 +++++++++++++++++++-----------------
 include/linux/rpmb.h        |   6 +++
 3 files changed, 90 insertions(+), 52 deletions(-)

-- 
2.55.0.1007.g17ff1f9808-goog

