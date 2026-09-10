Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73B25DB0D
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 02:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006441; cv=none; b=apX6rvuYUDVNMWII0VnR51zDbDdK+TwDz44BMDjSzqU+ezYpv5XAyrG0IbqEvX5md9d3ms/3/HA1P+w0F7iEpY6syrGQ+6VcTdLnTPzT8+ih6Ih3KOexcPYXDgUJnURKeauemPUot8w8dYs73UjN3godSmB6pcgSo/I2N0Nzlaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006441; c=relaxed/simple;
	bh=VZuGzVh5N49CJQvFpICzu/YowMEW3x5+Kpq55T4aWQs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=d2f+rJRuhIRRWLrBg6IYF/NymBma6IyYpdqIoIuyddCxBMwyCLqjDOTskbtNH7tQtjliRASXkZl2KJVToDFC7bZM282yDLCEGLdfXEzvn+FoYdDK5e21fx+Gj9h8QHvyAc9auk/YHZoekW5QKCGrX/lTZp1Bjm3QPdiG5nPWdy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2kzyUMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2kzyUMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2551F000FF;
	Thu, 10 Sep 2026 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789006439;
	bh=JJKp/82qYLzIMwai3WknmOB+Al3v9B8Yqgx27ZhbffA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=C2kzyUMQjL6zGWN+CJh2R3CIxuxyx4gJ430tEhT/GHYxeVunX25YJ+OBM216TeJKL
	 IQva/AzWwQW0s84giQgRhYi64yVKeFuitORHJRpmNrbdMjPkb79ABPJq11Kh9w4R07
	 ENjop+N07FhqftrzTL4eig1VWgqhTYVVzrU5t3UpNUy4EUHJy8wlcbdgT+tmiGCR2r
	 vFchLj4Ol+Ohp8hVVUErgzUy9cOozmRvnhGfdCF1K272xTFvDFVDKkDQK1ocf3JFK+
	 TC0yepHJZQguYCHrqFCmNUySzbcCOTHLnLRCLDD+1FabLRWi4QI/Q6FbM/Z3xKDZid
	 RzjM2JBA/3BpA==
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com,  linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260831064500.2576832-2-hch@lst.de> (Christoph Hellwig's
	message of "Mon, 31 Aug 2026 09:44:57 +0300")
Message-ID: <yq133vhc0q6.fsf@mail.kernel.org>
References: <20260831064500.2576832-1-hch@lst.de>
	<20260831064500.2576832-2-hch@lst.de>
Date: Wed, 09 Sep 2026 22:13:58 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Christoph,

> Add a new debugfs file to inject corruptions of the data and/or
> reftag. This will be used to detect that protection information and/or
> file system checksumming can detect random bit errors or misplaced
> writes.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
