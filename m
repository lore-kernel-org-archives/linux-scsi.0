From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: Device or HBA QD throttling creates holes in Sequential work load
Date: Thu, 20 Oct 2016 12:11:14 +0530
Message-ID: <CAHsXFKEuXfHt3316qqW1Ccyd6Kyo_qZ6+jq39vMJyZRm5e5MBw@mail.gmail.com>
References: <CAHsXFKHHZToPLuB9N2UJ98b0hKnsz8_fNzb2Anz5aTUXZ1+YpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35765 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750845AbcJTGlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 02:41:16 -0400
Received: by mail-it0-f52.google.com with SMTP id 4so155195764itv.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2016 23:41:16 -0700 (PDT)
In-Reply-To: <CAHsXFKHHZToPLuB9N2UJ98b0hKnsz8_fNzb2Anz5aTUXZ1+YpA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reply to see if email reached to linux-scsi@vger.kernel.org.


On Thu, Oct 20, 2016 at 12:07 PM, Kashyap Desai
<kashyap.desai@broadcom.com> wrote:
> Hi,
>
> I am doing some performance tuning in MR driver to understand how sdev queue
> depth and hba queue depth play role in IO submission from above layer.
>
>  I have 24 JBOD connected to MR 12GB controller and I can see performance
> for 4K Sequential work load as below.
>
>  HBA QD for MR controller is 4065 and Per device QD is set to 32
>
>
>
> queue depth from <fio> 256 reports 300K IOPS
>
> queue depth from <fio> 128 reports 330K IOPS
>
> queue depth from <fio> 64 reports 360K IOPS
>
> queue depth from <fio> 32 reports 510K IOPS
>
>
>
> In MR driver I added debug print and confirm that more IO come to driver as
> random IO whenever I have <fio> queue depth more than 32.
>
> I have debug using scsi logging level and blktrace as well. Below is snippet
> of logs using scsi logging level.  In summary, if SML do flow control of IO
> due to Device QD or HBA QD,  IO coming to LLD is more random pattern.
>
>
>
> I see IO coming to driver is not sequential.
>
>
>
> [79546.912041] sd 18:2:21:0: [sdy] tag#854 CDB: Write(10) 2a 00 00 03 c0 3b
> 00 00 01 00 [79546.912049] sd 18:2:21:0: [sdy] tag#855 CDB: Write(10) 2a 00
> 00 03 c0 3c 00 00 01 00 [79546.912053] sd 18:2:21:0: [sdy] tag#886 CDB:
> Write(10) 2a 00 00 03 c0 5b 00 00 01 00 <- After 3c it jumps to 5b. Sequence
> are overlapped. Due to sdev QD throttling.
>
> [79546.912056] sd 18:2:21:0: [sdy] tag#887 CDB: Write(10) 2a 00 00 03 c0 5c
> 00 00 01 00 [79546.912250] sd 18:2:21:0: [sdy] tag#856 CDB: Write(10) 2a 00
> 00 03 c0 3d 00 00 01 00 [79546.912257] sd 18:2:21:0: [sdy] tag#888 CDB:
> Write(10) 2a 00 00 03 c0 5d 00 00 01 00 [79546.912259] sd 18:2:21:0: [sdy]
> tag#857 CDB: Write(10) 2a 00 00 03 c0 3e 00 00 01 00 [79546.912268] sd
> 18:2:21:0: [sdy] tag#858 CDB: Write(10) 2a 00 00 03 c0 3f 00 00 01 00
>
>
>
> If scsi_request_fn() breaks due to unavailability of device queue (due to
> below check), will there be any side defect as I observe ?
>
>                 if (!scsi_dev_queue_ready(q, sdev))
>
>                              break;
>
>  If I reduce HBA QD and make sure IO from above layer is throttled due to
> HBA QD, there is a same impact.  MR driver use host wide shared tag map.
>
>  Can someone help me if this can be tunable in LLD providing additional
> settings or it is expected behavior ? Problem I am facing is, I am not able
> to figure out optimal device queue depth for different configuration and
> work load.
>
>  ` Kashyap
>
>
>
>
>
>
