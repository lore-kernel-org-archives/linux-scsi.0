From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: EISA 53c825 - where to start?
Date: Tue, 16 Nov 2004 13:29:01 +0000
Message-ID: <20041116132901.GH26623@parcelfarce.linux.theplanet.co.uk>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3307 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261733AbUKPN3C
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 08:29:02 -0500
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Nov 16, 2004 at 11:12:20AM +0200, Meelis Roos wrote:
> I have a Compaq Proliant 4500 with onboard EISA-connected NCR 53c825 
> SCSI adapter. There is no EISA-aware version for this chip in Linux 
> AFAIK so I want to make one. EISA API is there, also several NCR/Sym/LSI 
> SCSI drivers. Which driver is the best to base the eisa work on? And 
> where should I start? :)

As you note, we have several drivers for NCR/Symbios/LSI chips.  Here's
a taxonomy:

53c700		Handles 700 chips and 710 chips in 700 compat mode
lasi700		Used with 53c700 for 700/710 chips in PA-RISC workstations
NCR_D700	Used with 53c700 for 700 chips on an MCA bus
sim710		Used with 53c700 for 700/710 chips on MCA or EISA bus

53c7xx		Handles 710 chips on m68k
amiga7xx	Used with 53c7xx for Amigas
bvme6000	Used with 53c7xx for an m68k-based VME machine
mvme16x		Used with 53c7xx for an m68k-based VME machine

ncr53c8xx	Handles 720 chips, should be extended to handle 770 chips too
NCR_Q720	Used with ncr53c8xx for 720 chips on an MCA bus
zalon		Used with ncr53c8xx for 720 chips on PA-RISC machines

sym53c8xx_2	Drives 8xx and 1010 PCI chips

The 5380, 53c9x, 53c416 and 53c500 are unrelated chips.

(it'd probably be a good idea to put this summary somewhere in the kernel tree)

I think your best bet would be to add EISA support to the sym2 driver.
This may turn into a lot of restructuring, so do feel free to ping me
frequently with questions about how I'd like to see things work.

The only other reasonable alternatives are to start a new driver (blech)
or adapt ncr53c8xx to handle EISA 825 ... and I think that's more work,
as well as being not where we want the ncr family to end up.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
