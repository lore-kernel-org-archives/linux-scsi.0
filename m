From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 2 Jun 2010 18:05:35 +0900
Message-ID: <20100602180515J.fujita.tomonori@lab.ntt.co.jp>
References: <4C0612CC.6050602@panasas.com>
	<20100602173925H.fujita.tomonori@lab.ntt.co.jp>
	<4C061C41.2010104@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39677 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0FBJFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2010 05:05:49 -0400
In-Reply-To: <4C061C41.2010104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

On Wed, 02 Jun 2010 11:54:25 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Some LLDs already use scsi_get_lba(). They don't know scsi command
> > from pc or fs so they can't use scsi_get_lba() now. Well, they can see
> > scsi_cmnd->request to know pc or fs but it's layer violation. They
> > shouldn't access to the block layer stuff.
> > 
> 
> right, so hide it all under an API that is implemented at the right
> level, and protect them. The driver should call a single simple
> API the magic will be done at the generic level
> 
> 	if (blk_fs_rq(req))
> 		return blk_rq_pos(req);
> 	else
> 		return scsi_somthing();

The first version that I posted yesterday is something like that. But
I don't think that it's clean.


> >> Only drivers/code that actually cares should call this member.
> >>
> >> It should be easy enough to search for __sector and change them
> >> to a function call.
> > 
> > I don't think that calling such function in LLDs is a clean design. We
> > set request->__sector for fs requests. Why not for pc requests? Then
> > we can use blk_rq_pos() cleanly. 
> > 
> 
> Because "fs requests" have a defined blk_rq_pos(). But "pc requests"
> don't necessarily have one. Pretending to invent one is stupid and
> dangerous. Better keep a -1 for all "pc requests".

I don't see your logic, why using blk_rq_pos() for pc is dangerous?


> scsi LLDs can be pass-through for disks, as well as lots of other
> type of devices. They should not assume the role of a disk. The use
> of blk_rq_pos() at LLDs is probably wrong in the first place. Unless
> it is some kind of scsi emulation driver like scsi_debug.

Not only scsi_debug. Have you seen how scsi_get_lba() is used? LLDs
sometime needs to know lba in scsi commands.

How about calling this function in sd_prep_fn, sr_prep_fn instead of
scsi_setup_blk_pc_cmnd? Then it doesn't affect OSD.
