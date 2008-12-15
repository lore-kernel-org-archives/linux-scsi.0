From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] sd: tell the user when a disk's capacity is adjusted
Date: Mon, 15 Dec 2008 16:48:36 +0100
Message-ID: <200812151648.37650.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0812151031290.2525-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:36147 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYLOPql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 10:46:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812151031290.2525-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Am Montag, 15. Dezember 2008 16:32:59 schrieb Alan Stern:
> +=A0=A0=A0=A0=A0=A0=A0 =A0 =A0(sdp->guess_capacity && (sdkp->capacity=
 & 0x01))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sd_printk(KERN_INFO, sd=
kp, "Adjusting the sector count "
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"from its reported value: %llu\n",

Maybe this is just me, but if the disk actually has an odd number of se=
ctors
this code will assume the disk is one sector too big. Therefore we shou=
ld
still learn about buggy enclosures and add them to the list, so we shou=
ld
make a difference between known buggy devices and cases the heuristics
works, particularly as it may mark a rare cases where a working device
is truncated. So KERN_INFO seems a bit weak.

	Regards
		Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
