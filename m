From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: Re: [PATCH] CDC_MMC_WR
Date: Sun, 12 Oct 2003 12:19:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031012191947.62546.qmail@web21102.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21102.mail.yahoo.com ([216.136.227.104]:44065 "HELO
	web21102.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263510AbTJLTTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Oct 2003 15:19:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: p.lavarre@ieee.org, linux-scsi@vger.kernel.org

[[[ Ouch I see my English was poor: often I wrote the
wrong number of not's when speaking of bits not
unmasked.  In case I was therefore not comprehensible,
I will now try again to express myself correctly.  Or
maybe you'd rather wait for the code. ]]]

Sorry I didn't dream this up earlier, but now, unless
redirected, next I will try a new & more creative
alternative, specifically ...

In four parts:

1) Patch ide-cd/sr to unmask CDC_MMC_WR by default. 
!! Yes by default !!

2) Except patch ide-cd/sr to mask CDC_MMC_WR if op
x1A/5A Mode Sense of x2A Capabilities fails.

3) Patch cdrom to try op x46 Get Configuration, just
before register_cdrom succeeds, only if ide-cd/sr left
CDC_MMC_WR unmasked and also left CDC_DVD_RAM masked. 
Afterwards, mask CDC_MMC_WR if op x46 fails, also mask
CDC_MMC_WR if op x46 fetches any profile other than a
standard writable profile.

4) Change sr to refuse to pass thru writes unless
CDC_MMC_WR is unmasked.  Delete all mention of
device->writeable.

In conclusion I hope:

By 1 2 3 we will try op x46 Get Configuration only
if and after the ide-cd/sr flavour of op x1A/5A Mode
Sense succeeds.

By 4, we will preserve the legacy 2.6.0-test7
behaviour of sr even when sr runs without cdrom e.g.
if register_cdrom fails.

Like this idea?

Me I'm delighted to see us disentangle CDC_MMC_WR from
the debates over whether ide-cd, sr, and/or cdrom mode
senses page x2A Capabilities and which of these asks
to copy In x18 or x1C or x80 bytes of Data.

Pat LaVarre



__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
