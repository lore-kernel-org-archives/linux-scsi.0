From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] scsi/Kconfig tidyup
Date: Wed, 11 Feb 2004 20:14:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211201432.GT13351@parcelfarce.linux.theplanet.co.uk>
References: <20040211194600.GS13351@parcelfarce.linux.theplanet.co.uk> <20040211195109.A23991@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7647 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266101AbUBKUOd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 15:14:33 -0500
Content-Disposition: inline
In-Reply-To: <20040211195109.A23991@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Wed, Feb 11, 2004 at 07:51:09PM +0000, Christoph Hellwig wrote:
> On Wed, Feb 11, 2004 at 07:46:00PM +0000, Matthew Wilcox wrote:
> > 
> > This patch corrects a couple of typos in drivers/scsi/Kconfig and
> > makes the SCSI drivers menu depend on SCSI rather than on SCSI!=n.
> > That has the effect of making every driver depend on SCSI, so we don't
> > need the explicit dependency for every driver.
> 
> I'd rather kill that menu then actively using it for depencies..

I'm not sure that's a great idea.  Looking in menuconfig, there's already
14 lines in the generic SCSI menu.  Merging the drivers into the same menu
would add another 56 lines into that menu.  Feels a little big to me.

Unless you were proposing something like:

   --- SCSI device support
    [*]   legacy /proc/scsi/ support
    ---   SCSI support type (disk, tape, CD-ROM)
    <*>   SCSI disk support
    < >   SCSI tape support
    < >   SCSI OnStream SC-x0 tape support
    <*>   SCSI CDROM support
    [ ]     Enable vendor-specific extensions (for SCSI CDROM)
    <*>   SCSI generic support
    ---   Some SCSI devices (e.g. CD jukebox) support multiple LUNs
    [*]   Probe all LUNs on each SCSI device
    [ ]   Build with SCSI REPORT LUNS support
    [ ]   Verbose SCSI error reporting (kernel size +=12K)
    [ ]   SCSI logging facility
          Adaptec drivers  --->
          NCR/Symbios/LSI drivers  --->
          Qlogic drivers  --->
          Other drivers  --->

But I don't think you are.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
