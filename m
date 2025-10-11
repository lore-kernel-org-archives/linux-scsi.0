Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8088917BA6;
	Sat, 11 Oct 2025 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760189855; cv=none; b=SYlCqX98WrmIeqYAkYVNoaJi9b2T8dKMBuwbJyzCeDlRgTDt+tewXlNOdna5O2xVzl4v2r8eGhP4MdNIfEa08eGq2mDMMRpdSLu+SAvCHFj0zF6YKgv/55H2W+YvEaQARatFoDdfLvKIijSu4/pRhN5lRURb18NzdNFA7KDShx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760189855; c=relaxed/simple;
	bh=4UXRUN4/aHl8eK7okIPJe/6Jy94TcSB44y4J0iGyzyc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHZ+pPHwIu75bForAq2uraLYsN6tFNxAyhHVNXdJI6KFQoZv7rpqi1HzUhYn+nAvEs7QIgWNL7HbMsJkbUSWpIp/ITmRt9VNjm5lzSZOQzHEDvPJ1zEYfXtBcB+No0wRK8qgSqA0aEiQBSKH1M69Ph1L37GQBixJQRvpUtq7aHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: 2dRnejWVSDq8kVNahavXrw==
X-CSE-MsgGUID: 9mkm2THkTfmTh6FGQaBpTg==
X-IronPort-AV: E=Sophos;i="6.19,221,1754928000"; 
   d="scan'208";a="154948290"
Date: Sat, 11 Oct 2025 21:36:04 +0800
From: Owen Gu <guhuinan@xiaomi.com>
To: Michal Pecio <michal.pecio@gmail.com>
CC: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
	<linux-kernel@vger.kernel.org>, Yu Chen <chenyu45@xiaomi.com>
Subject: Re: [PATCH] fix urb unmapping issue when the uas device is remove
 during ongoing data transfer
Message-ID: <aOpdRAGzuPViOYBu@oa-guhuinan-2.localdomain>
References: <20250930045309.21588-1-guhuinan@xiaomi.com>
 <20251007225718.3c8b2cd8.michal.pecio@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251007225718.3c8b2cd8.michal.pecio@gmail.com>
X-ClientProxiedBy: BJ-MBX04.mioffice.cn (10.237.8.124) To BJ-MBX05.mioffice.cn
 (10.237.8.125)

On Tue, Oct 07, 2025 at 10:57:18PM +0200, Michal Pecio wrote:
> On Tue, 30 Sep 2025 12:53:08 +0800, guhuinan wrote:
> > From: Owen Gu <guhuinan@xiaomi.com>
> > 
> > When a UAS device is unplugged during data transfer, there is
> > a probability of a system panic occurring. The root cause is
> > an access to an invalid memory address during URB callback handling.
> > Specifically, this happens when the dma_direct_unmap_sg() function
> > is called within the usb_hcd_unmap_urb_for_dma() interface, but the
> > sg->dma_address field is 0 and the sg data structure has already been
> > freed.
> > 
> > The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
> > in uas.c, using the uas_submit_urbs() function to submit requests to USB.
> > Within the uas_submit_urbs() implementation, three URBs (sense_urb,
> > data_urb, and cmd_urb) are sequentially submitted. Device removal may
> > occur at any point during uas_submit_urbs execution, which may result
> > in URB submission failure. However, some URBs might have been successfully
> > submitted before the failure, and uas_submit_urbs will return the -ENODEV
> > error code in this case. The current error handling directly calls
> > scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
> > to invoke scsi_end_request() for releasing the sgtable. The successfully
> > submitted URBs, when being completed (giveback), call
> > usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
> > unmapping operations since the sg data structure has already been freed.
> > 
> > This patch modifies the error condition check in the uas_submit_urbs()
> > function. When a UAS device is removed but one or more URBs have already
> > been successfully submitted to USB, it avoids immediately invoking
> > scsi_done(). Instead, it waits for the successfully submitted URBs to
> > complete , and then triggers the scsi_done() function call within
> > uas_try_complete() after all pending URB operations are finalized.
> > 
> > Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
> > Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
> 
> Hi,
> 
> Was this situation seen in the wild and/or reproduced, or only
> predicted theoretically? Was the patch tested?
>

This problem occurs in real testing environments with low probability
when the UAS device is unplugged during data transmission. Current
patches have been tested and can resolve this issue. However, as
Oliver mentioned in his response, if the resetting flag is set to 1
at this time, it might prevent scsi_done() from being called, which
was not considered in Patch V1.

> I wonder what happens to the submitted URBs when scsi_done() is
> not called. Since the command URB was not submitted (or else we
> wouldn't be here I guess?) the device shouldn't have selected this
> stream before disconnection and it seems that the xHC won't try
> to move data on those URBs, so they won't complete with -EPROTO.
> 

Submitted URBs will be processed through usb_disable_endpoint()
during device removal, eventually triggering usb_kill_urb() in the
usb_disconnect() workflow. This will invoke the completion interface
through usb_hcd_giveback_urb(), returning -ESHUTDOWN to the UAS driver. 

> Will they sit there stuck until SCSI core times out and aborts
> the command? That's poor UX, speaking from experience here.
> 

After applying the current patch, testing has shown that failed commands
in the UAS driver for which scsi_done() was not called after submission
will be completed 30 seconds after a SCSI command timeout occurs.
We will optimize this issue in patch V2, which is currently under testing.

> Maybe it would make sense to unlink them? Unlinking Streams URBs
> is a sensitive topic because it's forbidden if they can become
> the Current Stream, but in this case it looks like they can't.
> 
> Or am I missing something?
> 
> Regards,
> Michal
Dear,

Sorry for the delayed response to this issue.We anticipate
uploading an updated patch V2 next week.

Regards
