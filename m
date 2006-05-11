From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Thu, 11 May 2006 12:39:04 +0200
Message-ID: <44631448.2010508@suse.de>
References: <4461EFD0.50902@suse.de>  <446217D5.3020606@torque.net> <1147279812.3671.8.camel@mulgrave.il.steeleye.com> <44622619.4020805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:52613 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030220AbWEKKjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 06:39:13 -0400
In-Reply-To: <44622619.4020805@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> James Bottomley wrote:
>> On Wed, 2006-05-10 at 12:41 -0400, Douglas Gilbert wrote:
>>
>>> Looks good. There is no proposed change to sg.c .
>>> Could SG_FLAG_FAILFAST be made to work via sg device
>>> nodes?
>>
>> Rather than having to maintain two separate paths for SG_IO and henc=
e
>> keep running into this issue, what will it take for sg to use the bl=
ock
>> scsi_ioctl.c?
>=20
> Methinks a large amount of code and a lot of testing.
> Hannes is proposing a new SG_FLAG value that would
> only be active in the block layer SG_IO. The existing
> SG_FLAG values are only implemented by the sg driver.
> Around that level in the sg driver, the command
> injection and response processing are asynchronous
> and that can be exposed to the sg user. The block
> SG_IO is synchronous with no easy way to break
> it down to its component parts.
>=20
> On further thought if anything in the scsi midlayer
> (or the block layer) is slowing down an error report
> getting back to a sg user then that is most likely a
> bug. The sg driver sends commands with retries set to
> zero. Also settings in the read/write error recovery
> mode page can effect how long a disk (or cd/drive)
> spends trying to recovery from errors (and
> SG_FLAG_FASTFAIL has no effect at the device (lu)
> end).
That doesn't apply here. The error recovery in scsi_unjam_host() will b=
e
triggered regardless of the retry setting. Setting the retry to zero
will only cause the command _not_ to be retried; if the device still
reports an error condition the error handler will still be invoked.

One might argue that no error recovery is required for sg.c commands as
the user will have full control (up to and including bus / device reset=
)
so he's responsible to implement his own error recovery. In that case w=
e
should always send command from sg.c down with the failfast flag set.

But that's a different discussion.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
