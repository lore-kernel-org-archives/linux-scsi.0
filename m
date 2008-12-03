From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Wed, 3 Dec 2008 21:40:53 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812032114110.8158@kai.makisara.local>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <alpine.LNX.2.00.0812022059120.6402@kai.makisara.local> <20081203092808I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:55358 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLCTlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 14:41:00 -0500
In-Reply-To: <20081203092808I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, 3 Dec 2008, FUJITA Tomonori wrote:

> On Tue, 2 Dec 2008 21:08:19 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> 
...
> > I added simple conversion (at the end 
> > of this message) but after this, the driver did not pass my simple tests. 
> > Looking at st_scsi_kern_execute(), it seems that it does not copy the 
> > sense data to struct st_request.
> 
> I think that blk_execute_rq copies the sense data for us. So we don't
> need to worry about it.
> 
Now that I looked more carefully, it does that.

> Without your patch, that is, with only my patchset, the driver passed
> your tests?
> 
Yes.

> If so, can you try this patch to convert st_int_ioctl?
> 
I replaced my patch with yours. Now the tests pass. I did some tests with 
debugging enabled and those showed that the sense data is returned 
correctly.

> 
> Do you prefer me to change st_scsi_kern_execute to set -EBUSY to
> syscall_result if st_scsi_kern_execute internally fails (that is,
> blk_rq_map_kern or blk_get_request fails)?
> 
I am not sure that -EBUSY is a valid error return any more. Should the 
error be -ENOMEM if blk_get_request fails and otherwise return what 
blk_rq_map_kern returns?

> Note that scsi_execute_async (which st_do_scsi uses) could fail
> internally. scsi_execute_async and st_scsi_kern_execute uses the same
> functions that could fail, blk_rq_map_kern or blk_get_request
> 
Yes. I am not sure that -EBUSY is correct return value there.

Thanks,
Kai
