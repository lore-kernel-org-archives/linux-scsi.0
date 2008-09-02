From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 02 Sep 2008 15:22:42 -0400
Message-ID: <48BD9282.702@garzik.org>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>	<48BD2136.1020101@garzik.org>	<20080902125310.729b0997@lxorguk.ukuu.org.uk>	<48BD2B37.6060000@garzik.org> <20080902145710.2034690d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51464 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYIBTWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 15:22:47 -0400
In-Reply-To: <20080902145710.2034690d@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Nelson <mdnelson8@gmail.com>, linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>

Alan Cox wrote:
>> Refresh my memory...  what is the problem with loading pata_marvell first?
> 
> The fact its almost impossible to do with a distribution kernel. eg
> you can't make it work with Fedora (see the Fedora bugs assigned to
> you)

Hogwash -- just load one driver before the other.


> If pata_marvell should be driving these chips please remove the entries
> from the ahci.c driver as I asked before.
> 
> If ahci.c should be driving them then we need the documentation for
> whatever extension they use driving the ports via AHCI. Clearly there is
> one as its possible under Windows.

Situation before ahci mod:

	Users with PATA may use pata_marvell.
	Users wanting SATA screwed.
	Users wanting PATA+SATA screwed.

Situation after ahci mod:

	Users with PATA may use pata_marvell
	Users with SATA may use ahci
	Users wanting PATA+SATA screwed


>> AFAICS, if you load pata_marvell before ahci, it will grab the PATA 
>> disks and the PCI device itself.
> 
> If you have a degree in initrd-foo

Just switch the order of 'ahci' and 'pata_marvell' in 
/etc/modprobe.conf, then use Fedora's tools regenerate the initrd.

See?  It's not rocket science, and the current configuration can be 
easily made to work for Fedora users.

	Jeff



