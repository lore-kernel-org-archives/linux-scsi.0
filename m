Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201254;
	b=wk2sCKey4uqsMQNPGKZSye1JgktBc7i46iiCE2WCqUgpM2DqS8CSVpJ/3Ttc7G+QBfsH
	 /N89NRGJ0273bRssDbQ1538Eq+vy8j7fEtSTH7Lu7LoMg/m5qhfeEvKG3fy3c/NLfR7I3
	 5fhIop+q3gKDHsVMv9P5fIkSveOrnX418gjg1iEPRCexxRwr86U0cRZwwEKL6TLFIjiMn
	 69XAFhJ4hOdQdSaNHwwVk0QxW/xpXqUFKISw/iw2ATCznkFu2jaQcVhLV91pVInCG9uXb
	 P1aUU/1wuDcPuJ8evl8vTuIaUvN+vCfhdkdWlEPagVgOh4WKwXMjvkU33QJJJFTe6Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=2IUJ4prZfGsGzb0Qck/GAuOjhnwEHRfiPDhs17Z4SoU=;
	b=poZ0bR+9GkbE0jXwSpjJbkLeP4YDDvs5kR09mMm/xTeFK10qlvZBtPW/MxZ4jYejgU49
	 8E6+e0Yuk7HfzE92XQrPr9+rcb3HZm2G7ye0YzsFHlOimg9/Iyh9iL0sTa7R9XKZ/aWxN
	 VlXgOITxLdZOq1/7e2dL+B0tDSfDhUtNe88vpazPUQr5NaKRVS2fiim2mXQmPGI3EqKYU
	 2ZmpJOTodsBN1d09SU1ahN/tD/tjMVDJtQdoIHc0NPI+JB3n6wFlx5NPAOxcqj4FfrzUP
	 G7gg5TEVUWkn6Jngf4+sD/aNH0E+GGnR2meBU0f6NBaeQ5VoezJV4ue/EX2ATURmmMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZklHrKxo;
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D303160A380A
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 19:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D303160A380A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZklHrKxo
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cdd48746a49so811559a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795201248; x=1795806048; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2IUJ4prZfGsGzb0Qck/GAuOjhnwEHRfiPDhs17Z4SoU=;
        b=ZklHrKxo8PI4TUG9EcnZfURC06IahIv2QFJrF+PQZNVoeE3A2hD7BTFl/zpex/XLdE
         OUgO2LYdQ6DKZPNOz/xkP5oEoaKaPsmZZt1Msxy8xylBNrPBPkXj0pFaW9azq+gosh8d
         xQ/EbFB6HWiTdCNX6Fpye9Gt/xVojSVWeIfZqJsZMjWxOAS0FUS7erNcJ3tDVHS4NJGV
         YEq3f10Fe3+KtCCb3ZfhHf52b2RLNiSYi3lOmPC8JYAy7VAMuO1Mo7NUueIj5GhHScph
         H/rwLYUORCbyiNxh//vYtnJpjPDuA5gR+UobB0V4enDoeA+yrR+yO/fRqubGwQZx6nF8
         oY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201248; x=1795806048;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IUJ4prZfGsGzb0Qck/GAuOjhnwEHRfiPDhs17Z4SoU=;
        b=o4TD5aVPBeWEeyCINOpmwaqUuCtltqEUM9HnpK4/3UIwk3VdLy0WAAmkd4Iz8sF5qe
         0Kq7zZEygZHPAveI2ovTpPT38UrW5NegK9rGcPapRtcDlc9LeUxcgu1uQeyyHs8EAhB4
         pXxdulH4Ti1uMwETsAEM/utdSmvQem9tPCgf9Tx+I8Z3jcSK9LGPMLrutYMxAy/MNsSZ
         bv6nPSKHLDBrXVG6iNIP222/0cbyr0tXxKUf4gAB/7iXnox6UjS3qURVkdoByvzq+qT3
         FoOZF9z0VjXVwOmGwkglbFOOIDACe6T4l873VlRn9IKWFst1l9cX2OXGthEvWB7eWnTE
         cuEg==
X-Forwarded-Encrypted: i=1; AL+hErGWKGtiTpb+Os/MP9xxZqOPCjbJiZmoFT4Mp361tiqwFD9lqXKjH9i28zdFnlJxveIGS4q0nMmoz1Rs@vger.kernel.org
X-Gm-Message-State: APuU4Z/a3kM4EtWnNDGFvbt0U0neyIQFlmHq5F/U8kwaZifL9mBLm9Un
	kGv70p9TdxBrO69liW+SOCrQeHPSL852aSQNNkk26pMBcGNL3gSmJ07RLDB3Cj2RzgCMDRzljFa
	yLopNOAFOvw==
X-Received: from pgiy3.prod.google.com ([2002:a63:de43:0:b0:cca:d82:9104])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:db97:b0:3dd:a006:ed90
 with SMTP id adf61e73a8af0-4014bc4e776mr3903412637.38.1795201247965; Fri, 20
 Nov 2026 11:00:47 -0800 (PST)
Date: Fri, 20 Nov 2026 11:00:29 -0800
In-Reply-To: <20261120190031.1587531-1-irogers@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261120190031.1587531-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120190031.1587531-2-irogers@google.com>
Subject: [PATCH v2 1/3] scsi: mpi3mr: Return error on all failure exits in mpi3mr_bring_ioc_ready()
From: Ian Rogers <irogers@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In mpi3mr_bring_ioc_ready(), all success paths return 0 directly, while
all failure paths either fall through out_failed or jump to
out_device_not_present and return retval.

However, retval is initialized to 0 at function entry and overwritten
with 0 once mpi3mr_setup_admin_qpair() succeeds. As a result, failure
paths that do not set retval themselves - including unrecoverable fault
checks, PCI device removal during reset or diagnostic-save waits,
failure to reach MRIOC_STATE_RESET, and ready-loop fault/reset-history
exits or timeouts - return 0 (success) to mpi3mr_init_ioc() and
mpi3mr_reinit_ioc(), causing initialization to proceed against a failed
or absent controller.

Set retval = -1 at out_device_not_present whenever retval is 0 so every
failure exit returns a non-zero error while preserving specific error
codes from helper calls.

Found during an x86_64 LLVM=1 allyesconfig warning audit with AI coding
assistant help. Verified with a standalone C logic reproducer and by
building drivers/scsi/mpi3mr/mpi3mr_fw.o with LLVM=1 W=1 (-Werror); not
runtime-tested on MPI3 hardware.

Fixes: 59bd9cfe3fa0 ("scsi: mpi3mr: Code refactor of IOC init - part2")
Cc: stable@vger.kernel.org
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..416f27c37535 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1744,6 +1744,8 @@ out_failed:
 	    "failed to bring to ready state,  current state: %s\n",
 	    mpi3mr_iocstate_name(ioc_state));
 out_device_not_present:
+	if (!retval)
+		retval = -1;
 	return retval;
 }
 
-- 
2.56.1.750.gf70dc682cf-goog

