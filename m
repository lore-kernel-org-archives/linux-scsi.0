From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH/RFC] scsi LLD alpha ordering
Date: Sun, 27 Jun 2004 23:26:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040627222637.GJ30334@parcelfarce.linux.theplanet.co.uk>
References: <20040627124106.0bcdf020.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33751 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264503AbUF0W0i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2004 18:26:38 -0400
Content-Disposition: inline
In-Reply-To: <20040627124106.0bcdf020.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: scsi <linux-scsi@vger.kernel.org>

On Sun, Jun 27, 2004 at 12:41:06PM -0700, Randy.Dunlap wrote:
> 1.  Puts SCSI drivers in more alpha order, but not totally,
> because some of the platform-specific drivers are still grouped
> together.
> 2.  scsi/arm/Kconfig used a comment:
>   "The following drivers are not fully supported"
> This patch adds an ending comment:
>   "End of drivers not fully supported"
> so that someone reading the menu can know the end of the
> unsupported drivers list.
> 3.  Adds a "Platform/Machine-specific drivers" comment before
> the platform-specific drivers are lsited.

Well, you made a mistake with (3) -- The SCSI_LASI700 driver (depends
on GSC) is platform specific.

More generally, I don't think we have any kind of consensus on how
to organise this menu.  I'd like to see it organised by manufacturer
(Adaptec, NCR/Symbios/LSI, Qlogic, etc), but I know not everyone agrees.
Possibly the categories should be FC, parallel SCSI, serial ATA and then
alphabetically within those categories.

I also don't think that the Transport Attributes menu needs to be
alphabetical.  I'd be amazed if anyone actually used it.  Come to think
of it, why are these user-selectable?  Surely they should be _only_
implied by the drivers that use them?  If we do need to keep it, I think
the question needs to be rephrased -- Parallel SCSI sounds like SCSI
devices attached to the parallel port (eg Iomega ZIP).  Maybe "Normal
SCSI Transport Attributes" or "Regular" or "Legacy" or "Antique" would
be better ;-)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
