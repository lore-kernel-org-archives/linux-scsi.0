From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] sg: O_EXCL and other lock handling
Date: Mon, 16 Jun 2014 15:45:16 +0200
Message-ID: <20140616134516.GB11926@lst.de>
References: <539A453F.5020502@interlog.com> <20140613090316.GA18032@lst.de> <539B0BC1.2020303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52066 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaFPNpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2014 09:45:20 -0400
Content-Disposition: inline
In-Reply-To: <539B0BC1.2020303@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, vaughan <vaughan.cao@oracle.com>

On Fri, Jun 13, 2014 at 10:33:37AM -0400, Douglas Gilbert wrote:
>> this looks generally good to me, but I don't think open_cnt and exclude
>> have to use atomic_t, as they are only ever modified under open_rel_lock.
>
> They are read by 'cat /proc/scsi/sg/debug' [in
> sg_proc_seq_show_debug()] but transient off-by-1 reports
> are not so important. [Prior to locking that block with
> read_lock(sfd_lock) that routine sometimes printed wild
> results, so some care is required.]

In general 32-bit variables that can be read independly only need the lock
for updates.  A lock on the read side is important if variables are of
a type that can't be atomically read (e.g. 64-bit on 32-bit architectures,
or small integers on some old alpha CPUs), or if the values of multiple
variables need to be consistent for the reader.

>> Can you take a look at the version below?  This changes open_cnt to an
>> int, exclude to a bool, removes the open_cnt underflow check that
>> the VFS takes care for, and streamlines the open path a little bit:
>
> sg_open() and sg_release() clean-up looks good. The
> back-up goto at the end of sg_open() reminds me of
> Fortran style :-) More importantly my sg_tst_excl*
> tests give this version the thumbs up.
>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Given that this was your patch with minor changes I was planning to put
this in under your name if that's fine with you.

I'm also looking for another review.
