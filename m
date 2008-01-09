From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: eliminate the home grown dma padding in favour
	of	that provided by the block layer
Date: Wed, 09 Jan 2008 09:13:54 -0600
Message-ID: <1199891634.3493.9.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <47842D29.8020509@gmail.com>
	 <1199852673.3534.76.camel@localhost.localdomain>
	 <4784580E.3060000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4784580E.3060000@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 2008-01-09 at 14:13 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> >>  Also, DMA alignment at
> >> block layer isn't enough for ATA.  ATA needs drain buffers for ATAPI
> >> commands with variable length response.  :-(
> > 
> > OK, where is this in the libata code?  The dma_pad size is only 4 bytes,
> > so this drain, I assume is only a word long?  Given the word alignment
> > requirements of ATA doesn't this still mean it's only draining up to the
> > word boundary anyway (so the code is still correct)?
> 
> Patch is acked but not merged yet.
> 
> http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=commit;h=6cd22a0febc74bebe52d58eb22271b8770892a2d
> 
> The full function can be read from the following.  It's
> ata_sg_setup_extra().
> 
> http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=blob;f=drivers/ata/libata-core.c;h=d763c072e6cefc724ea24cb68a7adf47b340f054;hb=6cd22a0febc74bebe52d58eb22271b8770892a2d

OK, but that patch was sent to the mailing list on 4 Jan ... five days
after this one.  It's a little hard to take unposted patches into
account ...

It's a fairly comprehensive merge clash ... where is this drain patch on
the upstream track?  because currently ipr and aic94xx panic the system
without the dma padding removal (I just figured -rc6 was a bit late for
major surgery like this, but I was planning a backport if it stood up in
2.6.24).

James


