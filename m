From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: 28 Oct 2003 13:56:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067374593.7040.84.camel@patehci2>
References: <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
	 <1067355523.6623.6.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:36841 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261740AbTJ1U4h
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:56:37 -0500
In-Reply-To: <1067355523.6623.6.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

> > ... not clear to me what is the best way to take care of the devices that 
> > choke on page 3F ...
> Some of us have suggested substituting:
> -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C // Mode Sense 10 of SBC/MMC
> Page x08 Cacheing for 8 byte header, optional 8 byte block descriptor,
> and xC byte standard page x08 length

>From a contemporaneous thread:

  - Host requests MODE_SENSE_10 and request 28 bytes
  - But the device only has 20 bytes, so it

Translating, we see that the terms 20 28 here mean what more bus traces
show as x14 x1C.  That again suggests talk-like-Windows might be:

-y "5A 00 08:00:00:00 00 00:1C 00" -i x1C

Those devices that only agree to copy in x14 = 20 bytes may be omitting
the optional 8 byte block descriptor, in accord with what I think I
remember MMC requires, though simultaneously in discord with what I'm
almost sure I remember SBC recommends.

Pat LaVarre


