From: Konstantin Khomoutov <flatworm@users.sourceforge.net>
Subject: Re: What happened to ncr53c8xx module in 2.6? (troubles with sym53c8xx in its place)
Date: Thu, 2 Mar 2006 03:04:29 +0300
Message-ID: <20060302000427.GA1610@proxysrv.domain007.com>
References: <20060226170411.GA300@proxysrv.domain007.com> <20060226190929.GV28587@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.007spb.ru ([212.113.108.55]:12718 "EHLO
	mailhub.007spb.ru") by vger.kernel.org with ESMTP id S1751418AbWCBH2C
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 02:28:02 -0500
Received: from localhost.localdomain ([192.168.4.3])
	by mailhub.007spb.ru (8.13.4/8.13.4/Debian-3) with ESMTP id k227RDTa032659
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 10:27:54 +0300
Received: from localhost.localdomain (localhost [127.0.0.1])
	by localhost.localdomain (8.13.4/8.13.4/Debian-3) with ESMTP id k2204T8N016227
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 03:04:29 +0300
Received: (from kostix@localhost)
	by localhost.localdomain (8.13.4/8.13.4/Submit) id k2204TXX016225
	for linux-scsi@vger.kernel.org; Thu, 2 Mar 2006 03:04:29 +0300
Content-Disposition: inline
In-Reply-To: <20060226190929.GV28587@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Feb 26, 2006 at 12:09:29PM -0700, Matthew Wilcox wrote:

[...]
>> The problem is that I have some pretty old SCSI scanner (HP ScanJet 4p)
>> that was distributed with its own ISA SCSI card (NCR53c400 based, BTW,
>> but with that card and its driver I had no luck at all, while under
>> Win98 that card works OK).
> Somebody should probably investigate that, but I don't really want to
> take on another scsi driver ...
Don't bother with it: to date I have no ISA-bus machines in stock so I
am even unable to test patches/send reports.

>> But sym53c8xx gives me this when I try to insert it while the attached
>> scanner is ON:
>> 
>> PCI: Found IRQ 9 for device 0000:02:09.0
>> sym0: <810> rev 0x1 at pci 0000:02:09.0 irq 9
>> sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
>> CACHE TEST FAILED: timeout.
>> sym0: CACHE INCORRECTLY CONFIGURED.
>> sym0: giving up ...
>> 
>> The exactly same results I seen when I tried this driver under a 2.4
>> kernel.
> Are you saying that it works fine when the scanner isn't plugged in, or
> is turned off?
Here's what I get on "cold boot" (e.g. after that PC and the attached
scanner both stood turned off for more than 8 hours) when the scanner is
still being turned OFF:

PCI: Found IRQ 9 for device 0000:02:09.0
sym0: <810> rev 0x1 at pci 0000:02:09.0 irq 9
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.1

However, on "warm boot" (i.e. the scanner was turned on, I try to insert
the sym53c8xx module with no success, and then I turn off the scanner,
then reboot the PC) I get the *first* output pattern from the driver
most of the time.

Does it mean my SCSI card is going to die? Or the scanner? ;-)

Some more info: the scanner has two connectors: Centronics-50 and
Sub-D25 female, one auto-termination switch (set to ON since it's
the only device on wire), the SCSI card has micro D-60 connector.
The cable used is D-60<->Centronics-50 (since the original cable for
that scanner and its SCSI card was D25<->Centronics-50).

AFAIK, my SCSI card is SCSI-2 and my scanner is SCSI-1. I thought that
SCSI is "backwards compatible", may be I am wrong and they just cannot
coexist?

[...]
>> I've googled that this dumb scanner doesn't report parity and that
>> disappoints the sym53c8xx driver, but I failed to find an appropriate
>> option to turn parity checking off. Furthermore, I've also googled some
>> info that sym53c8xx just doesn't support 53c810 chips at all.
> I removed the option to disable parity checking.  Looks like I should
> reinstate it.  I have an 810 card here that works fine, so that
> information is out of date.
The SCSI card in subject was previously used to run a bunch of SCSI
disks out there, successfully, under Linux 2.4.x.

P.S.
May be there's some way to programmatically "spy" somehow on SCSI bus
for me to take some kind of dump?

Anyway, thanks for you help!

