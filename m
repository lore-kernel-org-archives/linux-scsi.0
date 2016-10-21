From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: Device or HBA level QD throttling creates randomness in sequetial workload
Date: Fri, 21 Oct 2016 17:43:35 +0530
Message-ID: <97184c74229af78b0d97e6b8016af972@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org, osandov@osandov.com
List-Id: linux-scsi@vger.kernel.org

Hi -

I found below conversation and it is on the same line as I wanted some
input from mailing list.

http://marc.info/?l=linux-kernel&m=147569860526197&w=2

I can do testing on any WIP item as Omar mentioned in above discussion.
https://github.com/osandov/linux/tree/blk-mq-iosched

Is there any workaround/alternative in latest upstream kernel, if user
wants to see limited penalty  for Sequential Work load on HDD ?

` Kashyap

> -----Original Message-----
> From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
> Sent: Thursday, October 20, 2016 3:39 PM
> To: linux-scsi@vger.kernel.org
> Subject: Device or HBA level QD throttling creates randomness in
sequetial
> workload
>
> [ Apologize, if you find more than one instance of my email.
> Web based email client has some issue, so now trying git send mail.]
>
> Hi,
>
> I am doing some performance tuning in MR driver to understand how sdev
> queue depth and hba queue depth play role in IO submission from above
layer.
> I have 24 JBOD connected to MR 12GB controller and I can see performance
for
> 4K Sequential work load as below.
>
> HBA QD for MR controller is 4065 and Per device QD is set to 32
>
> queue depth from <fio> 256 reports 300K IOPS queue depth from <fio> 128
> reports 330K IOPS queue depth from <fio> 64 reports 360K IOPS queue
depth
> from <fio> 32 reports 510K IOPS
>
> In MR driver I added debug print and confirm that more IO come to driver
as
> random IO whenever I have <fio> queue depth more than 32.
>
> I have debug using scsi logging level and blktrace as well. Below is
snippet of
> logs using scsi logging level.  In summary, if SML do flow control of IO
due to
> Device QD or HBA QD, IO coming to LLD is more random pattern.
>
> I see IO coming to driver is not sequential.
>
> [79546.912041] sd 18:2:21:0: [sdy] tag#854 CDB: Write(10) 2a 00 00 03 c0
3b 00
> 00 01 00 [79546.912049] sd 18:2:21:0: [sdy] tag#855 CDB: Write(10) 2a 00
00 03
> c0 3c 00 00 01 00 [79546.912053] sd 18:2:21:0: [sdy] tag#886 CDB:
Write(10) 2a
> 00 00 03 c0 5b 00 00 01 00
>
> <KD> After LBA "00 03 c0 3c" next command is with LBA "00 03 c0 5b".
> Two Sequence are overlapped due to sdev QD throttling.
>
> [79546.912056] sd 18:2:21:0: [sdy] tag#887 CDB: Write(10) 2a 00 00 03 c0
5c 00
> 00 01 00 [79546.912250] sd 18:2:21:0: [sdy] tag#856 CDB: Write(10) 2a 00
00 03
> c0 3d 00 00 01 00 [79546.912257] sd 18:2:21:0: [sdy] tag#888 CDB:
Write(10) 2a
> 00 00 03 c0 5d 00 00 01 00 [79546.912259] sd 18:2:21:0: [sdy] tag#857
CDB:
> Write(10) 2a 00 00 03 c0 3e 00 00 01 00 [79546.912268] sd 18:2:21:0:
[sdy]
> tag#858 CDB: Write(10) 2a 00 00 03 c0 3f 00 00 01 00
>
>  If scsi_request_fn() breaks due to unavailability of device queue (due
to below
> check), will there be any side defect as I observe ?
>                 if (!scsi_dev_queue_ready(q, sdev))
>                              break;
>
> If I reduce HBA QD and make sure IO from above layer is throttled due to
HBA
> QD, there is a same impact.
> MR driver use host wide shared tag map.
>
> Can someone help me if this can be tunable in LLD providing additional
settings
> or it is expected behavior ? Problem I am facing is, I am not able to
figure out
> optimal device queue depth for different configuration and work load.
>
> Thanks, Kashyap
