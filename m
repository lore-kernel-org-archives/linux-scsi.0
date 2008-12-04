From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Thu, 4 Dec 2008 14:53:41 +0900
Message-ID: <20081204145347W.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LNX.2.00.0812022059120.6402@kai.makisara.local>
	<20081203092808I.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812032114110.8158@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39992 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYLDFxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2008 00:53:55 -0500
In-Reply-To: <alpine.LNX.2.00.0812032114110.8158@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, 3 Dec 2008 21:40:53 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> > If so, can you try this patch to convert st_int_ioctl?
> > 
> I replaced my patch with yours. Now the tests pass. I did some tests with 
> debugging enabled and those showed that the sense data is returned 
> correctly.

Great, then can I get your ACK on this patchset?


> > Do you prefer me to change st_scsi_kern_execute to set -EBUSY to
> > syscall_result if st_scsi_kern_execute internally fails (that is,
> > blk_rq_map_kern or blk_get_request fails)?
> > 
> I am not sure that -EBUSY is a valid error return any more. Should the 
> error be -ENOMEM if blk_get_request fails and otherwise return what 
> blk_rq_map_kern returns?
> 
> > Note that scsi_execute_async (which st_do_scsi uses) could fail
> > internally. scsi_execute_async and st_scsi_kern_execute uses the same
> > functions that could fail, blk_rq_map_kern or blk_get_request
> > 
> Yes. I am not sure that -EBUSY is correct return value there.

I think that it's the right thing to return an error value to user
space that scsi_execute_async returns but st_do_scsi uses has returned
-EBUSY for any failure for long time so it might be safer to keep the
current behavior.

I'll change st_scsi_kern_execute to set -EBUSY in case of internal
failure in the next submission if you prefer.


Thanks,
