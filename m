From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Fwd: Re: Problem with Linux aic94xx driver
Date: Sat, 30 Dec 2006 13:23:03 -0800
Message-ID: <4596D8B7.2080005@us.ibm.com>
References: <203581.7076.qm@web31806.mail.mud.yahoo.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39649 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030341AbWL3VXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Dec 2006 16:23:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBULNa7b025754
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2006 16:23:36 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBULN5dU247458
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2006 16:23:05 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBULN534032193
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2006 16:23:05 -0500
In-Reply-To: <203581.7076.qm@web31806.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: terje.rosten@ntnu.no
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

--- Terje R=F8sten <terje.rosten@ntnu.no> wrote:

> (It's 4 Western Digital RE2 WD5000YS with NCQ (500 GB SATA) on the
> controller,
> set up in RAID BIOS  to one RAID 1+0 logical drive).

I suppose this may be a moot point since Mr. R=F8sten bought a better
controller, but for the record, there exists another SAS stack that als=
o
does not have this bug (namely, the entire lack of SATA support):

http://www.kernel.org/git/?p=3Dlinux/kernel/git/jejb/aic94xx-sas-2.6.gi=
t;a=3Dsummary

There are various stability/functionality fixes for that stack that are
under development as well:

http://sweaglesw.net/~djwong/docs/sas_ata-patches/

That said, even if Mr. R=F8sten had built a driver with SATA support, h=
e
wrote that he had configured a RAID in the BIOS; to use that under
Linux, one needs the dmraid tool to set up BIOS RAID arrays as
device-mapper devices.  Of course, it is possible that at least one of
the many (five? six?) Adaptec 94xx driver variants supports both SATA
and HostRAID natively.

Better to use a nice 3ware card that takes care of all this in hardware=
=2E

--D
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
