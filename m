Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65413909A6
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612171; cv=none; b=mocH+FuMqzxjF0hezd/5QRAcAkKSIACniHcy+yHm9U7vU7Lv7GOX2BS9dcZlRvYtS1qjbspgYr+FVF6AfskWiC37pF3w7r4kShXCmUENr2vcjXXKol1EY4SyzAJF44VECG1sXL5+1iaoeGBexB2QgQUpx/QLn7dPYyJO8XkvZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612171; c=relaxed/simple;
	bh=L0CPdeuw6uK7F+cYhuBH8IeDFxrvt81byNlIQ6YnJFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLKUQKcGY14+BAMKqXEGEE1tIle+opopqkUD/EdCMRo7RH9VMuEBkZaCZEUc1MWA5KM1TcdBRsU3vTgcBEPc6dA4CmOEIRZULO7oELGi0yPXoxVXUi4LTbace4GepbRY0/d83mV5ane3CVwOpnGSaJJoK9REnqyvx+LhsChaqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ls1kN5ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ls1kN5ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ED11F0089A;
	Thu, 17 Sep 2026 02:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612151;
	bh=VeEeWVMmh40kW/zfpGyiSo4LDt4J1wVXKzELrTG9rNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ls1kN5ss9l8DA+okEgFKp8rewhoucQt+qMjoQAgvAAd+g8hudOP9YIM+rKPBZb8mF
	 l1Tu1w8jjM3c01FDhqN0wULXL5qLFrp5N+APG/5L6d1fFLCiwFU8Qez0I+FhPOe80h
	 3GYlZyOpO85wrV5KEdIToLNTXzYpSvpDlKQ/SWfF5+47TIqtGBrHfxVE4k6HTeIFzb
	 o9rshj5aUQV4wGY8zeMMAuS4Joh5ayMp4BuffE7arRnM0kCznVEprfd+tqEf2cKiEp
	 EBGfDY1XG9wMsZTp3pGofhwBkOmcZSqhgwg8zN9KhnItRdtDmHP360aEnjgBYBvteg
	 Yx3vFhfmLCmBQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Date: Wed, 16 Sep 2026 22:29:00 -0400
Message-ID: <178952247940.2757716.9098135075916898239.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831064500.2576832-2-hch@lst.de>
References: <20260831064500.2576832-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 09:44:57 +0300, Christoph Hellwig wrote:

> Add a new debugfs file to inject corruptions of the data and/or reftag.
> This will be used to detect that protection information and/or file
> system checksumming can detect random bit errors or misplaced writes.
> 
> To use this echo the start LBA, number of logical blocks and type of
> corruption into the new "corrupt" debugfs file for each scsi_debug
> device.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi_debug: add support to corrupt data and/or reftag
      https://git.kernel.org/mkp/scsi/c/a09d77bcbe22

-- 
Martin K. Petersen
