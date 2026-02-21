Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6CC325711;
	Sat, 21 Feb 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771695690; cv=none; b=cbdZLcNvWzNk0blabFPH+RPI81ec+vEnD1jgxdNaeOlxT/76qy0phHtKxbR9bdVAdnkzC0FGWK7KwNIVPi0JG8DHhPojSF9vdf/gdVnA9ov6tqyZ+C/W0D/wW6KSTIgAPKhW0chidQ81V2EC+7sGhJPn1luEIaPryUHaQ+hkZmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771695690; c=relaxed/simple;
	bh=hC/bKukwvz707+9AogQXTJbFdJshNSgSwFm4eZcmcjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIk4tGWNo3rbApJH1uchWDSInGaQ+EgHfzSMo0zeH7W/N40spk30bSh3c36dXD+e1CQ9zK+rFrf2TKl6FaP3ZwPWhjg4qzr0Yf360NcSYp63AmVyhyjUO3/+yrXOkZ9d+7JGqXQjEGTdmdCP/NMwXbp9Bjwm/ZHSuVKmoOr58q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLZY01/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLZY01/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B31C4CEF7;
	Sat, 21 Feb 2026 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771695690;
	bh=hC/bKukwvz707+9AogQXTJbFdJshNSgSwFm4eZcmcjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZLZY01/u2Mj5XoC/TEIMxkn1Fyn4UOpnYAx04p7FeFCEMq1SbrqBA5WkhzTtI6kZb
	 QFBx2zeeeONDEz0vZwpr1znz0VM59flDkyZUsvQ11iRioTnfrZY5b02mfaBO49+xkT
	 gVIGx9J54pngaVg75opSFOrSuBqPazXU6im3VACIsoci3hh+mvxcqgHmuyOmrFJxlk
	 PM3x4aiUzSceUFq3RvIcK9e6yWTGZYZgn4p1RIPgV1Lvzjful53O01jX92CcsdvXef
	 C+BwuALX2iFuZVFbMf3f5j+3hnw2jdxCRNw49xhYSPafldjS/KvQ8ZczKvKSKrh8Bd
	 jINjZMvYA9SXg==
Date: Sat, 21 Feb 2026 12:41:28 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Message-ID: <aZnuSC0qYfw0hiwM@kernel.org>
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>

On Fri, Feb 13, 2026 at 02:19:11PM +0000, John Garry wrote:
> At ALPSS 25 I presented a proposal for Native SCSI multipath support. Let's
> discuss this topic at LSFMM.
> 
> The idea for this is that SCSI could natively support multipath, like how
> NVMe host driver does today. It is intended as an alternative to
> dm-multipath support.
> 
> I have been working on the implementation and I plan to post patches in the
> next cycle. I am looking at a 3-stage approach:
> a. create a driver-agnostic multipath library, very heavily based on NVMe
> host multipath support.
> The library would support features such as path management, path
> selection/iopolicy, failover recovery, PR, delayed removal, gendisk
> management etc.
> b. switch NVMe over to use this library

I can appreciate that the kernel to userspace interface of DM
multipath is clearly unwanted (hence NVMe multipath and now SCSI
multipath).

But you should really be switching DM-multipath over to using it too;
or at least detailing _why_ the core of DM multipath
(drivers/md/dm-mpath.c) cannot be updated to use this common backend
library.

This line of work makes little sense to me if it just ignores
dm-multipath.

Mike

> c. add native SCSI multipath support based on this common library
> 
> Thanks,
> John
> 
> 
> 
