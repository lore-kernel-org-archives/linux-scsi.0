From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Thu, 29 Jan 2004 22:25:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2228980000.1075440305@aslan.btc.adaptec.com>
References: <1073076654.2048.19.camel@opiate> <1073120514.4429.0.camel@laptop.fenrus.com> <1282412704.1073168696@aslan.scsiguy.com> <20040104100448.GA2416@devserv.devel.redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:47783 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266537AbUA3FSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 00:18:30 -0500
In-Reply-To: <20040104100448.GA2416@devserv.devel.redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Eric Kerin <eric@bootseg.com>, linux-scsi@vger.kernel.org

> <snip the rest>
> -----------------
> 
> There are 2 reasons to work this way, and I would very much prefer the
> adaptec drivers to behave like this:
> 1) PCI Hotplugging
> 2) Adding PCI ID's at runtime
> 
> While you may not care about 1), a lot of IHV/distros care about 2); eg if
> Adaptec puts out a card that can be driven by aic79xx but with just a new
> PCI ID, hardware vendors can just add the ID at runtime and have it work in
> the (factory) installer etc but only *if the driver is loaded* ....

Well, if you look at the Adaptec drivers, they already attach to all
possible IDs for the chips that are supported.  They do this by registering
a very generic PCI ID table and filtering all requests through their
own tables.  Each of these tables is terminated with a generic entry
that will attach to any of the supported chipsets regardless of the
"fungible bits" in the chip's PCI IDs.  The only exception to this rule is
for chips that are explicitly labeled as owned by a RAID controller or are
in HostRAID mode.  This latter restriction is going away too since
Adaptec is migrating to an MD based solution for its HostRAID products.

In other words, #2 doesn't require these drivers to stay loaded.  For
#1 to work generically, something should load drivers since it isn't
practical to have every driver that could possibly be needed to service
a hot-plug event in loaded in your kernel.

--
Justin

