From: Audio Haven <audiohaven@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Thu, 25 Feb 2010 14:35:56 +0100
Message-ID: <333bc7e11002250535p71420780g7d3803c2a83366fc@mail.gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
	 <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
	 <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com>
	 <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54096 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0BYNgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 08:36:00 -0500
Received: by bwz1 with SMTP id 1so2795063bwz.21
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2010 05:35:58 -0800 (PST)
In-Reply-To: <16370.87.210.74.220.1266919877.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

I have similar findings related to the Srinivas patch.

1) with the patch from Srinivas applied to 2.6.32.7, I cannot get my
raid6 on it's knees (yet). Using 8 drives on the marvell controller, 1
drive on onboard sata_nv .

Created raid6:
mdadm --create /dev/md2 --verbose --level=3D6 --chunk=3D1024
--raid-devices=3D9 /dev/sd[bcdefghij]1

XFS on top
mkfs.xfs -f -d su=3D1m,sw=3D7 /dev/md2

During the first raid resync, I'm also dumping 2TB of data on this
11TB xfs volume. It no longer drops drives. Currently copied 1.4T
without glitches.

2) with the patches from Andy Yan applied to 2.6.32.3, the first
resync worked, but when also stressing the system by copying data
during the initial resync, I observed mvs_abort_task which would make
drives kick out of raid after 0.8TB of copying or even quicker.

3) without any patches and a stock Fedora Core 12 kernel, the initial
resync NEVER worked.

So if I can fill my 11TB volume with data, and no drives are ever
kicked out, and xfs does not get corrupt, this patch is a huge
improvement. But this will take some more days to fill up. I'll report
the status when done.

Thanks !

On Tue, Feb 23, 2010 at 11:11 AM, Caspar Smit <c.smit@truebit.nl> wrote=
:
> Hi Srinivas,
>
> I finally had some time to test your new patch.
>
> 1) After numerous hotplug actions with SAS and SATA disks I still can=
't
> get any kernel panic to occur :)
>
> 2) I can finally boot a system with 3x 6480 controllers loaded with S=
ATA
> disks without a kernel panic.
>
> 3) Raid5/6 initialization completes without dropping the disks one af=
ter
> another.
>
> 4) One thing that occured was the following: during a raid1 initializ=
ation
> of 2 SAS disks and a raid5 init of 8x SSD's i got a call trace by
> libata-core.c (see attachment for details). The system continued to w=
ork
> fine after the trace.
>
> Great work, this is a much more stable driver now!
>
> Kind regards,
> Caspar Smit
>
>> On Wed, Feb 17, 2010 at 12:53 PM, Srinivas Naga Venkatasatya
>> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>>> Hi Smit,
>>>
>>> This patch is not exactly replaced with Nov-09 patches.
>>> My patch addresses the RAID5/6 issues also. Below issues are addres=
sed
>>> by my patch.
>>> 1. Tape issues.
>>> 2. RAID-5/6 I/O fails.
>>> 3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in cas=
caded
>>> =A0 =A0 =A0 =A0expanders, crate volume group and logical volumes, r=
un file I/O
>>> =A0 =A0 =A0 (alltest), unplug one drive)
>>> 4. Disk stress I/O on 4096 sector size.
>>> 5. Hot insertion of drives giving panic.
>>> 6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expande=
r
>>> while =A0 =A0 =A0IO (Diskstress and alltest) is going on and IO sto=
pped.
>>>
>>> I can't combined my patch with November-09 patches. James also reje=
cted
>>> those patches as those are not proper. Let me know if you have issu=
es
>>> with my patch.
>>>
>>> --Srini.
>>
>>
>> I haven't tested yet, but looks like you're doing excellent work, an=
d
>> your documentation/overview of the work is superb.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
