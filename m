From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: RE: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 24 Feb 2010 10:16:26 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF71F64F5D39@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <31220.87.210.74.220.1266925266.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:38580 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab0BXEqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 23:46:45 -0500
In-Reply-To: <31220.87.210.74.220.1266925266.squirrel@ketsers.dhs.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Smit,
Thanks for your efforts for verifying the patch.=20

>>>>>> The disks are detected during boot in reverse order (port 1 -> /=
dev/sde,port 2 -> /dev/sdd, port 3 -> /dev/sdc, port 4, /dev/sdb) is it=
 possiblewith a simple patch to fix this?

Mostly your HBA is discovering in reverse order. Because we are not fac=
ing this kind of problem here. This is specific to your HBA so we shoul=
d not do changes in driver. Please let me know if you observe any issue=
s with this driver.

--Srini.

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Caspar Smit
Sent: Tuesday, February 23, 2010 5:11 PM
To: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues

Another note:

--
4) One thing that occured was the following: during a raid1 initializat=
ion
of 2 SAS disks and a raid5 init of 8x SSD's i got a call trace by
libata-core.c (see attachment for details). The system continued to wor=
k
fine after the trace.
--

I noticed later that after the above happened, one of my SAS disks was
TERRIBLY slow (5MB/s raid1 sync in stead of 120MB/s) after a reboot all
was fine so it wasn't a defective disk.

Then something else I posted somewhat earlier.
The disks are detected during boot in reverse order (port 1 -> /dev/sde=
,
port 2 -> /dev/sdd, port 3 -> /dev/sdc, port 4, /dev/sdb) is it possibl=
e
with a simple patch to fix this?

Thanks for all your great work!

Kind regards,
Caspar Smit

> On Wed, Feb 17, 2010 at 12:53 PM, Srinivas Naga Venkatasatya
> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>> Hi Smit,
>>
>> This patch is not exactly replaced with Nov-09 patches.
>> My patch addresses the RAID5/6 issues also. Below issues are address=
ed
by my patch.
>> 1. Tape issues.
>> 2. RAID-5/6 I/O fails.
>> 3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in
cascaded =A0 =A0 =A0 =A0expanders, crate volume group and logical volum=
es, run
file I/O =A0 =A0 =A0 =A0 (alltest), unplug one drive)
>> 4. Disk stress I/O on 4096 sector size.
>> 5. Hot insertion of drives giving panic.
>> 6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expander
while =A0 =A0 =A0IO (Diskstress and alltest) is going on and IO stopped=
=2E
>>
>> I can't combined my patch with November-09 patches. James also rejec=
ted
those patches as those are not proper. Let me know if you have issues
with my patch.
>>
>> --Srini.
>
>
> I haven't tested yet, but looks like you're doing excellent work, and
your documentation/overview of the work is superb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


DISCLAIMER:
-----------------------------------------------------------------------=
------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.=20
It shall not attach any liability on the originator or HCL or its affil=
iates. Any views or opinions presented in=20
this email are solely those of the author and may not necessarily refle=
ct the opinions of HCL or its affiliates.=20
Any form of reproduction, dissemination, copying, disclosure, modificat=
ion, distribution and / or publication of=20
this message without the prior written consent of the author of this e-=
mail is strictly prohibited. If you have=20
received this email in error please delete it and notify the sender imm=
ediately. Before opening any mail and=20
attachments please check them for viruses and defect.

-----------------------------------------------------------------------=
------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
