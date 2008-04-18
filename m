From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
	enclosure
Date: Fri, 18 Apr 2008 09:29:05 -0500
Message-ID: <1208528945.3063.7.camel@localhost.localdomain>
References: <20080418124104.9ca87130.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55129 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYDRO3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 10:29:10 -0400
In-Reply-To: <20080418124104.9ca87130.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-04-18 at 12:41 +0200, Lars T=C3=A4uber wrote:
> As some of you might already now I have to set up a (for us) bigger S=
AN with Linux.
> I'm simulating disc failure right now. To find a defective disc in th=
e enclosure is unresolved yet.
> I already had a look at several web pages and searched for it but wit=
hout luck.
>=20
> The manual of the enclosure says (PROMISE VTRAK J610S):
> ---------------------------------------------------------------------=
--
> LEDs                                 State
>                 | Dark     | Steady Green  | Flashing Green
> Power/Activity* | No Drive | Drive Present | Activity
> Status**        | HBA/RAID controller determines the LED behavior
> [...]
> ** Refer to the user documentation for your HBA or RAID controller fo=
r this
>    information.
> ---------------------------------------------------------------------=
--
>=20
> Is there a standard way to lit the led in the enclosure with linux me=
ans or anything alike?
> The enclosure does not tell the serial numbers of the included disc.
> The HBA is an LSI SAS 3801X.

It depends on whether you have the HBA configured in RAID mode or not.
If you have, then it takes absolute control of the enclosure management
at the moment and I don't think you can get to it.

If you run the HBA as a pure SAS one, then the promise website says thi=
s
enclosure is ses2 compliant, so you should just be able to insert the
ses module and have enclosure management (2.6.24+ kernels).  This relie=
s
on the HBA exposing the enclosure device, but I think mptsas only eats
it for RAID configurations.

to see what's in the enclosure, just do

ls /sys/class/enclosure/*/

each of the subdirectories has a slot label (name taken from SES) to
locate the enclosure, just echo 1 to the locate file and it will flash
the lights.  If it has a disk, there should be a device link in the slo=
t
directory (might not be, this depends on ses working correctly and VPD
inquiries identifying the right disk).

James




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
