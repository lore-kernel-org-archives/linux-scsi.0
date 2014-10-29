From: Meelis Roos <mroos@linux.ee>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 22:06:43 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee> <545102FE.3010003@kernel.dk> <20141029183828.GA31689@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:37399 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbaJ2UGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 16:06:45 -0400
In-Reply-To: <20141029183828.GA31689@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

> On Wed, Oct 29, 2014 at 09:08:46AM -0600, Jens Axboe wrote:
> > >Another test server with MPT SCSI RAID has similar problem,
> > >scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no serail
> > >console). 3.18.0-rc2-00043-gf7e87a4 was tested there.
> > 
> > The first issue looks like scsi cdrom and error handling, it must be leaking
> > requests hence we hang on allocation of a new one. cciss doesn't use blk_mq
> > regardless of the scsi setting. Does the mpt box also have a libata driven
> > cdrom?
> 
> cciss does use scsi for CDROMs and other external devices, it is a bit
> of a mess.
> 
> Meelis, did you also test scsi-mq on 3.17 and this is a regression, or
> was 3.18-rc2 the first kernel you tested?

Both machines ran 3.17 successfully. I turned on scsi-mq option as soon 
as it appeared in Kconfig as a new option. But I am not sure whan the 
option appeared, before or after 3.17 release.

-- 
Meelis Roos (mroos@linux.ee)
