Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201256;
	b=Sswqt3b1x0ajfIjcomtpy2pnllgWBDnQJ2evFbJFbeO4pW2hbxs1PY5Z3T1q6mnYW9C7
	 O1nAPZrFn5xS0sjKIfhk12HeCZXDgFfSn0l2Zi7Rw6WbdPq1uRCGt04ckDLGaXr5ykqfZ
	 Wz1nfrOGQ7GKINI064Rz6VHNcgQ/IawIdyH9RrMz9zouvGIEw5Ek1PQ6kpd/gYFta8o4Y
	 7v47cn3hn7bPqQ+hQa2pYUksTxUxZIvfAGJbKUwxxElGB2yfhl9d7P1C8YcRV406zkHu1
	 OnHArhn4sMigCdDyvJWHWnsu9ZVTu8ztAhlzvxywZwOe5VBE6Gb6P0FxBO4CyFDSI2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201256;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=UNLjbm4DATGnAXYQNaz3Ekm01BREm2qtWAOyb3LUDX8=;
	b=xwEsEXj4gEhYe3u5abl3Mn13y8RM0YGBgRJKbPKWcogAjh+J7vUKHV1vSL/uXMd/CmgB
	 Z+Z0CuD+sKb1yldJ2+ng3E+7G90jjTvlqrBBpFTp/N1+Inci6jl00KFeydtyP54sAcTgH
	 0mLErVyp3rg86qruLgZ2ksZN+cNLF9xrQrG+0Ggqa73SkzP9JsE29ZDB6ZUAE7kgtXhYh
	 8tAfSk8LPVMynckqjO+a2Bx5b5gU+p8iYPnOlOjV3ZiY+YAxWIaMBJLXuwthiPTqNlKvT
	 lpQsBIMLXCm4voHa9mQ++0RPl5hFUIuoJiwZnbUojBXp+D2ijDfiCCWSXHX1jiQRdVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JAhqkxbm;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D5F60A263B
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 19:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91D5F60A263B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JAhqkxbm
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1a5005fd0f8so2229420c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795201240; x=1795806040; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UNLjbm4DATGnAXYQNaz3Ekm01BREm2qtWAOyb3LUDX8=;
        b=JAhqkxbmIkOhtP5FM2VZ7m5v1kCutgrj5sLE0vGz+5DDXqt7FuvbPCT+mjrVhDGfPM
         e/7ZNz7pai8TXmXAtJ8363EO+GBUrsXoja4cZg3NCHuamS0rZVqKoSIhcx8w54ri9jz4
         AsimjJy1kYwuRzadrI+QnAzhcDljKdSRqTyMjNxFtUQZ09RZ3cwH5f9BHnO2y3tMoVce
         zKppTqrx8viT6HVXhtGpM37P/FfRT5sr4+eqJvt3rOz+M5G6B5LApCFiBHAZs3Y5wCBH
         lwGN/EZgjrMW+zSUhx/D5BXRedhNKumTkWPKWekFO1WMaEEV2D8LHnmeJPOqT50h4ZZT
         bA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201240; x=1795806040;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNLjbm4DATGnAXYQNaz3Ekm01BREm2qtWAOyb3LUDX8=;
        b=VP7XF2h68jrFWPYigv35z1CMhnjXQmpuphSpGntASNHtTK5+0+wL6/ONvyMY8XuJdK
         yiMXY7S429UeK9sPv06H0azdgI7xbYE2FHWNN4xqcaFQtw2mb6JZcJWvwLTckJW4C6Y7
         k4pgOtafVEeswdeHzj++cD2vbQvzXvNptH/khhBheQF26ppD3/hNlV+2hunrOa3KS71u
         dAggd5IulneGwQY8qRcURH+O4FCH/FNWXnZ/Ab13GN7fHSr+RXZxF5UxpvrnZtEH8wHa
         PA2Kqm3mo/i7c4Zg/FQ/BycglLnAZhOIKeU0NCCdKiIiPT0heWFmpjz7F2lQlCRUSXxc
         6bsg==
X-Forwarded-Encrypted: i=1; AL+hErHY5jn7O+L4rjSdwmDesp9G7rMNdeQxStHC8YZCb9VavDgxWegDTYAxfizyNbT2BegkBXvrbt7RZxYk@vger.kernel.org
X-Gm-Message-State: APuU4Z+z+eOe0+0S4jFm9yeQ9qwlAvhe5oQD+pWLMm+oCh06+WcMZeBn
	XegwLE7B/svnVPsSc4oYMMVk0JvT/I/hu7t4vyLfDon+VaWNN6lSyNFa7uTADxi8QLzxU1OGBW1
	hv2TE+v5ncQ==
X-Received: from dlbuu1.prod.google.com ([2002:a05:7022:7e81:b0:1b3:ba1e:2c7])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:4584:b0:1ac:9da7:e86e
 with SMTP id a92af1059eb24-1b556908c17mr3830341c88.30.1795201239052; Fri, 20
 Nov 2026 11:00:39 -0800 (PST)
Date: Fri, 20 Nov 2026 11:00:28 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120190031.1587531-1-irogers@google.com>
Subject: [PATCH v2 0/3] scsi: mpi3mr: Fix error return, start_time, and
 timeout check in mpi3mr_bring_ioc_ready()
From: Ian Rogers <irogers@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Split the mpi3mr_bring_ioc_ready() error-handling and retry fixes into
three independent patches with individual Fixes: tags as requested by
Laurence Oberman:

1. Return -1 instead of 0 on failure exits in mpi3mr_bring_ioc_ready()
   when retval is 0 (such as unrecoverable controller faults, hot-unplug
   during reset/diag-save waits, or ready-state faults and timeouts
   after mpi3mr_setup_admin_qpair() sets retval = 0).
2. Initialize start_time = jiffies on entry and guard the post-enable
   timestamp reset with a boolean flag so pre-enable failures and
   subsequent retries never read an uninitialized start_time.
3. Rewrite 'elapsed_time_sec < (mrioc->ready_timeout - 60)' as
   'elapsed_time_sec + 60 < mrioc->ready_timeout' to avoid 32-bit
   unsigned underflow if a controller reports ready_timeout < 60.

v2:
  - Split v1 into three patches, each with its own Fixes: tag (Laurence
    Oberman).
  - Move 'if (!retval) retval = -1;' to 'out_device_not_present:' in
    patch 1 so a single hunk covers both out_failed fallthroughs and
    early out_device_not_present jumps cleanly for stable backports.
  - Add Laurence's Reviewed-by tag on patches 1 and 2, and note the
    510s (570s - 60s) firmware timeout math from commit 9634bb07083c in
    patch 3.

v1: https://lore.kernel.org/r/20261119170900.1530138-1-irogers@google.com

Ian Rogers (3):
  scsi: mpi3mr: Return error on all failure exits in
    mpi3mr_bring_ioc_ready()
  scsi: mpi3mr: Initialize start_time on all paths in
    mpi3mr_bring_ioc_ready()
  scsi: mpi3mr: Avoid ready_timeout underflow in
    mpi3mr_bring_ioc_ready()

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.56.1.750.gf70dc682cf-goog

