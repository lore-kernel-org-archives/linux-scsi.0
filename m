Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922663D410C
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887357; cv=none; b=UQ6do74WbPd+HIt9cNklXTWMV6IYJlxxI3JoCEfkC8/i2rhqeqKweE1DhKOt/BCksuWtSFgtfxiaooEyBILsu5SvWVs1jb64256dHU7F0lbvf0Otpmkin13JsBqLnp3j7jmYbKFxWY6DMqmiDOKKcQsUQ+wWHSO9EfvFU/CMEsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887357; c=relaxed/simple;
	bh=5W6uCvKGMuJ+2TNnz7sbNzsgMQCfkeQl2SENyC4WHng=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A9uWGTg4MKcJKcsH3GfNEsOIqbzMbaaXSSX7EhwcIyAQf0vJeDBUi+5gHlaWPznRjCX4W95kmAsIv3e79oNdkSK0pKtbMCCEqPykVMV8xNX4sQJEdpZmgyDmgxGDtFC5Li/FtXfDzixvThg4VjyJJnSrYjrPzEvRb+ZUXy5Sxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DaGmzqb/; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DaGmzqb/"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e83df1d54dso28582415ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 03:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791887356; x=1792492156; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yNt/vmXKTQ+2PqkD2aX+wgRz4VWHpGTq8CV1U/f1f/4=;
        b=DaGmzqb/l+1JbSoCFw7A6v1xHB10KTrrXg+kciTz0ZD5imyFYjqKdJroz9/EhLcW1Q
         IG+7W6pYRY4ARHgsPHONbsRWAi7anWdxCwdEgid/z/nt9Oz8faNaBrtwbfceduynjwXD
         yaoUXmOEXPhteVGb/An906UcdElxcuMNQCQQaJ0tMM8806k5D+Tw5hNg6qh680Xg8GxC
         PCGi0cj/i5k72Xa7uK91TRj1WZkWTldtENtE8b2RwtUD65l2kNV+YbaNueE0gjGpQR/L
         GtTAjnsZDErI1hukTq0f1xnYddf5PXhdW61f7hmGX/yuNuQrgeaoVLoB4mYKz5KPqPye
         +2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791887356; x=1792492156;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yNt/vmXKTQ+2PqkD2aX+wgRz4VWHpGTq8CV1U/f1f/4=;
        b=Y8fjX1tdAbqIZuXmEHtGybsUf/0ezoWNT1nR8jcSDD6Ri1XZZ97/eV8tZ0SzITEMg4
         U7O18J2o1qkUXp45ZqFLcrVAL1056xNu+S1YpOhiKiUVEa8AkWhkWAcOpZdl//hK5JDH
         SZiti3rlSflYU416N51mqiRvtUpWqXxFZ1bYOdwa0mKEKfGgTfEqN8liperTu5J1qDVG
         1NxRjd6/VhWP0NPIefJJuF7SGvdrGobsvofCmyV8Ume4VbG5E8CbUMdNrvl6OyvX3krs
         PPGbESGo/cWvO1vkF1vYboIrgddS8wfut8QLecp3xzH6x9zeQz4d1bvSnBMlobBCq1+9
         ifaw==
X-Forwarded-Encrypted: i=1; AKwUvBxbcoOfcPCbc65TAHbcBJbbD/iyQSND27XGFLDNGPLBvGhjd5xt0GpQiW3cxbXVCi2KxgJVWvTp8fON@vger.kernel.org
X-Gm-Message-State: AFq9FYKYRtMOxNAsS/6w7kXFVh9BwJ1YSULdiwgSGj1+wKXTcq6hPk/O
	YG9ocnJs63FZ1XTbcnM85JaUNxUfzBCVTpIdXUyW2tOytxZqn7cozu1NZjll8i4j9SeUFU3MUtl
	CdniqD2x11Bb3D08QAEpwAw==
X-Received: from plbjh5.prod.google.com ([2002:a17:903:3285:b0:2e2:f305:e980])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3887:b0:2e5:e542:fe34 with SMTP id d9443c01a7336-2e8427edc83mr113762905ad.4.1791887355531;
 Tue, 13 Oct 2026 03:29:15 -0700 (PDT)
Date: Tue, 13 Oct 2026 18:29:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013102913.948718-1-stanleyjhu@google.com>
Subject: [PATCH 0/3] scsi: ufs: Fix UIC result byte and BSG request length handling
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Two ufs-bsg fixes for issues found by fuzzing /dev/bsg/ufs-bsg* with
syzkaller on QEMU's emulated UFS host controller, plus a related fix
for the same UIC result byte problem in the peer DME retry path.

Patch 1 rejects requests shorter than the UFS BSG request structures.
Patch 2 clears the UIC result byte supplied by userspace.
Patch 3 clears the stale UIC result byte before peer DME retries.

Tested on QEMU arm64: the reproducers no longer trigger.

Stanley Jhu (3):
  scsi: ufs: bsg: Validate request_len before accessing request
  scsi: ufs: bsg: Clear the UIC result byte before sending UIC commands
  scsi: ufs: core: Clear stale UIC result byte before peer DME retries

 drivers/ufs/core/ufs_bsg.c | 9 +++++++++
 drivers/ufs/core/ufshcd.c  | 2 ++
 2 files changed, 11 insertions(+)

-- 
2.56.0.385.gd3acb90ef8-goog
