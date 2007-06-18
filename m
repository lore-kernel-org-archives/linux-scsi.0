From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Mon, 18 Jun 2007 10:47:28 +0200
Message-ID: <467646A0.3070105@suse.de>
References: <200705291529.54785.swen@vnet.ibm.com> <1182113412.19498.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:55801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXFRIre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 04:47:34 -0400
In-Reply-To: <1182113412.19498.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

James Bottomley wrote:
> On Tue, 2007-05-29 at 15:29 +0200, Swen Schillig wrote:=20
>> From: Christof Schmitt <schmichr@de.ibm.com>
>>
>> zfcp reported units to the SCSI stack starting
>> with number 0. LUN 0 reported to the SCSI stack is usually=20
>> not the FCP LUN 0. When scanning for devices,=20
>> the SCSI stack tried to issue a REPORT LUN command to LUN 0.=20
>> The current design for zfcp does not want the SCSI stack to scan
>> for devices, since they are configured explicitly via sysfs.
>> This patch changes the numbering to always start with LUN 1 and ther=
efore
>> prevent the SCSI stack sending REPORT LUN command.
>=20
> As a general principle, this does sound to be wrong (at least shiftin=
g
> the LUNs).  Wouldn't something like the existing blacklist preventing
> the REPORT LUN command from being sent be more appropriate?
>=20
IMO the zfcp driver should export the FCP LUNs and not building their
own internal SCSI LUN to FCP LUN mapping table.
That would avoid this issue, too. And would make the zfcp driver more i=
n
line with everyone else ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
