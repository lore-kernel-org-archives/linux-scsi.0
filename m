From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: 28 Oct 2003 08:38:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067355523.6623.6.camel@patehci2>
References: <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:29120 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263999AbTJ1Pis
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:38:48 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

> ... not clear to me what is the best way to take care of the devices that 
> choke on page 3F.  Should we use a special flag for those devices or 
> should we disable it entirely?

Some of us have suggested substituting:

-y "5A 00 08:00:00:00 00 00:1C 00" -i x1C // Mode Sense 10 of SBC/MMC
Page x08 Cacheing for 8 byte header, optional 8 byte block descriptor,
and xC byte standard page x08 length

Lately that suggestion appeared in talk re discovering Win protocol that
paused near:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106427309605764
Subject:  usb storage traces
Date:     2003-09-22 23:25:17

That talk included my claim:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106331377632562
Subject:  Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date:     2003-09-11 20:42:33
...
I have some reason to believe Windows often passes thru something like:
-x "1A 00 08 00 18 00" -i x18
i.e. a ModeSense6 of Cacheing page x08 for the whole 4 byte header plus
one whole 8 byte block descriptor plus the whole xC byte standard page.
...

Pat LaVarre


