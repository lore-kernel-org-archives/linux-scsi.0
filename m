From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFTesters] Re: [PATCH] refactor tmscsim inititalization code
Date: Fri, 10 Sep 2004 15:32:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040910133254.GB32530@lst.de>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3046 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267405AbUIJNc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 09:32:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Sep 07, 2004 at 05:29:43PM +0200, Guennadi Liakhovetski wrote:
> Hi
> 
> I've looked through the patch - I liked it! Still, I've got a few 
> questions / remarks to this one.
> 
> 1) My big problem with this patch is, that I don't have any AM53C7974 
> based hardware with EEPROM, and you re-write the EEPROM handling 
> functions. Although, it does look like you just inlined some of them and 
> removed redundant code. Do you have the hardware to test it? If not - I 
> guess, we'd have to ask for volunteers to test it. Your patch is a bit 
> less than trivial:-) If nobody volunteers, well, I'll have to try to prove 
> the equivalence myself:-)

I'll do a new patch with that part excluded (and ontop of all the
patches currently pending for tmscsim)

> 2) I just realised - we have 2 possibilities to pass parameters to 
> tmscsim, if it is compiled into the kernel - with tmscsim.tmscsim=... 
> and with tmscsim=... I guess, breaking scripts by removing one of them now 
> wouldn't be good... But we could put a warning printk() in dc390_setup 
> "Deprecated! Use tmscsim.tmscsim=... This will be removed real soon 
> now!\n" should we?

I think we should deprecated both and use an easy to understand
module_param-based interface.

> 3) There's a typo:
> 
> >+static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 
> >cd)
> 
> should be
> 
> >+static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 
> >cmd)

thanks.

> 4) Against which kernel version is it? It did apply to some my version, 
> but with some fuzz / offsets.

I don't remember anymore, but I'll rediff anyway.

