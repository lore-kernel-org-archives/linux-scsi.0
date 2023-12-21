Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88A58229
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RunbdBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BABC433CA;
	Thu, 21 Dec 2023 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703178124;
	bh=1a/yxjrZ/9ESvAGqHJPmvOk2fuQ8WTuuUhZMju7QStc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1RunbdBKJhZNQijtFAE8Iz1JEIQP2d3/JBrZpLVbpkCIO4cNfFQaLqPo3LtRHWRQE
	 M6Fy17SOfIeCkObRzQda1fV48RvQnNOAsJ/iw9MusqghluTGVVpYhm+t82V8MbR18S
	 7qs0l+F9qfHP3fUabaQ8ZtJblHPCJMLQoUNiz2ns=
Date: Thu, 21 Dec 2023 18:02:01 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"lduncan@suse.com" <lduncan@suse.com>,
	"cleech@redhat.com" <cleech@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Nilesh Javali <njavali@marvell.com>
Subject: Re: [EXT] Re: [PATCH] cnic: change __GFP_COMP allocation method
Message-ID: <2023122147-unshaved-finch-2cf3@gregkh>
References: <20231219055514.12324-1-njavali@marvell.com>
 <ZYExB52f/iDzD8xL@infradead.org>
 <CO6PR18MB4500F0DCD64925A775A45F2DAF97A@CO6PR18MB4500.namprd18.prod.outlook.com>
 <ZYPfr5G2j2VWUmfR@infradead.org>
 <c9f7d912-d19e-484b-837e-b07171979eef@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f7d912-d19e-484b-837e-b07171979eef@redhat.com>

On Thu, Dec 21, 2023 at 09:33:44AM -0500, John Meneghini wrote:
> Including Greg.
> 
> On 12/21/23 01:48, Christoph Hellwig wrote:
> > On Tue, Dec 19, 2023 at 06:16:38AM +0000, Nilesh Javali wrote:
> > > If you are referring to the series proposed by Chris Leech, then this had
> > > objections. And that was the reason to look for an alternative method for
> > > coherent DMA mapping.
> > > 
> > > [PATCH 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
> > 
> > Yes.  Well, Greg (rightly) dislikes what the iscsi drivers have been
> > doing.  But we're stuck supporting them, so I see no way around that.
> 
> If this is true then can we reconsider Chris's patches.
> 
> Red Hat has multiple enterprise customers who are relying on this driver and
> we need to keep it running - at least till the end of RHEL 9.  We can try
> and drop support for bnx2/cnic in RHEL 10 but RHEL 9 is in the middle of its
> life cycle and a failure to address this issue is causing many problems as
> we attempt to keep RHEL 9 current with what's upstream.

So you are trying to tell me to accept kernel patches today to keep
RHEL9 obsolete systems alive?  And then sometime in the future we can
drop those changes because why?  That feels very wrong and confusing.
What does what gets merged in 2024 have to do with RHEL 9 systems?  You
are free to do whatever you want in your enterprise kernels, don't rely
on making me take broken-by-design code and be forced to maintain it for
the next 10+ years please, that's just not nice.

> Greg, can we please take Chris's patches upstream?

It's a total abuse of the UIO api, and I thought I actually had comments
about it doing it incorrectly as well.  Resend them in the new year
after they have been cleaned up and we can reconsider them then, it's
too late now for anything new for 6.8-rc1 with the holidays apon us now
anyway.

And get the "we want you to take this crud and maintain it for forever
because we have to support an obsolete and out-of-date kernel for paying
customers" story a bit more straight so it doesn't sound so bad :)

thanks,

greg k-h
