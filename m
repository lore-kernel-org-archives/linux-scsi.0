Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D2411A04
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950255; cv=none; b=YPWB8bmiEwWFxJWTYQmV9tRnh3+1TPE9EwtEpSX8Nz2zp/2zxm6cjYFijzd5vgWM7vxUfkzGVFIp9yWVm9m64l8uTgoenJsHqtmzIum5bLcaJE9lEvJPERUEcCnXoiFdZs6aJ5MwWuhDmKvLYiNEGzCwcZKudNe6IjdbS2bR6hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950255; c=relaxed/simple;
	bh=4NblraOyweAYbfuvlQqsCmWb/iXNYM3JHhorZr99IZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8mJEuXvYQBCuIxgS4gp2MMLYsHmTVrcHDtc+9grBc08Jw+MA7DsQHLyx21Sluh/zN6N9ZwY9JUzgCYWZNLhjiZofOkkle/B3fjmFcw30i9pMeUaPRFn1gWGYMbT4ahbJVzQu1KghrN2fM0xRR/cUZN5bH3T+YT/1ifh3ORItHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KydFbb4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KydFbb4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86801F000FF;
	Wed, 14 Oct 2026 03:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950253;
	bh=1DkqxyFpNiq9RccEecbrNIGMQJb1a156oN+J1zPJa5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KydFbb4S0jjLNhyCgk4tLB0KIM26FdZf901pzPpWVvOR4ZaBgq6/vCLwUGgtWXyV6
	 uSdcg9UN+8kwgzsutLKnLc4cDbjA1jqR/tXu5kL4SF3l6kvmXU7BkZlurXzL/97z5O
	 5VRIi5xlFKe9RyZyJwUTjzpUiyhPK/DvCZPLWFqJ7ZQY/z1zzhMkLCGhgwOTFmJ003
	 UBHj9bl1XlgSMj89f1zVLZKD5DiucpvQkC5eeFPTvNxJqeOZ3SmhRCSxOp7AatgMeE
	 b8509BLaKeuk9kHdiWce3TDovMblN98VX93WA82Pss0oRpraiMuUqyuOkpO5B86/mZ
	 eYWr4T63lKLtw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH] scsi: st: Save the visited block for the partition the drive is in
Date: Tue, 13 Oct 2026 23:57:24 -0400
Message-ID: <179194999398.3016381.11561998396494206112.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006164250.773840-1-loberman@redhat.com>
References: <20261006164250.773840-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 06 Oct 2026 12:42:50 -0400, Laurence Oberman wrote:

> set_location() saves the current tape location before switching
> partitions, so that switch_partition() can return to it later. It reads
> the location with READ POSITION but stores it in the st_partstat of
> STp->partition, ignoring the partition the drive reports.
> 
> The two differ after a device reset. When the reset is recovered with
> MTREW, MTSEEK or MTEOM, st_ioctl() sets STp->partition = 0 and calls
> switch_partition() to return to STp->new_partition. A drive that was in
> partition 1 is still there, so set_location() files the partition 1
> position under partition 0. The next switch to partition 0 locates to
> that block: if partition 0 holds less data, MTSETPART fails with EIO
> (BLANK CHECK), otherwise the tape is silently positioned at the wrong
> block.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: st: Save the visited block for the partition the drive is in
      https://git.kernel.org/mkp/scsi/c/c9e9f024dd4f

-- 
Martin K. Petersen
