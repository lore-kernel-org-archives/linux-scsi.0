From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata - success with 82801AA IDE
Date: Wed, 29 Oct 2003 16:44:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FA034DA.8020102@pobox.com>
References: <Pine.LNX.4.58.0310291626210.29421@marabou.research.att.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53900 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261680AbTJ2VpL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 16:45:11 -0500
In-Reply-To: <Pine.LNX.4.58.0310291626210.29421@marabou.research.att.com>
List-Id: linux-scsi@vger.kernel.org
To: Pavel Roskin <proski@gnu.org>
Cc: linux-scsi@vger.kernel.org

Pavel Roskin wrote:
> Hello!
> 
> I just want to report that Intel 82801AA IDE controller (8086:2411) is
> working with libata from 2.6.0-test9-bk3.  I applied following patch:

Cool.



> I have a CD-ROM as master on the the secondary channel (normally seen as
> /dev/hdc), but it doesn't support DMA, so it wasn't detected.

Well, even so, ATAPI support is very incomplete at the moment.  That's a 
bigger reason why PATA support isn't receiving more love, at the moment.


> I don't know if there is any interest in developing the "parallel IDE"
> support.  I see that the option to enable it is not present in Linux
> configuration.  Anyway, that's a device that can be added to the
> device table if PATA support is here to stay.

I find it quite useful locally, and will be finishing up cable detection 
(currently PATA is limited to UDMA/33) soon.  However, with my 
apologies, I won't be applying your patch -- for the moment.  Before any 
more PATA PCI ids are added, I'll need to go through the docs and 
drivers/ide/pci/piix.c, to determine precisely PATA chipset speed 
limits:  UDMA/133 for some, UDMA/100, etc.  Your patch is a bit 
incorrect in that it does not truly reflect the maximum speed of the 
82801AA chipset.

In any case, the executive decision has been made "drivers/ide for PATA, 
libata for SATA", so that's the overall direction.

Thanks,

	Jeff



