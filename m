From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [2.6 patch] show "Fusion MPT device support" menu only if BLK
	_DEV_SD
Date: Wed, 21 Jan 2004 12:00:09 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703A75F51@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@fs.tum.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "config FUSION" entry in Kconfig is handling both mptbase.ko 
and mptscsih.ko for some reason?

The mptbase.ko driver is the lower layer driver which configures
the adapters and is transport layer to and from the chip. It doesn't
depend on anything in the scsi mid layer.  

The mptscsih.ko does depend on scsi_mod.ko, but not sd.ko  

Therefore - maybe we could have separate entries in Kconfig for
both mptbase and mptscsih.  mptbase depend on PCI, and mptscsih
depend on SCSI. What do you think?

Eric Moore
LSI Logic

On Tuesday, January 20, 2004 4:36 PM, Christoph Hellwig wrote:
> On Wed, Jan 21, 2004 at 12:25:07AM +0100, Adrian Bunk wrote:
> > With BLK_DEV_SD=n, I see a "Fusion MPT device support" menu I can't 
> > enter.
> > 
> > The simple patch below removes the "Fusion MPT device 
> support" menu if 
> > BLK_DEV_SD=n.
> 
> I'd rather see an explanation from LSI why a scsi LLDD depens 
> on a uper
> driver.  This can't be right.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
