From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] Devices disappear; on bus reset machine hangs; on I/O
 machine hangs
Date: Wed, 18 Nov 2009 14:05:35 GMT
Message-ID: <200911181405.nAIE5Zsi025406@demeter.kernel.org>
References: <bug-14579-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47178 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbZKROF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 09:05:29 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAIE5ZVo025407
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 14:05:35 GMT
In-Reply-To: <bug-14579-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14579


lkolbe@techfak.uni-bielefeld.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lkolbe@techfak.uni-bielefel
                   |                            |d.de




--- Comment #5 from lkolbe@techfak.uni-bielefeld.de  2009-11-18 14:05:34 ---
fyi

From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: "Support@techfak.uni-bielefeld.de" <Support@techfak.uni-bielefeld.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Date: Fri, 13 Nov 2009 17:29:43 +0530
Subject: RE: Bug 14579 -  Devices disappear... and Bug 14577 - Data
    corruption with Adaptec
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
In-Reply-To: <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>

Subject line is related to *Adaptec* and there are some places LSI related =
issue is pointed out. Little confusing to me. Is it possible to rewrite wha=
t is an issue related to LSI card?

>From dmesg log I can figure out 3.04.07 is mpt fusion driver version.
Please update LSI driver using latest upstream driver version 3.04.13. And =
see what a result is.

- Kashyap

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Sascha Frey
Sent: Friday, November 13, 2009 4:28 AM
To: linux-scsi@vger.kernel.org
Cc: Lukas Kolbe
Subject: Re: Bug 14579 - Devices disappear... and Bug 14577 - Data corrupti=
on with Adaptec

Hi,

Lukas Kolbe wrote:
>we'd really appreciate any hints and help we can get for the following
>bugs:
>http://bugzilla.kernel.org/show_bug.cgi?id=3D14579

We've done some further testing:
it's very hard to trigger this bug. Sometimes the machine freezes after
a few minutes into tape access and sometimes it works days - or even
weeks - without any problem.

The bug only appears during tape I/O (regardless of which tape program is
used: btape, dd or tar).
In most cases the tape write ends with an input/output error. After this
error occurred, any access to the tape library robot (connected through
the SAS interface of the first drive) fails:

# mtx unload 1 1
Unloading drive 1 into Storage Element 1...mtx: Request Sense: Long Report=
=3Dyes
mtx: Request Sense: Valid Residual=3Dno
mtx: Request Sense: Error Code=3D70 (Current)
mtx: Request Sense: Sense Key=3DIllegal Request
mtx: Request Sense: FileMark=3Dno
mtx: Request Sense: EOM=3Dno
mtx: Request Sense: ILI=3Dno
mtx: Request Sense: Additional Sense Code =3D 53
mtx: Request Sense: Additional Sense Qualifier =3D 01
mtx: Request Sense: BPV=3Dno
mtx: Request Sense: Error in CDB=3Dno
mtx: Request Sense: SKSV=3Dno
MOVE MEDIUM from Element Address 257 to 4096 Failed

After resetting the scsi bus (echo "- - -" >
/sys/class/scsi_host/host5/scan) the tape drives are revitalized, but
the changer device disappears. Even after a cold restart of the whole
library the device keeps missing.

Yet another problem: restting the SCSI bus of the LSI SAS HBA sometimes
results in a hardy freeze (console stuck; no log messages).

> [...]
>
>I do not believe it's a hardware fault at the moment as the machine
>ran OK under Solaris for a few weeks (including successful btape runs).
>

The very same piece of hardware worked fine using Solaris 10 with heavy
disk and tape I/O at the same time for two months.

We really prefer using Linux instead, but we're in pressure of time.


We appreciate any help resolving this bug!




Regards,
Sascha Frey


From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: "support@TechFak.Uni-Bielefeld.DE" <support@TechFak.Uni-Bielefeld.DE>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 18 Nov 2009 10:24:38 +0530
Subject: RE: Bug 14579 -  Devices disappear... and Bug 14577 - Data
    corruption with Adaptec
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
 <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
 <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
In-Reply-To: <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>

Hello Lukas,


> -----Original Message-----
> From: Lukas Kolbe [mailto:lkolbe@TechFak.Uni-Bielefeld.DE]
> Sent: Tuesday, November 17, 2009 7:53 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Bug 14579 - Devices disappear... and Bug 14577 - Data
> corruption with Adaptec
>=20
> Desai, Kashyap wrote:
>=20
> >Subject line is related to *Adaptec* and there are some places LSI
> >related issue is pointed out. Little confusing to me. Is it possible to
> >rewrite what is an issue related to LSI card?
>=20
> Sorry for that one. This system has an Adaptec Controller for its
> Storage array and an LSI controller for the tape library. Bug 14577 is
> about a possible data corruption on 2.6.32-rc6 that seems to be either a
> hardware error (currently trying to find that out) or a regression in
> 2.6.32-rc6, as 2.6.30 is very happy with its storage.
OK. In data corruption condition only LSI driver and controller are involve=
d? I mean can I nullify Adaptec controller's roll in your test?
>=20
> Finally, the real problem here is Bug 14579 that is about the systems
> problems when using the tape library.
>=20
> >From dmesg log I can figure out 3.04.07 is mpt fusion driver version.
> >Please update LSI driver using latest upstream driver version 3.04.13.
> And see what a result is.
>=20
> Thanks for the pointer. Linus' current tree contains 3.04.12 - where can
> I find 3.04.13?

It is there in 2.6.32-rc5. Not sure in which exact rc version it is include=
d, but I have 2.6.32-rc5 tree in my setup and for that kernel mptfusion ver=
sion is 3.104.13
>=20
> >- Kashyap
>=20
> Kind regards,
> Lukas Kolbe

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
