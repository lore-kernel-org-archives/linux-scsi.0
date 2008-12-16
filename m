From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Tue, 16 Dec 2008 22:35:07 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812162222110.6348@kai.makisara.local>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <alpine.LNX.2.00.0812152138090.6315@kai.makisara.local> <20081217025655O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48120 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbYLPUfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 15:35:15 -0500
In-Reply-To: <20081217025655O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 17 Dec 2008, FUJITA Tomonori wrote:

> On Tue, 16 Dec 2008 00:24:27 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> 
> > On Thu, 11 Dec 2008, FUJITA Tomonori wrote:
> > 
> > > This patchset is the second half of the patchset to remove
> > > scsi_execute_async in st driver. IOW, this converts st driver to use
> > > the block layer functions.
> > > 
...
> > I have looked at this patch set and run some tests. The patches make 
> > st_do_scsi() do everything it used to do before your patch sets. So, I 
> > could not resist making a patch that obsoletes st_scsi_kern_execute() from 
> > your first patch set :-) The patch is at the end of this message.
> 
> I have to admit that I thought about the same thing. :)
> 
> I prefer symmetric APIs (e.g. st_do_scsi always needs st_request or
> st_allocate/release_request are used in st_do_scsi) but yeah, I agree
> that your patch makes st look much prettier.
> 
I have learned to like having only one function for submitting SCSI 
commands from the driver. It has sometimes made debugging easier.

> 
> > The simple tests pass without problems. Unfortunately, the same does not 
> > apply to tests with bigger blocks. I wrote some data to tape and read it 
> > with dd. Whenever the block size exceeded 1 MB, I got data corruption just 
> > after the 1 MB limit.
> 
...
> Can you replace the first and second patches in the patchset with the
> following patch (that is, scsi-misc and this patch + #3-13 patches in
> the patchset)?
> 

I did this and have done both the basic tests and tests with big block 
sizes. No problems and data corruption seen so far. However, one thing 
puzzles me: today trying block size above 6144 kB returns EBUSY whereas 
yesterday I could use 16000 kB (although with data corruption but this 
should be fixed by your new patch that increments the offset between 
bios)?

I will do some more tests tomorrow but your code looks really good.

Thanks,
Kai
