Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D534414;
	Sat, 14 Sep 2024 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726332672; cv=none; b=mzB/+afRNe8DEjU7ZUxXZ9tar8Swi4JMWJPHHhC92jptgB0ItgAAI1tA3ICuBQxswtKY7JfIlfOtVpp4DITQkgFPJ6vjOKqKhnPJOPwjc+YaErsC4wqEfdMMEwWgqT8w3gs2t2GMwJE+3wk8Ez9DXdX1gTbzznYODcKmPtoDWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726332672; c=relaxed/simple;
	bh=Z71g/E3I7Jij2MRKNDH6gqkcbdpZ8+UYJCRd77hL9Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K83/QUOWTdh+cVATBshTQyD/Je1PuqtTXcHqrK4VsH7/Ia1OCCr/d7mqpeUsv62UoMIanZ91zm6PayInhAeZ3KkY7bcNG0P20CygIMY+LK36TB5jyOCqtDejFv7okmC35RFTHQ3UZIDGbwTg5K1uP3oZ/LSPwm9LIic1n6dqsSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpitQDL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpitQDL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BE7C4CEC0;
	Sat, 14 Sep 2024 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726332672;
	bh=Z71g/E3I7Jij2MRKNDH6gqkcbdpZ8+UYJCRd77hL9Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpitQDL1e/aY6KvLGIo3aTY3pIfqMYtDBf/BdOBMaHPqPxyIaTTlz+oxsjp624wPj
	 1ycwpdjSWg2IDC2kr4/Ba4VYLORvBVAAhfft4TRUYE2HNAmRWVzeRobn6+CeApttgM
	 C8lncDQfs1jBvv5L4x00VQiRfY45Z6QUUPoIDCDuZomSG5epIQGke+lGVnuD4gVzN8
	 xLfC9FVU9/GqVut7P/3reZrKSOrPfp/rWC72L92MWK9HmdlhEeqEhuK9D3gwvfbUsM
	 GgbJekkvTd1hhO1RG9VxorZ4QlhI8d9c5s/RKPSclGKbqyCm+GqOaH2VUi/mZW8QnI
	 rmsjCpeTmVKKw==
Date: Sat, 14 Sep 2024 10:51:10 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv5 4/9] blk-integrity: consider entire bio list for merging
Message-ID: <ZuW-_hu1-98SEjll@kbusch-mbp>
References: <20240913182854.2445457-1-kbusch@meta.com>
 <20240913182854.2445457-5-kbusch@meta.com>
 <20240914073011.GA30261@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240914073011.GA30261@lst.de>

On Sat, Sep 14, 2024 at 09:30:12AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 13, 2024 at 11:28:49AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > If a bio is merged to a request, the entire bio list is merged, so don't
> > temporarily detach it from its list when counting segments. In most
> > cases, bi_next will already be NULL, so detaching is usually a no-op.
> > But if the bio does have a list, the current code is miscounting the
> > segments for the resulting merge.
> 
> As I explained in detail last round this is still wrong.  There is
> no bio list here ever.

Could you explain "wrong"? If we assume there is never bio list here,
then the current code is performing a useless no-op, and this patch
removes it. That's a good thing, no?
