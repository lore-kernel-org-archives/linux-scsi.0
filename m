From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Mon, 9 Feb 2004 17:11:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Feb9.171120est.332381@cyborg.cybernetics.com>
References: <Pine.LNX.4.44L0.0402091317290.1821-100000@ida.rowland.org>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:28680 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S265251AbUBIWL0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 17:11:26 -0500
In-Reply-To: <Pine.LNX.4.44L0.0402091317290.1821-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Stern' <stern@rowland.harvard.edu>, 'James Bottomley' <James.Bottomley@steeleye.com>
Cc: 'Matthew Dharm' <mdharm-scsi@one-eyed-alien.net>, 'Joerg Schilling' <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, 'USB development list' <linux-usb-devel@lists.sourceforge.net>, 'SCSI development list' <linux-scsi@vger.kernel.org>

> Especially if the sense code is NO SENSE.  Logically that should
> indicate the driver needed to find out whether or not there was error,
> and it learned that there wasn't.

For tape drives, sense key == NO SENSE is not equivalent to no error to
report.  Often a tape drive returns a sense key of NO SENSE but with one
of the other bits (EOM, FILEMARK, ILI) set in the same byte as the sense
key.  There are also some ASC/ASCQ combinations that go with a sense key
of NO SENSE but without any of the EOM, FILEMARK, or ILI bits set.

On the other hand, some tape drives set the EOM bit in unsolicited
request sense data just to report the position of the tape, so the EOM
bit being set isn't necessarily an indicator that there was an error.
However, ASC/ASCQ should be nonzero when the EOM bit is set because of
an error.

I recommend defining "no error" to be:

(sense_data[2] & 0xaf) == 0x00 && /* Filemark 0, ignore EOM, ILI 0, NO
SENSE */
sense_data[12]  == 0x00 && /* ASC */
sense_data[13] == 0x00 /* ASCQ */

This should work for most devices that I have encountered.

Anthony J. Battersby
Cybernetics

