Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A4192D6B;
	Tue, 29 Jul 2025 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753827860; cv=none; b=P5KNPJObYPkuSmw7At2cLecv2Duzt4J5GIjdbJVYCxCgFardI7AaXmpw3SCVsM2ozswI1apYrBO1+a8YUIrQPwG1B036ses1ug4Nh1bNjlmALixMdqregFvWjhuDL1CnqNl7XCiTWrMVFplqFYTqkwStbOoeNhrNM7pubWPFZvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753827860; c=relaxed/simple;
	bh=m+dW8qFaDNCO9oHehMLMxPVDKuVPYt5FuFimxhrAGkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XP+U1CXIv59eVdLgoWmA4UurYVFxKclnCHB2kBIkofB7Lq34hfkNOAYed3GK3As1JsLQizbkOCf2zve7R+BJ/Lotve8OieUzkQhOeDGvvMQzTDqMCjFeq/FcmjwlADBNSZR1U7TBzT6nP50dF2+qXBt7GSblxXXtYBdWmrfNNjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCFt9qDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCFt9qDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D95C4CEEF;
	Tue, 29 Jul 2025 22:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753827860;
	bh=m+dW8qFaDNCO9oHehMLMxPVDKuVPYt5FuFimxhrAGkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LCFt9qDxsClSD68kzlnnlGhD+eOvATHtBbZccCr+h3+s0FQkyBnwNNShoYC7cBieT
	 fk8FMnmfacFVzUTXfFYWln1EhZCNc83YAUuGpvxWOrinvokUD6VUIb3CydxnNsCFQ/
	 HirmFXPZp77xMYa7xBgRZQFbszVdRFY62G1c6XQ4RkVAuRhnSXntucoNqsZX3sY+NQ
	 SA44QD6gFchobzO4+zcDETBb4a1qaiMzGCG+a5n3JUPg53CMiFnAhI3ddjRPdDXZS+
	 cF90ou9Bs72KQNCOtbqkxQ02sdrR8rUYiqKPgtYo7GtFS98arc4Caxeutj8o60L8za
	 UgGZiQR5lPlag==
Date: Tue, 29 Jul 2025 16:24:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Damien Le Moal <dlemoal@kernel.org>,
	=?iso-8859-1?Q?Csord=E1s?= Hunor <csordas.hunor@gmail.com>,
	Coly Li <colyli@kernel.org>, hch@lst.de,
	linux-block@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Improper io_opt setting for md raid5
Message-ID: <aIlKEWx_0hf-IGQw@kbusch-mbp>
References: <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
 <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
 <9e85c424-6722-4315-b125-d0d26fc4574b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e85c424-6722-4315-b125-d0d26fc4574b@suse.de>

On Tue, Jul 29, 2025 at 08:13:31AM +0200, Hannes Reinecke wrote:
> > > Note that chunk_sectors limit is the *stripe* size, not per drive stride.
> > > Beware of the wording here to avoid confusion (this is all already super
> > > confusing !).
> > 
> > This is something we're not in the same page :( For example, 8 disks
> > raid5, with default chunk size. Then the above calculation is:
> > 
> > 64k * 7 = 448k
> > 
> > The chunksize I said is 64k...
> 
> Hmm. I always thought that the 'chunksize' is the limit which I/O must
> not cross to avoid being split.
> So for RAID 4/5/6 I would have thought this to be the stride size,
> as MD must split larger I/O onto two disks.
> Sure, one could argue that the stripe size is the chunk size, but then
> MD will have to split that I/O...

Yah, I think that makes sense. At least the way nvme uses "chunk_size",
it was assumed to mean the boundary for when the backend handling will
split your request for different isolated media.
