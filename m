From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: Re: [PATCH] CDC_MMC_WR
Date: Sun, 12 Oct 2003 08:02:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031012150243.46969.qmail@web21103.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21103.mail.yahoo.com ([216.136.227.105]:20915 "HELO
	web21103.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263329AbTJLPCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Oct 2003 11:02:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: p.lavarre@ieee.org, linux-scsi@vger.kernel.org

Sorry I didn't dream this up earlier, but now, unless
redirected, next I will try a new & more creative
alternative, specifically ...

In four parts:

1) Unmask CDC_MMC_WR in ide-cd/sr by default.  !! Yes
by default !!

2) Mask CDC_MMC_WR in ide-cd/sr if op x1A/5A Mode
Sense of x2A Capabilities fails.

3) Try op x46 Get Configuration in cdrom, just before
register_cdrom succeeds, only if !CDC_DVD_RAM and also
CDC_MMC_WR was left unmasked by ide-cd/sr.  Mask
CDC_MMC_WR if op x46 fails and mask CDC_MMC_WR if op
x46 says profile not a standard writable profiles.

4) Change sr to refuse to pass thru writes only if
!CDC_MMC_WR.  Delete all mention of device->writeable.

By 1 2 3 we will try op x46 Get Configuration only
after the ide-cd/sr flavour of op x1A/5A Mode Sense
fails.

By 4, we preserve the behaviour of sr even when sr
runs without cdrom e.g. if register_cdrom fails.

Like it?  Me I'm delighted to see us disentangle
CDC_MMC_WR from the debates over whether to ask to
copy In x18 or x1C or x80 bytes of Data when mode
sensing page x2A Capabilities.

Pat LaVarre


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
