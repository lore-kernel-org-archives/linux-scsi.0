From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Subject: Re: puzzling scsi return code 20000
Date: Wed, 07 Jul 2004 12:04:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EBCA9B.90402@univ-nantes.fr>
References: <40E9448F.1090700@univ-nantes.fr> <20040706184626.GA30970@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from feyd.cri.univ-nantes.fr ([193.52.125.55]:39324 "EHLO
	smtp.cri.univ-nantes.fr") by vger.kernel.org with ESMTP
	id S265031AbUGGKEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2004 06:04:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.cri.univ-nantes.fr (Postfix) with ESMTP id 9E9CBE0B745
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2004 12:04:10 +0200 (CEST)
Received: from smtp.cri.univ-nantes.fr ([127.0.0.1])
	by localhost (smtp.cri.univ-nantes.fr [193.52.125.55]) (amavisd-new, port 10024)
	with LMTP id 16446-02 for <linux-scsi@vger.kernel.org>;
	Wed, 7 Jul 2004 12:04:09 +0200 (CEST)
Received: from [193.52.125.24] (lamier.cri.univ-nantes.fr [193.52.125.24])
	by smtp.cri.univ-nantes.fr (Postfix) with ESMTP id BEF01EB181F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2004 12:04:09 +0200 (CEST)
In-Reply-To: <20040706184626.GA30970@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:

>On Mon, 05 Jul 2004, Yann Dupont wrote:
>
> =20
>
Hello andrew, thanks for taking time to respond

>>hello. I have some problems with a SAN here. Don't know if the proble=
ms=20
>>lies in scsi code/driver or other thing...
>>
>>The setup is :
>>a QLA2300 (Fibre channel) with 6.0.64 driver from qlogic site,
>>
>>   =20
>>
>
>I'm not familiar with that version number (are you sure it's 6.0.64,
>perhaps 6.06.64?).  I believe the latest driver submitted to DVT has
> =20
>
of course it's 6.06.64, sorry for the mistake. this is the 'IBM
approved' version

>been posted to the website (7.00.03).
>
> =20
>
Yes i've seen that . But I had problems with that version (see later)

>>2.4.26 kernel, device mapper 1.0.17 applied,
>>and xfs or reiserfs on top of lvm volumes (using evms)
>>
>>This setup seemed fine since some months now, with giga of data moved=
=20
>>every day, but I noticed this on the log:
>>
>>Jun 22 16:45:15 talisker kernel: SCSI disk error : host 3 channel 0 i=
d 2=20
>>lun 1 return code =3D 20000
>>Jun 22 16:45:15 talisker kernel:  I/O error: dev 08:10, sector 145423=
312
>>
>>I have two of these errors in the last month. What's the meaning of t=
his=20
>>return code ? I made
>>badblock on the /dev/evms volume, and all is OK.
>>
>>   =20
>>
>
>20000 =3D=3D DID_BUS_BUSY -- one possibility, the QLogic driver return=
ed a
>command with the status, mid-layer ran out of retries, subsequently
>returning the status to the upper-layer driver.  But that doesn't
>help in finding out what went wrong.
>
> =20
>
>>I also performed a disk scan on the raid array, (an IFT 7250F) and th=
ere=20
>>are no errors.
>>
>>The machine can be quite heavily loaded. May I suspect the qla driver=
 ?=20
>>May I suspect the underlying LVM. The LVM has been resized by the=20
>>past... Can an error happens here too ?
>>I'm very puzzled...
>>
>>This is just a summary . I can furnish more information if needed.
>>
>>   =20
>>
>
>I'd suggest you try a more recent driver (noted above), if the I/O
>errors persist, then report the problem to tech-support at:
>
> =20
>

Well the 7.00.03 version didn't see any of the disks on the second
channels of the controllers,
until I realise this is a failover by default. Appending ql2xfailover=3D=
0
did the trick.


Anyway, Yesterday the problem begins to show every second on another
machine, on a volume with lots of data...
So I took lots of time to see where the problem is..

Summary : My problem is solved since this morning but i'm not quite sur=
e
qlogic driver is involved:

Quick resume :

2.4.26 + dm 0.17 + qla 6.06.64 =3D scsi error
2.4.26 + dm 0.17 + qla 7.00.03 =3D hang (no errors, but all scsi/qla
operations just hang) then (after long time) scsi errors


-> upgrade the san RAID to the very last firmware,

same kernels as above : same errors

2.6.7 (with embedded dm & qla 8.xx.x) =3D scsi error too (tried that
because I know lots of work has been done on the scsi, qla & dm layer)

2.4.27-rc3 + dm 0.19 + qla 7.00.03 =3D No errors !!!

As my problem has only arised on lvm volumes that has been resized by
evms, and the only difference between
failing & non failing operation is the device mapper version, I begins
to wonder if the culprit is not here.

What suprises me anyway is that it's mapped to scsi error...

Anyway, quite pleased that the problem is solved, but quite perplex
about where the *real* problem
is lying..


One note about 7.00.03 : Seems to work well, but is this version not
prone to locking too much ?? I tried a raw copy between 2 san volumes
(using dd) and the machine was very unresponsive ; That is , during
transfer, the machine sems to hang , then after data is copied, ths
machines start to respond again. This is not something i've seen on the
other drivers.

The machine is a Bi Xeon 2.8ghz with 2 gig of ram...

>	http://connection.qlogic.com/support/report/index.asp?id=3Dcsg
>
> =20
>

Thanks for this url & Thanks for the answer.

Sincerely yours,

--=20

Yann Dupont, Cri de l'universit=E9 de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
