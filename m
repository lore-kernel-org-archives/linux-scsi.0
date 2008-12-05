From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Fri, 5 Dec 2008 15:25:26 +0900
Message-ID: <20081205143300Y.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LNX.2.00.0812032114110.8158@kai.makisara.local>
	<20081204145347W.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812042206140.6372@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53424 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <alpine.LNX.2.00.0812042206140.6372@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, 4 Dec 2008 22:23:06 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Thu, 4 Dec 2008, FUJITA Tomonori wrote:
> 
> > On Wed, 3 Dec 2008 21:40:53 +0200 (EET)
> > Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> > 
> > > > If so, can you try this patch to convert st_int_ioctl?
> > > > 
> > > I replaced my patch with yours. Now the tests pass. I did some tests with 
> > > debugging enabled and those showed that the sense data is returned 
> > > correctly.
> > 
> > Great, then can I get your ACK on this patchset?
> > 
> Yes, you can add
> Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

Thanks!


> > > > Do you prefer me to change st_scsi_kern_execute to set -EBUSY to
> > > > syscall_result if st_scsi_kern_execute internally fails (that is,
> > > > blk_rq_map_kern or blk_get_request fails)?
> > > > 
> > > I am not sure that -EBUSY is a valid error return any more. Should the 
> > > error be -ENOMEM if blk_get_request fails and otherwise return what 
> > > blk_rq_map_kern returns?
> > > 
> > > > Note that scsi_execute_async (which st_do_scsi uses) could fail
> > > > internally. scsi_execute_async and st_scsi_kern_execute uses the same
> > > > functions that could fail, blk_rq_map_kern or blk_get_request
> > > > 
> > > Yes. I am not sure that -EBUSY is correct return value there.
> > 
> > I think that it's the right thing to return an error value to user
> > space that scsi_execute_async returns but st_do_scsi uses has returned
> > -EBUSY for any failure for long time so it might be safer to keep the
> > current behavior.
> > 
> Retaining the old behaviour is always a safe solution but sometimes it is 
> time to improve code. Note that scsi_execute_async() only returns 
> (DRIVER_ERROR << 24) in case of error.

Ah, right, I overlooked it.


> This does not allow using different 
> error codes for different error reasons. With st_scsi_kern_execute it is 
> possible.
> 
> > I'll change st_scsi_kern_execute to set -EBUSY in case of internal
> > failure in the next submission if you prefer.
> > 
> I don't like returning -EBUSY always now that we have a choice. However, 
> if you think the conservative solution of returning -EBUSY is better, I 
> don't object.

Thanks, I see.

I simplified st_scsi_kern_execute by using scsi_execute. scsi_execute
returns DRIVER_ERROR << 24 for internal failures like
scsi_execute_async does. I changed st_scsi_kern_execute to return
-EBUSY for now as st_do_scsi does.

st_scsi_kern_execute would be changed again in the second half so this
might be changed. But I think if we change return code, it would be
better to do it in a separate patch (explicitly).
