From: "Smith, Hibbard" <Hibbard.Smith@nasdaq.com>
Subject: RE: 53c8xx_2 driver for SymBios SCSI adapters
Date: Fri, 18 Jun 2004 08:45:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <42DB3021E70A164EB14AAD5181F8280D2B8462@mer-exch2.corp.nasdaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mer-tsm1.nasdaq.com ([206.200.253.23]:26884 "EHLO
	MER-TSM1.NASDAQ.COM") by vger.kernel.org with ESMTP id S265131AbUFRMpW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 08:45:22 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx, smitty@essnjay.com

Matthew,

Thanks for the pointer.  When I got to where I could get the patch last evening, I applied it to a straight 2.6.6 kernel from kernel.org.  I rebuilt the kernel and tried booting it.  It hung exactly as before.  I'll include a transcription of the messages here.  Because the system never gets up, I can't do this as machine readable, but I did write it all down, and will include most of it here.  Please, forgive me if I give you too much data, but I'm not sure what I can safely leave out. So, here it comes:

sym0:		<1010-33> rev 0x1 at PCI 0000:00:08:0 IRQ 19
sym0:		open drain IRQ line driver, using on-chip SRAM
sym0:		using LOAD/STORE based firmware
sym0:		handling phase mismatch from SCRIPTS
sym0:		SCSI BUS has been reset
scsi0:	sym-2.1.18j
	Vendor: Quantum	Model: ATLAS 10k 9WLS	Rev: UCH0
	Type: Direct-Access		ANSI SCSI revision: 03
sym0:0:0:	tagged command queuing enabled, command queue depth 8
scsi(0:0:0:0): Beginning domain validation
sym0:0:	wide asynchronous
sym0:0:0:	ABORT operation started
sym0:0:0:	ABORT operation timed-out
sym0:0:0:	DEVICE RESET operation started
sym0:0:0:	DEVICE RESET operation timed out
sym0:0:0:	BUS RESET operation started
sym0:		SCSI BUS reset detected
sym0:		SCSI BUS has been reset
sym0:0:0:	BUS RESET operation complete
sym0:0:0:	ABORT operation started
sym0:0:0:	ABORT operation timed-out
sym0:0:0:	HOST RESET operation started
sym0:		SCSI BUS has been reset

>From here on, the system is "hung" (it will respond to ctrl,alt,del but no more activity takes place.  There are 2 other drives on this adapter (same channel), nothing on the other channel. I've been patient enough to let it sit for up to 10 minutes and nothing more happens.

I don't know if any of this will help, but this is the way it behaved both before and after the patch you pointed me to yesterday.

Again, thanks for your help ...

Smitty
Hibbard T. Smith, JR
smitty@essnjay.com

-----Original Message-----
From: willy@www.linux.org.uk [mailto:willy@www.linux.org.uk]On Behalf Of
Matthew Wilcox
Sent: Thursday, June 17, 2004 2:36 PM
To: Smith, Hibbard
Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; matthew@wil.cx
Subject: Re: 53c8xx_2 driver for SymBios SCSI adapters


On Thu, Jun 17, 2004 at 12:05:51PM -0400, Smith, Hibbard wrote:
> I apologize if you feel my message was incorrect or inappropriate.
> I posted this problem to this list at the end of May and got no response
> whatsoever.

Guess I missed it.  Sorry.

> I took the liberty of writing directly to you at matthew@wil.cx
> and that was returned by some server along the way as undeliverable.
> My email setup is not broken.

It's entirely possible that it's broken or blacklisted.  If you can send
the bounce to my debian.org address, I'll take a look at it for you.

> When I searched this list's archive at
> google with the search term "53c"  the only things I found posted by
> you were in April and July of 2003.

Umm.  I've definitely posted patches more recently than that.

http://www.uwsg.iu.edu/hypermail/linux/kernel/0310.1/1123.html is from
last October.  I can't find the 2.1.18j patch posted anywhere, but it
went in at 2.6.5.

> However, back to the real issue.  Is there anything I can do to
> increase the verbosity of the driver to get more information about
> what's happening?  I would be happy to build a kernel in order to obtain
> more detail.  Since the kernel never really gets up and running, I'll
> have to transcribe the output and mail it to you.

Can you try
http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/gnupatch@40cf3658X57h5m24maf1efBL-aVHPw

I suspect it will cure the problem.

> 
> Hibbard T. Smith, JR
> smitty@essnjay.com
> 
> -----Original Message-----
> From: willy@www.linux.org.uk [mailto:willy@www.linux.org.uk]On Behalf Of
> Matthew Wilcox
> Sent: Thursday, June 17, 2004 11:45 AM
> To: Smith, Hibbard
> Cc: linux-scsi@vger.kernel.org; matthew@wil.cx
> Subject: Re: 53c8xx_2 driver for SymBios SCSI adapters
> 
> 
> On Thu, Jun 17, 2004 at 11:31:42AM -0400, Smith, Hibbard wrote:
> > Is anyone actually maintaining or working on this driver??
> 
> Er, yes.
> 
> > Somewhere between 2.4.26 and 2.6.5 it got broken.  It's still broken
> > in 2.6.6 and 2.6.7 rc2.  The MAINTAINERs file lists the maintainer as
> > Matthew Wilcox (email matthew@wil.cx).  Emails to that address bounce.
> 
> Why do they bounce?  I suspect you have a broken mail setup.
> 
> > Articles to this list get no response from anyone.  The last posting
> > in this list from Matthew (that I can find) is back in 2003.  I have
> > previously posted to this list about this problem.
> 
> I suggest you try harder then.  I've posted several times in the last week.
> 
> > The bug has been reported in this mailing list which, apparently, is the
> > only way to communicate with the developer listed in the MAINTAINERS file.
> > The bug has also been reported a couple of times in the Fedora Bugzilla
> > for core 2.
> 
> I don't go round reading random distro bugzillas.
> 
> > When the kernel is initializing, the driver recognizes the SymBios
> > 53c1010-33 chips on the motherboard, goes through several initialization
> > messages and then begins domain validation.  At this point, everything
> > hangs for awhile, then aborts and starts a cycle of SCSI bus resets from
> > which it never recovers.  The system then hangs for up to a half hour.
> > That's the longest I've let it sit.  I'm sure it's gone for good.
> 
> I had a report of this last week.  I was travelling so didn't have time
> to deal with it yet.
> 
> > I would be happy to attempt to get more information, if someone could
> > tell me how to get more verbosity from the driver.  The 53c8xx_2.txt
> > file in the Documentation/scsi directory is very old and out of date,
> > and the driver options it talks about appear to no longer work.
> 
> I have been updating it.  Send a patch.
> 
> -- 
> "Next the statesmen will invent cheap lies, putting the blame upon 
> the nation that is attacked, and every man will be glad of those
> conscience-soothing falsities, and will diligently study them, and refuse
> to examine any refutations of them; and thus he will by and by convince 
> himself that the war is just, and will thank God for the better sleep 
> he enjoys after this process of grotesque self-deception." -- Mark Twain
> 
> 
> 
> 

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain


