From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Sat, 2 Feb 2008 20:00:53 +0100
Message-ID: <20080202190053.GA27927@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <1201975706.3187.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:47310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYBBTBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Feb 2008 14:01:18 -0500
Content-Disposition: inline
In-Reply-To: <1201975706.3187.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Are you seriously telling us that it required too much investigation 
> on your part to figure out that something with a compile failure in 
> drivers/scsi might belong on the scsi list?

This is getting silly. Let me repeat it, because IMO it's really 
straightforward. My (quick) investigation based on the function name 
that was in the error message:

  drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration
  of function 'pci_enable_device_bars'

a straightforward search on "pci_enable_device_bars" led to a recent PCI 
API related change pushed by Greg, with the following straightforward 
subject line:

  [GIT PATCH] PCI patches for 2.6.24

  http://lkml.org/lkml/2008/2/1/483

the email had this description:

 |  Some general cleanups, minor tweaks, and a bit of PCI hotplug 
 |  updates, and some PCI Express updates for new features, if your 
 |  hardware happens to support it.

furthermore, the mail already had two PCI mailing lists in its Cc: line. 
The PCI subsystem regularly does cross-treee changes, by its nature.

i had all reasons to believe that this was a (innocious looking) PCI 
subsystem change and a harmless (but a tad under-tested) API cleanup 
that went haywire: it smelled like PCI, it walked like PCI and it 
quacked like PCI.

So to me it was clearly a PCI merge not an SCSI merge, and i was really 
only interested in the first hop, i.e. i was primarily interested in the 
pull request that clearly changed multiple subsystems, and a seemingly 
API change that broke the build.

Three mailing lists and three maintainers were already on the Cc: line 
for that pull request. So tell me, exactly what should have let me to 
believe that i should have added anyone else to the _already_ sizable 
Cc: line?? I could have done it, had i have more time and had i realized 
the full scope of the change and the somewhat misleading Cc:s that were 
on the original pull request, but i clearly was not _required_ to - and 
your suggestions to the contrary are ridiculous.

Furthermore i reject the sometimes derogatory undertone of your mails 
that implies that i should somehow have done more or different work than 
i already did.

I really hope you treat other contributors and bug-reporters better than 
you treated me :( Shall this be my last voluntary SCSI contribution for 
a good while.

	Ingo
