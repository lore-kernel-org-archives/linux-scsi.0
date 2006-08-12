From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Subject: Re: aic7xxx broken in 2.6.18-rc3-mm2
Date: Sat, 12 Aug 2006 20:05:00 +0200
Message-ID: <200608122005.01929.daniel.ritz-ml@swissonline.ch>
References: <1155334308.7574.50.camel@localhost.localdomain> <20060811173624.b60d8c47.akpm@osdl.org> <20060812010317.GB25689@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932585AbWHLSFe@vger.kernel.org>
In-Reply-To: <20060812010317.GB25689@kroah.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>, ak@suse.de
List-Id: linux-scsi@vger.kernel.org

On Saturday 12 August 2006 03.03, Greg KH wrote:
> On Fri, Aug 11, 2006 at 05:36:24PM -0700, Andrew Morton wrote:
> > On Fri, 11 Aug 2006 17:17:15 -0700
> > Dave Hansen <haveblue@us.ibm.com> wrote:
> > 
> > > Well, I have a new culprit of the hour:
> > > 
> > > 	gregkh-pci-pci-use-pci_bios-as-last-fallback
> > 
> > Thanks, I'll drop it.
> > 
> > > There was a previous patch that messed up a few of my machines and this
> > > same driver a few months ago, which accounts for my sense of deja vu:
> > > 
> > > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.16-rc6/2.6.16-rc6-mm1/broken-out/gregkh-pci-pci-give-pci-config-access-initialization-a-defined-ordering.patch
> 
> Ugh, this is a mess.  Daniel, why does your machine need this patch, yet
> as per Dave's comments, it's wrong?

it's not my machines. they work fine :) but there where bug reports on linux-pcmcia
for this problem...only shows up with kernel >= 2.6.17. see also bug 6801.

2.6.16 shows this:
	  PCI: PCI BIOS revision 2.10 entry at 0xfb9a0, last bus=0
	  PCI: Using configuration type 1
while 2.6.17+ shows only
	  PCI: PCI BIOS revision 2.10 entry at 0xfb9a0, last bus=0

so accessing the cardbus cards is not possible with PCI BIOS but works
just fine with direct access...

> 
> I think it might come down to the fact that the ordering before used to
> not always happen in the same order (it depended on config options and
> linker luck.)  Now it's "fixed" to be the same way all the time.
> Daniel, can't you solve this with the proper pci boot option?

sure, but the point is: it used to work on those boxes, but broke with 2.6.17

ok, i had a look. the problem is not the patch itself. look at arch/i386/pci/legacy.c
it's where those messages come from:
	PCI: Probing PCI hardware
	PCI: Discovered peer bus 02
	PCI: Discovered peer bus 05

now if pcibios probing never runs pcibios_last_bus is -1 and pcibios_fixup_peer_bridges()
exits immediatley, the other busses are never found...but why legacy probing anyway?

rgds
-daniel
