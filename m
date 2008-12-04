From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Thu, 4 Dec 2008 22:23:06 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812042206140.6372@kai.makisara.local>
References: <alpine.LNX.2.00.0812022059120.6402@kai.makisara.local> <20081203092808I.fujita.tomonori@lab.ntt.co.jp> <alpine.LNX.2.00.0812032114110.8158@kai.makisara.local> <20081204145347W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:58784 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYLDUXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 15:23:14 -0500
In-Reply-To: <20081204145347W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, 4 Dec 2008, FUJITA Tomonori wrote:

> On Wed, 3 Dec 2008 21:40:53 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> 
> > > If so, can you try this patch to convert st_int_ioctl?
> > > 
> > I replaced my patch with yours. Now the tests pass. I did some tests with 
> > debugging enabled and those showed that the sense data is returned 
> > correctly.
> 
> Great, then can I get your ACK on this patchset?
> 
Yes, you can add
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

> 
> > > Do you prefer me to change st_scsi_kern_execute to set -EBUSY to
> > > syscall_result if st_scsi_kern_execute internally fails (that is,
> > > blk_rq_map_kern or blk_get_request fails)?
> > > 
> > I am not sure that -EBUSY is a valid error return any more. Should the 
> > error be -ENOMEM if blk_get_request fails and otherwise return what 
> > blk_rq_map_kern returns?
> > 
> > > Note that scsi_execute_async (which st_do_scsi uses) could fail
> > > internally. scsi_execute_async and st_scsi_kern_execute uses the same
> > > functions that could fail, blk_rq_map_kern or blk_get_request
> > > 
> > Yes. I am not sure that -EBUSY is correct return value there.
> 
> I think that it's the right thing to return an error value to user
> space that scsi_execute_async returns but st_do_scsi uses has returned
> -EBUSY for any failure for long time so it might be safer to keep the
> current behavior.
> 
Retaining the old behaviour is always a safe solution but sometimes it is 
time to improve code. Note that scsi_execute_async() only returns 
(DRIVER_ERROR << 24) in case of error. This does not allow using different 
error codes for different error reasons. With st_scsi_kern_execute it is 
possible.

> I'll change st_scsi_kern_execute to set -EBUSY in case of internal
> failure in the next submission if you prefer.
> 
I don't like returning -EBUSY always now that we have a choice. However, 
if you think the conservative solution of returning -EBUSY is better, I 
don't object.

Thanks,
Kai

