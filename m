From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sun, 27 Apr 2003 04:29:10 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304270229.h3R2TAg06941.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:38580 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263285AbTD0CRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 22:17:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

Matt asks:

> Why not just make us_10_for_ms default to 1, just like use_10_for_rw?
> The same logic (fallback if ILLEGAL_REQUEST) could apply to both.

Yes, probably that is OK.
I wanted to rewrite code without changing behaviour, and have no
opinion about how non-USB devices might react to 10-byte MODE_SENSE.


James advises:

# Well, this should be done in the USB storage slave_configure

Ah, of course.
All docs say that this routine should call scsi_adjust_queue_depth.
Is that really true? When reading the docs one gets the impression
that our code is
	if (slave_configure)
		slave_configure();
	else
		scsi_adjust_queue_depth(default);
But I read in scsi_scan.c:
        if(sdev->host->hostt->slave_configure)
                sdev->host->hostt->slave_configure(sdev);

Andries
