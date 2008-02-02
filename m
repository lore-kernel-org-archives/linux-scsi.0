From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Sat, 02 Feb 2008 12:08:26 -0600
Message-ID: <1201975706.3187.36.camel@localhost.localdomain>
References: <20080201231147.GA18174@suse.de>
	 <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org>
	 <20080202170828.GA12748@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54234 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933660AbYBBSId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 13:08:33 -0500
In-Reply-To: <20080202170828.GA12748@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2008-02-02 at 18:08 +0100, Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
> > Ingo Molnar wrote:
> >> ===================================================================
> >> --- linux.orig/drivers/scsi/lpfc/lpfc_init.c
> >> +++ linux/drivers/scsi/lpfc/lpfc_init.c
> >> @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
> >>  	uint16_t iotag;
> >>  	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> >>  -	if (pci_enable_device_bars(pdev, bars))
> >> +	if (pci_enable_device_io(pdev))
> >>  		goto out;
> >
> > Look at the line right above it...  AFAICS you want 
> > pci_enable_device_mem(), if the mask is selecting IORESOURCE_MEM BARs.
> >
> > Also a CC to linux-scsi and the driver author would be nice, as they 
> > are the ones with hardware and can verify.
> 
> it would have been totally appropriate for me to just send a mail to 
> lkml with the proper subject line about the breakage. (I might even have 
> decided to stay completely silent about the issue and fix it for my own 
> build, letting you guys figure it out.)

We agreed to differ a while ago on your head in the sand, post it to
LKML because everybody follows that list attitude.  Some nice soul will
always (eventually) forward to the correct list, so this practice more
or less works (just not in as timely fashion as actually posting to the
relevant list).

> Instead i did a search of lkml (based on the function name in the build 
> error) and figured out where the pull request was on lkml: Greg. I 
> replied to that mail, he'll obviously know whom else to Cc from that 
> point on (if anyone). I really didnt want to (nor did i need to) figure 
> out whether this was some general driver level API change that happen 
> kernel-wide, or some SCSI specific change. I simply replied to the pull 
> request whose Cc: line seemed well-populated to me already. I also took 
> a look at the commit itself and did a quick hack in a hurry to keep the 
> tests rolling. It really did not occur to me that i should have added 
> anyone else to the Cc: line, as linux-pci@atrey.karlin.mff.cuni.cz was 
> Cc:-ed already so i assumed the interest was from that angle.
> 
> ( And as this was spent from my family's weekend time and i had no time
>   and no interest to dig any further than to figure out the "first hop"
>   of the change that broke the build, and the parties who initiated that
>   hop. I'm in fact surprised that your and James's answer to my
>   bugreport is hostility. )

What's hostile about telling you your patch is wrong and pointing you at
the correct one?

> So i find your suggestion that i should have added more people to the 
> Cc: line unfair on several levels.
> 
> > This set of changes seemed like 50% guesswork to me, without 
> > consulting the authors :( And unlike many changes, you actually have 
> > to know the hardware [or get clues from surrounding code] to make the 
> > change.
> 
> you mean the whole set of changes? Or just mine? Mine was a 30 seconds 
> guesswork of course, i dont have the hardware, i didnt do the change, 
> nor did i do anything near that code - i just saw the build failure stop 
> my testing and sent in this notification and a hack. That's why i sent 
> it to Greg, as a reply to the mail where he pushed these changes 
> upstream and who'll know what to do with it from that point on. My patch 
> can be totally thrown away (and should be, apparently).
> 
> but ... i guess next time i'll think twice before sending any bugreports 
> about or related to the SCSI code anywhere, unless they become really 
> annoying. Who needs this hassle?

Oh good grief, don't come the raw prawn with us!

You're a kernel maintainer, you are expected to know the rules and
follow them.  The very fact that a well known maintainer posts a patch
with a signed-off-by to Andrew and Linus means that it likely gets
applied.  Because of this, maintainers and other people with similarly
trusted positions are expected to go via the lists and subsystems in
part as general courtesy, but also to verify that their patch is
actually valid before it gets applied.

Are you seriously telling us that it required too much investigation on
your part to figure out that something with a compile failure in
drivers/scsi might belong on the scsi list?

Let me tell you exactly what would have happened if that patch had been
applied:  Because the wrong bars were enabled, the device would have
attached but been non-functional.  Likely Emulex would have picked this
up in their -rc1 testing and spent several days trying to trace the
cause in their labs.  Chances are, that, because this type of breakage
is extremely subtle, they wouldn't have noticed the fact that the enable
should have been _mem not _io.  Then they would have raised the issue to
linux-scsi.  It would probably take at least a person week of effort
before anyone finally noticed what the issue was.

If you can't see that your behaviour needs modifying, I suggest you
seriously consider your position.  For all our talk of a nice utopian
democracy of meritocracy in Open Source, we're critically dependent on
the tree gatekeepers to maintain this.  None of us is immune from the
subtle lure of the arrogance of power but it's a corrosive poison and
must be avoided at every turn.  You and I follow more rules and are held
to a higher standard that the average patch submitter because of our
position in the community (not in spite of it).

James


