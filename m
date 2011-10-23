From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: SCSI HA problems
Date: Sat, 22 Oct 2011 19:26:09 -0500
Message-ID: <4EA35F21.4060104@hardwarefreak.com>
References: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu> <20111022105046.5ab4e3e9@galadriel.home>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:32849 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1JWAf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2011 20:35:58 -0400
In-Reply-To: <20111022105046.5ab4e3e9@galadriel.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Michael Robbert <mrobbert@mines.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/22/2011 3:50 AM, Emmanuel Florac wrote:
> Le Fri, 21 Oct 2011 18:08:37 -0600 vous =E9criviez:

>> So, my question is this, is this setup technically possible or are
>> the 2 HBAs going to conflict with each other when talking over the
>> same SAS bus to the SATA drives?
>=20
> Your explanation lacks important information, like the hardware in us=
e
> (controllers, jbods, drives, cabling, etc), kernel version, RAID ( is=
 it
> linux software RAID you're using?) etc. However:
>=20
> First, you shouldn't be using desktop drives because it's extremely
> dangerous (search the web and you'll find countless horror stories of
> catastrophic failures, particularly with WD desktop drives).

Agreed.  Particularly the "Green" drives from any manufacturer.  Keep i=
n
mind that when a "home brew" system of this nature takes a catastrophic
nose dive, you may spend a couple of days or more trying to hunt down
the problem and fix it.  And therein lies the rub:  cheap SATA drives
will drop en masse from arrays, inexplicably, and will test good in
isolation on the bench.  Now what?  The problem isn't the drives but th=
e
entire low cost architecture.  The only fix it to replace _everything_
if you want it to be reliable.  Or, fix it by avoiding such a thing in
the first place.  Use "enterprise" quality SAS or SATA drives from day
one, and use a good quality SAS controller, such as LSI.

> Second, normally for SAS HA configuration, you must use SAS drives; t=
he
> main difference being that SAS drives have dual attachment, and can
> manage commands coming from dual sources (controllers). SATA drives
> lack the second path and can't be reliably driven from 2 different
> controllers at once, unless you added a SAS to SATA adapter to them.
>=20
> Third, your SAS controller must be able to work in multi-host
> configuration. Most PCIe SAS controllers (3Ware, Adaptec, Areca,
> HighPoint) can't do that at all. AFAIK only some LSI controllers are
> multi-host aware, and this is a software option you must buy in
> addition to the controller.

You'll also want, if not outright need, an SAS switch, such as the LSI
SAS6160.  Runs about $2000 USD from resellers.  You'll also want a
quality JBOD chassis w/expander at about $2k each.

> Fourth, for a dual attachment you need to use both SAS data path to
> both hosts, which would quickly make clear you can't use SATA drives
> (because they'll simply won't show up at all on the second path).

Which is why hardware RAID enclosures and cluster filesystems and/or NF=
S
servers are much more popular than this type of shared SAS cluster.

> Fifth, if you're actually using linux md raid driver, I don't think
> it to be in any manner multi-host capable. So that would be a
> definitive dead end.

Yep.

> My advice : the only reliable way to achieve HA using SATA drives and
> common SAS controllers is to use DRDB or some similar replication
> mechanism. Yes, that means you'll need a second JBOD and twice the
> number of drives. But it will _just_ _work_, both with hardware or
> software RAID.

I see it as the only way to get away with using cheap SATA drives (whic=
h
I still wouldn't recommend).   If this is a lab exercise that's one
thing.  If this will be a production system, stay away from consumer
class drives.

> If necessary, you may need a pair of 10 Ge or IB cards for data
> synchronisation between hosts to perform well enough. Modern hardware
> can easily replicate over DRBD at several hundred MB per second.

The replication link bandwidth depends entirely on the target
application and expected filesystem bandwidth required, which the OP
didn't state IIRC.  That omission leads me to believe this is a researc=
h
project/exercise, with no actual goal to realize.

> Don't forget : "cheap, good, fast: choose two." In the case of large,
> important, valuable data, "good" isn't really an option you may go
> without anyway.

Good advice.

--=20
Stan


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
