Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A612D21B;
	Fri,  9 Jan 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971334; cv=none; b=csCxXlAhZXSSZRSq7fmHRvFZCvzm+t70GBqb9awOEiCTxTOppzhCvwTVdWWFjgHol1u0aV0rP6T7fV+Q5oDUWmPMZOMmsLQEZAi7dgiSPR7pqohERt+mt2ESysAOY1HBB4YhmuFOgwAcSJde2xK0Qpek0qAZIXZyog/VDtG0LlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971334; c=relaxed/simple;
	bh=z331EZjCDr+ryHWTEHITdM0J5yos3eHV9zjnvm+Gk3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VC3kMw1V4Ci0SpFJXqbJ8QJPHkDHqLHPRsDew8TLBaon4dFL6TuyIp55UEWl3zujybexb/sCKcu09a6nPj/bWrCvT87TD3vNNvaEFPZByPIxuArXPmHGemVXEu4o/lUlei3TnQ5fIuyhO/WAiL41TRvimUcmvy3IU2aefKoGTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o3hKksVN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o3hKksVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hmz7thNH8hZin2mScXVvsGXSHQiDWxmRQEbotKTlRwk=; b=o3hKksVNmbJfFO//g4Q5pmsifU
	OwiKZNTMDrTWM8yygq6N8xLwgKKzKxtbXQMC+87AfMbCZ7+BATPjLTxdOoaEwJttWkag6+slHfMy+
	fNV3jE2vX7fWzbey1YWtJTbnDuJagHHA7Jl3eI327mWjz1v2hQn3JOVfOrV5DLi+amuGW1vWEcFYP
	zsJSv5OZS3gLE8UxcHSMHqarMW25OTQ5q2u4lolyqy+HT7nxCDrFXvOiu/JOOc35dZ9ihCHmaBzfO
	qlFVLjkpkLhMwnN0vRSBCQ20jTbyX+2kAZHBsS/rFhJpt9v+CwL8wpvTQX7KDBjwsVOn9DGf8PnAo
	F/miaC8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veE6b-00000002SQB-0OjQ;
	Fri, 09 Jan 2026 15:08:49 +0000
Date: Fri, 9 Jan 2026 07:08:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
	leonro@nvidia.com, kch@nvidia.com,
	LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWEaAQZrvk8CKDOb@infradead.org>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <aWCskbTyA18x-JyT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWCskbTyA18x-JyT@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 08, 2026 at 11:21:53PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 09, 2026 at 02:49:52PM +0800, Ming Lei wrote:
> > Unfortunately I can't duplicate the issue in my environment, can you test
> > the following patch?
> 
> This fixes xfs/049 for me, which was by bisection test.  I'll kick off
> a full xfstests run once VM capacity becomes available later today.

This passed an xfstests run now.

