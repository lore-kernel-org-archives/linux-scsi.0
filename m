From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx parity errors on SuSE 9.1's hwscan?
Date: Thu, 23 Sep 2004 03:39:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040923023914.GV16153@parcelfarce.linux.theplanet.co.uk>
References: <m3y8j1q4gs.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17108 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268146AbUIWCjP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 22:39:15 -0400
Content-Disposition: inline
In-Reply-To: <m3y8j1q4gs.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Thu, Sep 23, 2004 at 01:16:51AM +0200, Matthias Andree wrote:
> SuSE Linux 9.1 (kernel 2.6.5 + SuSE patch set, but also 2.6.7 or a bit
> milder in 2.6.9-rc2-mm1) uses some SuSE-specific "hwprobe" or "hwinfo"
> tool to scan for hardware.

Does anyone have the source?  I'd be interested to see what it's up to.

> I find it a bit intimidating that user-space (albeit with root
> permissions) causes "SCSI" parity errors, and given the 2.6.9 logging
> towards the end of the mail, I am wondering if SuSE's hwinfo stuff
> triggers some race condition or manages to bypass the SCSI phase state
> machine or if the probe confuses the chip. I haven't yet managed to
> isolate (with strace) the cause.

I have a suggestion.  If the probe attempts to size the BARs of the
chip, this is a destructive process that could well cause the chip to
start spewing errors are require a reset to work again.

> Is there a useful debug setting for sym53c8xx that could shed some light
> on what the user-space has attempted that led to the SCSI parity error?

The trouble is that I suspect the probe is completely bypassing the driver.
It might be worth instrumenting drivers/pci/proc.c to see if it's writing
to any of the BARs (particularly the second memory BAR, the one that's 8k).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
