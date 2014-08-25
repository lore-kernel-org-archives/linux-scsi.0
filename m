From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Mon, 25 Aug 2014 12:39:07 -0700
Message-ID: <1408995547.3629.7.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1408251037370.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45045 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933108AbaHYTjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 15:39:09 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408251037370.1385-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 2014-08-25 at 10:44 -0400, Alan Stern wrote:

> James, can you explain how the INQUIRY command in scsi_probe_lun()  
> managed to work back in the days when multi-lun SCSI-2 devices were
> common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
> initially contains 0, so the LUN bits won't get filled in when the
> first INQUIRY command is sent.  Then how could the target know which
> logical unit the INQUIRY was meant for?

Best guess, some patches over the course of time altered the way we do
this and no-one noticed.  I think it was probably the introduction of
the unknown SCSI data level that caused the breakage.

Historically, the LUN in CMD bits is left over from SCSI-1; it was
incorporated into SCSI-2 for backward compatibility (even though SCSI-2
moved the LUN specification to the identify message).  In SCSI-3 and
beyond, those bits were obsoleted and transports took sole
responsibility for LUN handling.  I'm fairly certain all the SCSI-1
devices relying on this behaviour have long ago migrated to the great
data centre in the sky.

Alan's fix looks reasonable because we probe LUN 0 first (for SCSI-1 and
2 which has parallel scanning), which is why it doesn't matter (the bits
are set to zero) and once we have LUN 0 we propagate the data to the
target and make it the basis for future checks.  I'd like to see a
comment explaining this in the code, though ...
James


