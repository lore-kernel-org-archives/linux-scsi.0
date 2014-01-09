From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Thu, 9 Jan 2014 15:50:45 -0800
Message-ID: <20140109235045.GA17660@xanatos>
References: <063D6719AE5E284EB5DD2968C1650D6D455431@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D455431@AcuExch.aculab.com>
 <52CCA94D.5090700@gmail.com>
Sender: stable-owner@vger.kernel.org
To: walt <w41ter@gmail.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[Walt, please use reply-all to keep the list in the loop, thanks.]

On Wed, Jan 08, 2014 at 04:09:14PM +0000, David Laight wrote:
> > From: Sarah Sharp
> > On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> > > On 01/07/2014 01:21 PM, Sarah Sharp wrote:
> > >
> > > > Can you please try the attached patch, on top of the previous three
> > > > patches, and send me dmesg?
> > >
> > > Hi Sarah, I just now finished running 0001-More-debugging.patch for the
> > > first time.  The previous dmesg didn't include that patch, but this one
> > > does.
> > >
> > > I read through this dmesg but I nodded off somewhere around line 500.
> > > I hope you can stay awake :)
> > 
> > Well, it has all the info I need, but the results don't make me too
> > happy.  Everything I've checked seems consistent, and I don't know why
> > the host stopped.  The link TRBs are intact, the dequeue pointer for the
> > endpoint was pointing to the transfer that timed out and it had the
> > cycle bit set correctly, etc.  Perhaps the no-op TRBs are really the
> > issue.
> > 
> > I'll have to take a look at the log again tomorrow.  I posted the dmesg
> > on pastebin if David wants to check it out as well:
> > http://pastebin.com/a4AUpsL1
> 
> I can't see anything obvious either.
> However there is no response to the 'stop endpoint' command.
> Section 4.6.9 (page 107 of rev1.0) states that the controller will complete
> any USB IN or OUT transaction before raising the command completion event.
> Possibly it is too 'stuck' to complete the transaction?

The host has to stop processing the transaction, it can't "wait" for the
transaction to finish.  "The Stop Endpoint Command is expected to stop
endpoint activity as soon as possible, which may mean that it stops in
the middle of a TRB."

Usually when hosts get into this kind of mode, something has seriously
gone wrong, like bus error when it issues a bad memory access.

> The endpoint status is also still '1' (running).
> This also means that the 'TR dequeue pointer' is undefined - so the
> controller could easily be processing a later TRB.
> This field might even still contain the ring base address written by
> the driver much earlier.
> 
> This might mean that something 'catastrophic' has happened earlier.
> Maybe the controller isn't actually seeing any doorbell writes at all.
> Maybe the base addresses it has for the rings have all got corrupted.
> At least this looks like amd64 - so there aren't memory coherency issues.
> 
> Some hacks that might help isolate the problem:
> 1) Request an interrupt from the last nop data TRB.
> 2) Put a command nop (decimal 23) TRB into the command ring before
>    the 'stop endpoint'.
> 3) Comment out the code that adds the nop data TRBs.
> The first two might need code adding to handle the responses.
> 
> Do we know the actual xhci device?
> I think it reports version 0x96.
> (Sarah - it might be useful if that version were in one of the trace
> messages that is output by default.)

You mean print the PCI device and vendor ID?  Perhaps Subsystem vendor
as well?

On Tue, Jan 07, 2014 at 05:26:37PM -0800, walt wrote:
> On 01/07/2014 04:47 PM, Sarah Sharp wrote:
>  
> > Can you send me the output of `sudo lspci -vvv -n`?  Maybe we can just
> > turn off scatter-gather for your host controller until we get a proper
> > fix in that uses link TRBs instead of no-op TRBs.
> 
> The aftermarket usb3 adapter card and the usb3 outboard hard-drive docking
> station are the only two usb3 devices I have.
> 
> I've wondered if my xhci problems might be caused by hardware quirks, and
> wondering why I seem to be the only one who has this problem.
> 
> Maybe I could "take one for the team" by buying new hardware toys that I
> don't really need but I could use to test the xhci driver?  (I do enjoy
> buying new toys, necessary, or, um, maybe not :)

It would be appreciated if you could see if your device causes other
host controllers to fail.  Who am I to keep a geek from new toys? ;)

In the meantime, try this patch, which is something of a long shot.

Sarah Sharp

--envbJBWh7q8WU6mo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-xhci-Enable-Link-TRB-quirk-for-0.96-ASMedia-host.patch"

>From 19e2ab85ac2cc0d84f56247dcf29bdce14bd70d5 Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Thu, 9 Jan 2014 15:46:04 -0800
Subject: [PATCH] xhci: Enable Link TRB quirk for 0.96 ASMedia host.

A recent bug fix commit causes an ASMedia host to stop responding to
commands.  See if it needs the link TRB quirk.  This was generally only
necessary for 0.95 hosts, but maybe this 0.96 host needs it.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 3c898c12a06b..8196ac2289e4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -92,6 +92,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA && pdev->device == 1042)
+		xhci->quirks |= XHCI_LINK_TRB_QUIRK;
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 
-- 
1.8.5.2


--envbJBWh7q8WU6mo--
