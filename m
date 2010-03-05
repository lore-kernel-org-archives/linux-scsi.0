From: Audio Haven <audiohaven@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Fri, 5 Mar 2010 09:57:27 +0100
Message-ID: <333bc7e11003050057h1fda525fj48a24d4eb2147681@mail.gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
	 <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
	 <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com>
	 <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
	 <333bc7e11002250535p71420780g7d3803c2a83366fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:41956 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab0CEI5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 03:57:31 -0500
Received: by fg-out-1718.google.com with SMTP id l26so148471fgb.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Mar 2010 00:57:29 -0800 (PST)
In-Reply-To: <333bc7e11002250535p71420780g7d3803c2a83366fc@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello all mvsas testers ...

Some good test progress related to mvsas & the Srinivas patch:

I have dumped 10TB of data on a 10.5TB net softraid RAID6 (9x1.5TB)
volume while the initial resync was running. 8 drives were connected
to an mvsas controller, 1 to sata_nv. No XFS corruption, no drives
kicked out of raid. The raid synced without problems.

I'm repeating the experiment with a RAID6 based on 12 1.5T drives: 8
on mvsas, 4 on sata_nv. All of the mvsas attached drives remain
stable. All devices connected to mvsas except for device[4] experience
one of more mvs_I_T_nexus_reset :

drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[0]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[2]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[1]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[7]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[2]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[7]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[6]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[2]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[1]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[7]:rc=3D=
 0
drivers/scsi/mvsas/mv_sas.c 1630:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1584:mvs_I_T_nexus_reset for device[5]:rc=3D=
 0

time window =3D +- 1 day
This does not seem to affect raid, all drives are still in the set
after 3TB of copying. Are the above warnings something to worry about
?

On Thu, Feb 25, 2010 at 2:35 PM, Audio Haven <audiohaven@gmail.com> wro=
te:
> Hello,
>
> I have similar findings related to the Srinivas patch.
>
> 1) with the patch from Srinivas applied to 2.6.32.7, I cannot get my
> raid6 on it's knees (yet). Using 8 drives on the marvell controller, =
1
> drive on onboard sata_nv .
>
> Created raid6:
> mdadm --create /dev/md2 --verbose --level=3D6 --chunk=3D1024
> --raid-devices=3D9 /dev/sd[bcdefghij]1
>
> XFS on top
> mkfs.xfs -f -d su=3D1m,sw=3D7 /dev/md2
>
> During the first raid resync, I'm also dumping 2TB of data on this
> 11TB xfs volume. It no longer drops drives. Currently copied 1.4T
> without glitches.
>
> So if I can fill my 11TB volume with data, and no drives are ever
> kicked out, and xfs does not get corrupt, this patch is a huge
> improvement. But this will take some more days to fill up. I'll repor=
t
> the status when done.
>
> Thanks !
>
> On Tue, Feb 23, 2010 at 11:11 AM, Caspar Smit <c.smit@truebit.nl> wro=
te:
>> Hi Srinivas,
>>
>> I finally had some time to test your new patch.
>>
>> 1) After numerous hotplug actions with SAS and SATA disks I still ca=
n't
>> get any kernel panic to occur :)
>>
>> 2) I can finally boot a system with 3x 6480 controllers loaded with =
SATA
>> disks without a kernel panic.
>>
>> 3) Raid5/6 initialization completes without dropping the disks one a=
fter
>> another.
>>
>> 4) One thing that occured was the following: during a raid1 initiali=
zation
>> of 2 SAS disks and a raid5 init of 8x SSD's i got a call trace by
>> libata-core.c (see attachment for details). The system continued to =
work
>> fine after the trace.
>>
>> Great work, this is a much more stable driver now!
>>
>> Kind regards,
>> Caspar Smit
>>
>>> On Wed, Feb 17, 2010 at 12:53 PM, Srinivas Naga Venkatasatya
>>> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>>>> Hi Smit,
>>>>
>>>> This patch is not exactly replaced with Nov-09 patches.
>>>> My patch addresses the RAID5/6 issues also. Below issues are addre=
ssed
>>>> by my patch.
>>>> 1. Tape issues.
>>>> 2. RAID-5/6 I/O fails.
>>>> 3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in ca=
scaded
>>>> =A0 =A0 =A0 =A0expanders, crate volume group and logical volumes, =
run file I/O
>>>> =A0 =A0 =A0 (alltest), unplug one drive)
>>>> 4. Disk stress I/O on 4096 sector size.
>>>> 5. Hot insertion of drives giving panic.
>>>> 6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expand=
er
>>>> while =A0 =A0 =A0IO (Diskstress and alltest) is going on and IO st=
opped.
>>>>
>>>> I can't combined my patch with November-09 patches. James also rej=
ected
>>>> those patches as those are not proper. Let me know if you have iss=
ues
>>>> with my patch.
>>>>
>>>> --Srini.
>>>
>>>
>>> I haven't tested yet, but looks like you're doing excellent work, a=
nd
>>> your documentation/overview of the work is superb.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
