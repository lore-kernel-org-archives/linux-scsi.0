Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB6F35F18B
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 03:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405031; cv=none; b=XlUiTy+59QOlTVjAEflx2rXrEaErJ5Sf0oVA4d2ZRaMrmqeqZq54fw2kA2yudBuKC7SAny3ok/1rCm6L55GTd+BhYYlel2OGZFy0Fi+rq818UPmtaCoVkbY6cTdvm4t2kocMp2+vFp7qI2JESb0ndpNxZS3zj7pec20MFaXXTNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405031; c=relaxed/simple;
	bh=aLsF68Srr5QtDOEtw9nx1tvQrbod8b+jhRhK0kDPzPI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5V6gGVUT70AIUjoxsh3SaoSVjKEj+cPHXzL3U8u+/7RYRuSys0xtDzuHrKPfqbIWGLO+e3Xh4H8+ovT/sHrPOEgXTwXz6/QzKw45gnDJOgbmmKhrfMNjddtOgiIUac73DxxmizmAnweenM0Ng+iQ/tFkLyF8CGPeXBhzFTGYjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LW3jC315; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LW3jC315"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06221F000E9;
	Thu,  3 Sep 2026 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405029;
	bh=XbW09RZuLw7t3lUZJnWVAb9PEhhP8ot8ybmm6XhSmu8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=LW3jC3159ViXfIBxKb2JT7Ni4UFqvXlRstqnvCec3Ygz5k3tHL2o6pU9nr3QsnSbz
	 N95FcJmJcpCsPQrxyoKQ/ZCTQ5dF3kkw/e1cq9ars4Q/6ZP6rktszYn9esv2xtxj0X
	 GwC3vm1QwXJfjQWPvFsBZmr+4z7Bvg1oTWOFLArWmKvhBfto67hEaglcTP0pM8We2w
	 apLOJzGSN4vl2JC1mlP//9BYx2d1je+WcZpaKwcGWvWWVuh22zRT5aq3vzLlq4g9Q/
	 N+0lULcrggrPuQXYjlLLEFR0Gu/dSDHA8cEplwgXWdrBUXrkXZG2MsWG8LZ+65hj0G
	 zFEy7l1Ko6gBg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	chandrakanth.patil@broadcom.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: mpi3mr: fix use-after-free on tgt_dev->starget during target device refresh/update
Date: Wed,  2 Sep 2026 23:10:08 -0400
Message-ID: <178840472599.670675.791819635142024713.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831120047.14690-1-loberman@redhat.com>
References: <20260831120047.14690-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 07:59:17 -0400, Laurence Oberman wrote:

> mpi3mr_refresh_tgtdevs() and mpi3mr_devinfochg_evt_bh() read
> tgt_dev->starget and immediately pass it to starget_for_each_device()
> without holding mrioc->tgtdev_lock. Every writer of this field --
> mpi3mr_target_alloc(), mpi3mr_target_destroy(), mpi3mr_slave_destroy()
> and mpi3mr_sdev_init() -- correctly serializes access under
> tgtdev_lock, but these two read sites do not, which leaves a
> check-then-use window against the SCSI core's target teardown path
> (scsi_remove_target(), invoked e.g. via a concurrent host reset,
> sysfs "delete", or SCSI EH device offlining running independently of
> the fwevt workqueue).
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: mpi3mr: fix use-after-free on tgt_dev->starget during target device refresh/update
      https://git.kernel.org/mkp/scsi/c/139f57343b3d

-- 
Martin K. Petersen
