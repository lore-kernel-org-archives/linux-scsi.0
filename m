From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/7] block: push down BKL into .locked_ioctl
Date: Thu, 8 Jul 2010 13:56:38 +0200
Message-ID: <201007081356.38771.arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-3-git-send-email-arnd@arndb.de> <4C358DFF.9090401@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C358DFF.9090401@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 08 July 2010, Jens Axboe wrote:
> On 2010-07-07 16:51, Arnd Bergmann wrote:
> > As a preparation for the removal of the big kernel
> > lock in the block layer, this removes the BKL
> > from the common ioctl handling code, moving it
> > into every single driver still using it.
> >
> > diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> > index ad3ddef..fc593fb 100644
> > --- a/drivers/message/i2o/i2o_block.c
> > +++ b/drivers/message/i2o/i2o_block.c
> > @@ -941,8 +930,7 @@ static const struct block_device_operations i2o_block_fops = {
> >       .owner = THIS_MODULE,
> >       .open = i2o_block_open,
> >       .release = i2o_block_release,
> > -     .ioctl = i2o_block_ioctl,
> > -     .compat_ioctl = i2o_block_ioctl,
> > +     .locked_ioctl = i2o_block_ioctl,
> >       .getgeo = i2o_block_getgeo,
> >       .media_changed = i2o_block_media_changed
> >  };
> 
> Hmm?

This is the result of a git-rebase gone wrong on my side. The entire first
patch gets reverted as part of the second patch, which is not what I indented.

Sorry about the confusion. Please just apply patch 1/7 again on top of the series
to fix it up, or fold that patch into this one (block: push down BKL into
.locked_ioctl) to make it not change i2o_block.c any more.

	Arnd
