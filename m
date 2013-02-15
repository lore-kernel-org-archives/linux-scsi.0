From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Fri, 15 Feb 2013 08:26:31 +0100
Message-ID: <511DE327.4050008@suse.de>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike> <511D26B4.6070302@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net> <511D68CA.6050203@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935388Ab3BOH0c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 02:26:32 -0500
In-Reply-To: <511D68CA.6050203@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/14/2013 11:44 PM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 2/14/2013 4:04 PM, Elliott, Robert (Server Storage) wrote:
>> Like James notes, LUNs should generally be treated as opaque values.
>
> 	Maybe another issue to consider is how they are being displayed in u=
serland.
> A device with two luns using one of the alternative lun addressing me=
thods is
> going to get some pretty strange looking lun numbers showing up in us=
erspace
> if they aren't decoded properly.
>
No. LUNs with anything other than peripheral addressing do look=20
weird even nowadays.
Cf IBM DS8000 presents me with LUNs like:

# lsscsi
[0:0:0:49409]wlun    IBM      2107900          .107  -
[0:0:0:1085358099]disk    IBM      2107900          .107  /dev/sda

where the second maps to LUN 401340b100000000.

Again, the initiator _must not_ attempt to decode the LUN.
To stick with the above example, LUN 400040b100000000 and LUN
40b1000000000000 do refer to the same LUN number, albeit on a=20
different Level. And it's totally up to the target which physical=20
LUN these numbers refer to. The initiator has to map these numbers=20
to different devices; to figure out whether the devices are=20
identical one would have to look at VPD page 0x83.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
