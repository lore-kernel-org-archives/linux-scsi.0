From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Fri, 01 Oct 2004 09:11:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415D0310.6020308@suse.de>
References: <Pine.LNX.4.44L0.0409301411240.1060-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:31629 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S269717AbUJAHL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 03:11:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409301411240.1060-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Alan Stern wrote:
> On Thu, 30 Sep 2004, Hannes Reinecke wrote:
>=20
>=20
>>Ok, since this is essential the same thread then on linux-scsi
>>(cf. "Bug: CD driver sends commands during host removal") the same=20
>>solution applies here also.
>>
>>Alan, I did a different patch which omit the special case handling in
>>scsiglue.c and rather reorders usb_stor_control_thread. I'd prefer mi=
ne=20
>>(naturally), but any of those will do.
>>And yes, both patches fix the problem.
>>
>>Back to the maintainer for patch inclusion.
>>
>>Cheers,
>>
>>Hannes
>=20
>=20
> No, your patch is incorrect.  In fact, it resembles the way the drive=
r=20
> used to work -- which caused an occasional oops.  The problem is that=
 by=20
> the time the usb_stor_control_thread() wakes up and sees that it has =
a new=20
> command to process, the SCSI core may already have deallocated the=20
> scsi_cmnd structure.  So the line where you assign to us->srb->result=
 is=20
> liable to raise an addressing exception.
>=20
> Alan Stern
>=20
Ok. (I knew there was something subtle going on).
What about the check for disconnecting later in=20
usb.c:usb_stor_control_thread?
It will only trigger if usb_stor_control_thread has been awakened by=20
some other command and the device has been disconnected between=20
awakening and executing this check.
(This may well be impossible to trigger, but the set_bit() in=20
storage_disconnect() appears not to be protected by any lock).
And I doubt it will work properly in that case as no scsi_done is not=20
called nor a proper status is set.
Is this check still needed or can it be removed?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
