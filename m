From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [RFTesters] Re: [PATCH] refactor tmscsim inititalization code
Date: Tue, 7 Sep 2004 17:29:43 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
References: <20040904130235.GA20552@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:9431 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268073AbUIGPaY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 11:30:24 -0400
In-Reply-To: <20040904130235.GA20552@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi

I've looked through the patch - I liked it! Still, I've got a few 
questions / remarks to this one.

1) My big problem with this patch is, that I don't have any AM53C7974 
based hardware with EEPROM, and you re-write the EEPROM handling 
functions. Although, it does look like you just inlined some of them and 
removed redundant code. Do you have the hardware to test it? If not - I 
guess, we'd have to ask for volunteers to test it. Your patch is a bit 
less than trivial:-) If nobody volunteers, well, I'll have to try to prove 
the equivalence myself:-)

2) I just realised - we have 2 possibilities to pass parameters to 
tmscsim, if it is compiled into the kernel - with tmscsim.tmscsim=... 
and with tmscsim=... I guess, breaking scripts by removing one of them now 
wouldn't be good... But we could put a warning printk() in dc390_setup 
"Deprecated! Use tmscsim.tmscsim=... This will be removed real soon 
now!\n" should we?

3) There's a typo:

> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cd)

should be

> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cmd)

4) Against which kernel version is it? It did apply to some my version, 
but with some fuzz / offsets.

So, all in all - looks quite good, but I'd wait a bit until either 
somebody tests it or I otherwise persuade myself that it is (mostly) 
harmless:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

