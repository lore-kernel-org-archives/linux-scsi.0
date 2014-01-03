From: =?UTF-8?B?SmnFmcOtIFBpbmthdmE=?= <j-pi@seznam.cz>
Subject: Re: [PATCH] scsi-sg: pass flag to inhibit setting LUN
Date: Fri, 03 Jan 2014 21:47:29 +0100
Message-ID: <52C721E1.7020002@seznam.cz>
References: <52C56755.7060709@seznam.cz> <yq1ha9kzui9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:60519 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaACVAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jan 2014 16:00:39 -0500
In-Reply-To: <yq1ha9kzui9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com

Dne 3.1.2014 21:21, Martin K. Petersen napsal(a):
>>>>>> "Ji=C5=99=C3=AD" =3D=3D Ji=C5=99=C3=AD Pinkava <j-pi@seznam.cz> =
writes:
> Ji=C5=99=C3=AD> This patch implements support for inhibiting setting =
LUN number
> Ji=C5=99=C3=AD> for SCSI custom command send via /dev/sgX with ioctl(=
=2E., SG_IO,
> Ji=C5=99=C3=AD> ...) call.
>
> Is it an absolute requirement that this is a per-command option or co=
uld
> we have a scsi_device quirk flag so we didn't have to plumb this thro=
ugh
> the entire I/O stack?
>
It should be enough to limit it to open file descriptor or sg subsystem=
=2E

This magic is expected to happen every time device is accessed
trough sg subsystem, but not if it is accessed other way
(eg. it is still some kind of common disk).

My understanding is that sg subsystem allows generic access to device,
in extreme case I might want to send command to LUN which is not the
active one.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
