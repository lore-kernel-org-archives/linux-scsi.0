From: David Caldwell <david@porkrind.org>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA passthrough CDBs
Date: Thu, 22 Dec 2005 20:22:38 +0000 (UTC)
Message-ID: <loom.20051222T210436-336@post.gmane.org>
References: <20051221122442.GA16571@porkrind.org> <43AA70B4.2050509@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:63198 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S1030322AbVLVVKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 16:10:21 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1EpXhb-0003f2-Ra
	for linux-scsi@vger.kernel.org; Thu, 22 Dec 2005 22:10:20 +0100
Received: from cpe-67-49-94-99.socal.res.rr.com ([67.49.94.99])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2005 22:10:19 +0100
Received: from david by cpe-67-49-94-99.socal.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2005 22:10:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

thomas schorpp <t.schorpp <at> gmx.de> writes:

> 
> David Caldwell wrote:
> > This patch does 2 things. It reimplements the SG_FLAG_LUN_INHIBIT flag
> > in the SG_IO ioctl which stops the scsi subsystem from overwriting the
> > 2nd byte of the CDB with the LUN. It also doesn't guess the CDB length
> > when sending the SG_IO ioctl to the sg device (the main scsi_ioctl
> > already did this).
> > 
> > This is for the Cypress CY7C68310 USB to ATA bridge chip (and most
> > likely other USB to ATA chips from Cypress), which implements an ATA
> > passthrough command that is 16 bytes long and starts with the bytes
> > 0x24 0x24. (Not vendor unique, weird length for opcode 0x24, and
> > misuse of the LUN area all at the same time--Lovely).
> 
> thx, hm, that chip is that old that datasheet is available no more...

Yeah, the chip I tested with was a CY7C68310, but the datasheet I used
was the B rev, I think:
<http://www.cypress.com/portal/server.pt?space=CommunityPage&control=SetCommunity&CommunityID=209&PageID=259&fid=14&rpn=CY7C68301B>

Actually, the chip was labelled CY7C68310-80AC, but I couldn't tell if
those last 4 digits were a version or just a datecode.

> i test it as soon as i get my 68300A changed with the new -B- type
> back from lab.

Cool.

> anyway, i see the first ATACB enabled (guaranteed) announced chip
> should be the 683xxB types. maybe they have the correct behaviour
> (16Bytes, opccode length problem), so maybe the last part of above
> functionality could interfere.

It shoudn't interfere, but it could be redundant. The length mod
requires that the user set the correct CDB length in the SG_IO
ioctl, which is how it was documented anyway. It is also how the sd
and st drivers interpret the ioctl, so now at least that part is
consistent between drivers. It would be better if they shared the
code, though.

I kind of doubt they've fixed their interface since I remember seeing
the "24 24" opcode (as described in the B datasheet) being used on
some Cypress chips at work 2 or 3 years ago, so it makes me think
they've been consistent.

An interesting note: the datasheet mentions that the 1st byte of the
cdb comes from the EEPROM which means that when a board maker programs
the chip they *could* pick a reasonable opcode (though the 2nd byte is
still *required* to be 0x24, so the LUN issue still stands).

-David


