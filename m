From: Joerg Schilling <schilling@fokus.fraunhofer.de>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Fri, 6 Feb 2004 16:10:59 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402061510.i16FAxbX002025@burner.fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:6588 "EHLO
	mailhub.fokus.fraunhofer.de") by vger.kernel.org with ESMTP
	id S265473AbUBFPL7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 10:11:59 -0500
List-Id: linux-scsi@vger.kernel.org
To: mdharm-usb@one-eyed-alien.net, schilling@fokus.fraunhofer.de, stern@rowland.harvard.edu
Cc: appro@fy.chalmers.se, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, magliery@csb.yale.edu


>From stern@rowland.harvard.edu  Fri Feb  6 15:59:52 2004

>> But as you may know, there is a Linux bug that causes the status to =
be 0 when
>> sense data (correctly) is available. Libscg _needs_ to add a workaro=
unf for
>> this bug or nothing would work!

>What bug is that?  Or rather, under what circumstances is the status e=
qual=20
>to 0 when it shouldn't be?

Sorry, this is long long ago ---> Check the cdrwite mail archives.


>> It is definitely a severe bug in the kernel to retrieve sense data i=
n case
>> of a DMA size error.

>> -	The Linux kernel issues a REQUEST SENSE command ---> this is the f=
irst
>> 	severe bug. It is completely wrong to issue a REQUEST SENSE in
>> 	case of a DMA Size error.

>> And there exactly is the bug (which is most likely in usb-storage bu=
t
>> definitely in the Linux kernel:
>>=20
>>       In case of _only_ a DMA size error, a request sense must not b=
e
>>       issued by the driver.
>>=20
>> If you are the maintainer of this piece of software, please fix this=
=2E

>(I'm not the maintainer; Matthew Dharm is.)

>Who says it's wrong to retrieve sense information when there is an
>underrun but not Check Condition?  Can you provide a reference to a
>published (or draft) document that states this?

The SCSI standard says that the sense data should retrieved when the=20
CHECK CONDITION bit is set. ATAPI drives use a bit in the ATA Status
for this purpose.

Read the SCSI CAM standard to see more on this topic.

>Bear in mind that there are some transports which do not provide any
>status at all.  The _only_ way for a driver to determine whether an
>error occurred is to get the sense data.

Let us asume such transport does not exist, unless you name at least a
single transport that has no bit that means "CHECK CONDITION".


>In the absence of any official statement to the contrary, the logical
>conclusion is that whether or not the driver gets the sense data is a
>low-level matter.  It should only be of interest to the driver and the
>device.  Higher-level drivers and user programs should not care one wa=
y or
>the other.

If you retrive sense data without reason, you may "read away" a sensefu=
l
error status that is related to a different command.=20


J=F6rg

--=20
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) J=F6rg Schilling D-1335=
3 Berlin
       js@cs.tu-berlin.de		(uni)  If you don't have iso-8859-1
       schilling@fokus.fraunhofer.de	(work) chars I am J"org Schilling
 URL:  http://www.fokus.fraunhofer.de/usr/schilling ftp://ftp.berlios.d=
e/pub/schily
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
