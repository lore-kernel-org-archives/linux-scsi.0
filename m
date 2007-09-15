From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 17:27:24 +0200
Message-ID: <46EBF9DC.1000503@s5r6.in-berlin.de>
References: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de> <20070915135314.GS3563@stusta.de> <46EBE821.2080300@s5r6.in-berlin.de> <20070915144341.GT3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42922 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXIOP20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 11:28:26 -0400
In-Reply-To: <20070915144341.GT3563@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Sep 15, 2007 at 04:11:45PM +0200, Stefan Richter wrote:
>> Perfect is in the eye of the beholder.  You would consequently have to
>> add such options into all menus which contain scsi low-level providers.
> 
> Kconfig is a user interface, so perfect is what is best for the
> kconfig users.

Duplicate options with different names in different menus, but which all
do the same, --- is this the best for users?

>> Also, one more question on whether CONFIG_SCSI ought to be 'select'ed:
>> Where do scsi-core options like CONFIG_SCSI_CONSTANTS go?
> 
> The first question is whether it's for actual SCSI hardware [1] or for 
> the block layer functionality which the SCSI subsystem has become.
> The mixture of these two is the root of much user confusion.
> 
> With the help text "The error messages regarding your SCSI hardware will 
> be easier to understand if you say Y here" a user wouldn't have expected 
> to see you using it in a firewire driver.

FireWire hardware which implements SBP-2 is SCSI hardware...  But this
detail aside --- yes, of course this help text is old and misleading.

> But unless I miss anything, 
> the setting of SCSI_SCAN_ASYNC does only affect "real" SCSI hardware.

It affects every hardware which is driven by scsi low-level providers
which have been integrated with the SCSI_SCAN_ASYNC facility.

> If you check each option and place it either in the generic storage menu 
> or the SCSI lowlevel menu this would fix much possible user confusion.
> 
> But these are relatively unimportant options compared to e.g.
> USB_STORAGE=y, BLK_DEV_SD=n, which is a misconfiguration many
> users run into, so having one menu somewhere with these advanced 
> options should be enough.

True.

So,
    config SCSI_CONSTANTS
        "Kernel log messages from the SCSI subsystem will be easier to
        understand if you say Y here..."
would say what this option really does.  But to some degree the need to
explain what the SCSI subsystem or SCSI core is and which other
subsystems make use of it remains.  Maybe it's OK to provide
documentation of this kind outside of Kconfig help though.

> [1] SCSI as in "sold as SCSI"

Difficult.  Does e.g. hardware sold as SAS count as "sold as SCSI"?  How
about SBP-2 then?  ;-)
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
