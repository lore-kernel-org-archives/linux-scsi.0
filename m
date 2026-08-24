Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965D0372EFB;
	Mon, 24 Aug 2026 04:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547584; cv=none; b=TZt1SZwZVMkB5Z6yuS3Xwtjd5Erhlxm9gsL05R1Y++P22qajT1pD4GwW4eQqZs7E2uWX94hPPjoHpo4RalZ9iAsjwucjt72EWVSYiOY4lW2HT16LqtSBAcFmHlKa3jYoNxj2PJJlFrWGrUSDThbL/a3PSbm9Wqv7OxOrRg++GMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547584; c=relaxed/simple;
	bh=LCAxVObHYIfq6I8Hguf7IJ8YGuUWC1rKisVjDAZWsuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQSjRGMZW0b6OZWBvmJj7FcoERr5DGEQ5baxi1bqcll39NUwGTus33Fh0yYIwedWIs9OoXSO5Walkh0J1J6VLfsbyIrz3WAFdiN5bJY49WQglfg3MqUtKlbe4naZh5qteXXs+AFe/+7QDiQAMfXGcD6Nc4zzNQxXupzWyWL2Q7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA4DE68BFE; Mon, 24 Aug 2026 06:59:39 +0200 (CEST)
Date: Mon, 24 Aug 2026 06:59:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5] generic: test I/O on devices with T10 protection
 information
Message-ID: <20260824045939.GC29550@lst.de>
References: <20260821051133.1817670-1-hch@lst.de> <20260821051133.1817670-5-hch@lst.de> <20260821233749.GG839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821233749.GG839663@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 21, 2026 at 04:37:49PM -0700, Darrick J. Wong wrote:
> > @@ -0,0 +1,91 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Christoph Hellwig
> > +#
> > +# FS QA Test No. 2301
> > +#
> > +# Basix FSX sanity check when using T10 protection information
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw pi dangerous
> 
> Why dangerous?  Can this crash the system?

Yes, the strip/insert case (which needs to be enabled through sysfs
crashes all release kernels up to and including 7.2.

