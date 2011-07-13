From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: Re: pm8001 performance degradation?
Date: Tue, 12 Jul 2011 20:15:18 -0700
Message-ID: <CAHQAjVHn7JfdiG0qHH=1ENT4-RM64tivbx4fSOnmnMZ3-U78ow@mail.gmail.com>
References: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com>
	<316E3E573B654596BA694678AE395999@usish.com.cn>
	<CAHQAjVG_cvvEX99A4ma5waSMs6hjWB_Bgy0oDZ4LgyzwwOpcjQ@mail.gmail.com>
	<9E591616165B4B14A80DE392145C99FC@usish.com.cn>
	<CAHQAjVECnvT5-zrp-D3xWqgz9Rp98WHYC-ubu7AWAkAN_Ertuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34069 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1GMDPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 23:15:19 -0400
Received: by wyg8 with SMTP id 8so240729wyg.19
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2011 20:15:18 -0700 (PDT)
In-Reply-To: <CAHQAjVECnvT5-zrp-D3xWqgz9Rp98WHYC-ubu7AWAkAN_Ertuw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org

Jack,

I think the apparent degradation was the result of profiling flags in
the .config file.

I turned off TASKSTATS, AUDIT, OPTIMIZE_FOR_SIZE, PROFILING (including
OPROFILE), and GCOV_KERNEL.

Somewhere in there I got the performance back.

Without intending to run any of the tools at the time of my tests, I
did not expect the consequences (I would only expect that if I was
using a tool).

Apologies for any confusion I passed to others.


David



On Tue, Jul 12, 2011 at 12:34 PM, ersatz splatt <ersatzsplatt@gmail.com=
> wrote:
> Jack,
>
> fio script is:
> [global]
> rw=3Dread
> direct=3D1
> time_based
> runtime=3D1m
> ioengine=3Dlibaio
> iodepth=3D32
> bs=3D512
> [dB]
> filename=3D/dev/sdb
> cpus_allowed=3D2
> [dC]
> filename=3D/dev/sdc
> cpus_allowed=3D3
> [dD]
> filename=3D/dev/sdd
> cpus_allowed=3D4
> [dE]
> filename=3D/dev/sde
> cpus_allowed=3D5
>
> (keep in mind this is a system with several cores)
>
>
> Before running the script I (of course) shut down coalescing:
> echo "2"> /sys/block/sdb/queue/nomerges
> echo "2"> /sys/block/sdc/queue/nomerges
> echo "2"> /sys/block/sdd/queue/nomerges
> echo "2"> /sys/block/sde/queue/nomerges
>
> echo noop > /sys/block/sdb/queue/scheduler
> echo noop > /sys/block/sdc/queue/scheduler
> echo noop > /sys/block/sdd/queue/scheduler
> echo noop > /sys/block/sde/queue/scheduler
>
> As you know, disk details are shown in the log on driver load:
> pm8001 0000:05:00.0: pm8001: driver version 0.1.36
> pm8001 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> scsi4 : pm8001
> scsi 4:0:0:0: Direct-Access =A0 =A0 SEAGATE =A0ST9146803SS =A0 =A0 =A0=
0004 PQ: 0 ANSI: 5
> sd 4:0:0:0: [sdb] 286749488 512-byte logical blocks: (146 GB/136 GiB)
> sd 4:0:0:0: Attached scsi generic sg1 type 0
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> =A0sdb: unknown partition table
> sd 4:0:0:0: [sdb] Attached SCSI disk
> scsi 4:0:1:0: Direct-Access =A0 =A0 SEAGATE =A0ST9146803SS =A0 =A0 =A0=
0006 PQ: 0 ANSI: 5
> sd 4:0:1:0: Attached scsi generic sg2 type 0
> sd 4:0:1:0: [sdc] 286749488 512-byte logical blocks: (146 GB/136 GiB)
> sd 4:0:1:0: [sdc] Write Protect is off
> sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> =A0sdc: unknown partition table
> sd 4:0:1:0: [sdc] Attached SCSI disk
> scsi 4:0:2:0: Direct-Access =A0 =A0 SEAGATE =A0ST9146803SS =A0 =A0 =A0=
0004 PQ: 0 ANSI: 5
> sd 4:0:2:0: [sdd] 286749488 512-byte logical blocks: (146 GB/136 GiB)
> sd 4:0:2:0: Attached scsi generic sg3 type 0
> sd 4:0:2:0: [sdd] Write Protect is off
> sd 4:0:2:0: [sdd] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> =A0sdd: unknown partition table
> sd 4:0:2:0: [sdd] Attached SCSI disk
> scsi 4:0:3:0: Direct-Access =A0 =A0 SEAGATE =A0ST9146803SS =A0 =A0 =A0=
0004 PQ: 0 ANSI: 5
> sd 4:0:3:0: [sde] 286749488 512-byte logical blocks: (146 GB/136 GiB)
> sd 4:0:3:0: Attached scsi generic sg4 type 0
> sd 4:0:3:0: [sde] Write Protect is off
> sd 4:0:3:0: [sde] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> =A0sde: unknown partition table
> sd 4:0:3:0: [sde] Attached SCSI disk
>
>
> The firmware version is 1.11.
>
> Let me know if you have any other questions. =A0Please let me know if
> you can confirm the performance degradation with the driver as it is.
>
>
> David
>
>
> On Mon, Jul 11, 2011 at 9:18 PM, Jack Wang <jack_wang@usish.com> wrot=
e:
>> Could you share your fio test scripts? disk detail and HBA firmware =
version
>> are also wanted if available.
>>
>> Jack
>>>
>>> I have one HBA connected directly to 4 SAS drives ... using a singl=
e 1
>>> to four cable.
>>>
>>>
>>> On Mon, Jul 11, 2011 at 6:27 PM, Jack Wang <jack_wang@usish.com> wr=
ote:
>>> >> Hello Jack Wang and Lindar Liu,
>>> >>
>>> >>
>>> >> I am running the pm8001 driver (on applicable hardware including=
 a
>>> >> several core SMP server).
>>> >>
>>> >> When I run on an older kernel -- e.g. 2.6.34.7 -- I get about 73=
Kiops
>>> >> via an fio test.
>>> >>
>>> >> When I run a current kernel -- e.g. 2.6.39.2 -- on the same syst=
em and
>>> >> same storage I get about 15Kiops running the same fio test.
>>> >>
>>> >> Perhaps something has changes in the kernel that is not being ac=
counted
>>> > for?
>>> >> Are you two still maintaining this driver?
>>> >>
>>> >>
>>> >> Regards,
>>> >> David
>>> > [Jack Wang] =A0Could you give your detailed topology, I will late=
r try to
>>> > investigate the performance issue, but as I remember an Intel dev=
eloper
>>> > reports in mailist some changes in block layer lead to JBOD perfo=
rmance
>>> > degradation.
>>> >
>>> >
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
