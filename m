From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Switch some more scsi drivers to pci_get_device
	and refcounted pci structures
Date: Mon, 18 Sep 2006 20:45:44 +0100
Message-ID: <1158608744.6069.162.camel@localhost.localdomain>
References: <1158330872.29932.61.camel@localhost.localdomain>
	 <20060918190155.GE17670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55687 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751784AbWIRTVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:21:46 -0400
In-Reply-To: <20060918190155.GE17670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Ar Llu, 2006-09-18 am 20:01 +0100, ysgrifennodd Christoph Hellwig:
> NACK.  This doesn't help us forward at all.  In case you have
> the hardware please do a full conversion to the real pci probing API.

Then please mark every SCSI user of pci_find_device() as && BROKEN and
delete them in 6 months because I want to remove pci_find_device because
its a hazard. The patch I proposed ensures the driver doesn't crash the
box iterating the list unsafely. If you won't accept safe iteration the
driver should be deleted. 

I guess the other alternative would be to add !HOTPLUG to all the
offenders and remove pci_find_device if hotplug is enabled.

Be honest - nobody is ever going to convert that driver or the other
ancient scsi drivers or the serial drivers to the pci module API even if
you play political games NAKing other fixes to try and make it happen. 

James - what would you prefer - removal, && BROKEN, && !HOTPLUG or at
least fixing one thing that needs a fix ?

Alan
