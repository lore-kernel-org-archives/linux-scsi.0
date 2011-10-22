From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: SCSI HA problems
Date: Sat, 22 Oct 2011 10:50:46 +0200
Message-ID: <20111022105046.5ab4e3e9@galadriel.home>
References: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55286 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1JVIvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2011 04:51:15 -0400
In-Reply-To: <3915A3F8-ECF9-469B-869F-EA4C8421476E@mines.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Robbert <mrobbert@mines.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Fri, 21 Oct 2011 18:08:37 -0600 vous =C3=A9criviez:

>=20
> So, my question is this, is this setup technically possible or are
> the 2 HBAs going to conflict with each other when talking over the
> same SAS bus to the SATA drives?

Your explanation lacks important information, like the hardware in use
(controllers, jbods, drives, cabling, etc), kernel version, RAID ( is i=
t
linux software RAID you're using?) etc. However:

=46irst, you shouldn't be using desktop drives because it's extremely
dangerous (search the web and you'll find countless horror stories of
catastrophic failures, particularly with WD desktop drives).

Second, normally for SAS HA configuration, you must use SAS drives; the
main difference being that SAS drives have dual attachment, and can
manage commands coming from dual sources (controllers). SATA drives
lack the second path and can't be reliably driven from 2 different
controllers at once, unless you added a SAS to SATA adapter to them.

Third, your SAS controller must be able to work in multi-host
configuration. Most PCIe SAS controllers (3Ware, Adaptec, Areca,
HighPoint) can't do that at all. AFAIK only some LSI controllers are
multi-host aware, and this is a software option you must buy in
addition to the controller.

=46ourth, for a dual attachment you need to use both SAS data path to
both hosts, which would quickly make clear you can't use SATA drives
(because they'll simply won't show up at all on the second path).

=46ifth, if you're actually using linux md raid driver, I don't think
it to be in any manner multi-host capable. So that would be a
definitive dead end.

My advice : the only reliable way to achieve HA using SATA drives and
common SAS controllers is to use DRDB or some similar replication
mechanism. Yes, that means you'll need a second JBOD and twice the
number of drives. But it will _just_ _work_, both with hardware or
software RAID.

If necessary, you may need a pair of 10 Ge or IB cards for data
synchronisation between hosts to perform well enough. Modern hardware
can easily replicate over DRBD at several hundred MB per second.

Don't forget : "cheap, good, fast: choose two." In the case of large,
important, valuable data, "good" isn't really an option you may go
without anyway.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
