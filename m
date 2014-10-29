From: Meelis Roos <mroos@linux.ee>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 17:38:29 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1410291738190.12885@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee> <545102FE.3010003@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37798 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423AbaJ2Pid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 11:38:33 -0400
In-Reply-To: <545102FE.3010003@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

> On 2014-10-29 05:46, Meelis Roos wrote:
> > > I tried 3.18-rc2 with blk-mq default on on HP ProLiant DL380 G3 (with HP
> > > CCISS RAID controller). It fails late in the bootup with "task
> > > scsi_eh_1:720 blocked for more than 120 seconds." messages.
> > >
> > > Booting with scsi_mod.use_blk_mq=0 fixes the problem.
> >
> > Another test server with MPT SCSI RAID has similar problem,
> > scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no serail
> > console). 3.18.0-rc2-00043-gf7e87a4 was tested there.
> 
> The first issue looks like scsi cdrom and error handling, it must be leaking
> requests hence we hang on allocation of a new one. cciss doesn't use blk_mq
> regardless of the scsi setting. Does the mpt box also have a libata driven
> cdrom?

Yes, it does.

-- 
Meelis Roos (mroos@linux.ee)
