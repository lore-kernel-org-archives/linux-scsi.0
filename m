From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [pnfs] [PATCH 05/28] pnfsblock: expose scsi interface
Date: Wed, 12 Mar 2008 16:03:42 -0400
Message-ID: <20080312200342.GB7537@infradead.org>
References: <1205263929-8346-1-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-2-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-3-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-4-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-5-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu> <47D805DE.9000100@panasas.com> <20080312164306.GA3519@infradead.org> <2ea9cd5a0803121052p6569ff37l26a5448e588407ad@mail.gmail.com> <Pine.BSO.4.64.0803121400550.20573@citi.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYCLUED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 16:04:03 -0400
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.64.0803121400550.20573@citi.umich.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredric Isaman <iisaman@citi.umich.edu>
Cc: Jason Glasgow <jglasgow@aya.yale.edu>, Christoph Hellwig <hch@infradead.org>, Benny Halevy <bhalevy@panasas.com>, Andy Adamson <andros@umich.edu>, pnfs@linux-nfs.org, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 12, 2008 at 02:10:03PM -0400, Fredric Isaman wrote:
>>> Yes, absolutely.  No one outside of few places in the core scsi code
>>> should ever iterate over the scsi disks.
>>>
>
> Is this for locking reasons?

It's for abstraction and data hiding reasons.  The existance of such
a list is an implementation detail.   Any inkernel or external user
should use the block device API to access block devices.  Even the
implementation using the scsi layer is an implementation detail.

> Basically, we are given a disk signature, (an array of offset, byte
> sequence pairs) and want to match it against some visible disk (ignoring
> partitions), or know that it is not currently visible.
>
> Thus our requirement are:
>
> Scan all available block devices (though all available SCSI devices is a
> workable substitute).
>
> Notification of new devices would be a helpful in optimizing rescans for 
> unmapped disk signatures.
>
>
> As Jason mentions, we will pursue doing this in userspace.

Try looking into the libvolume_id and libblkid libraries which solve
exactly this problem already, and it's a quite complicated one to start
with.

