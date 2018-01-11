From: Vinson Lee <vlee@freedesktop.org>
Subject: Re: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Wed, 10 Jan 2018 16:52:58 -0800
Message-ID: <CACKvgLFZRHc6691FA_FK5yK89Y-L6RtDEB8eQjkw3fakuugehg@mail.gmail.com>
References: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
 <1515169935.3254.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:39734 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbeAKAxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 19:53:40 -0500
Received: by mail-oi0-f43.google.com with SMTP id t8so598048oie.6
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2018 16:53:39 -0800 (PST)
In-Reply-To: <1515169935.3254.2.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "don.brace@microsemi.com" <don.brace@microsemi.com>

On Fri, Jan 5, 2018 at 8:32 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Thu, 2018-01-04 at 14:32 -0800, Vinson Lee wrote:
>> HP ProLiant DL360p Gen8 with Smart Array P420i boots to the login
>> prompt and hangs with Linux 4.13 or later. I cannot log in on console
>> or SSH into the machine. Linux 4.12 and older boot fine.
>>
>> I see these messages on the console.
>>
>> [  242.843206] INFO: task scsi_eh_2:465 blocked for more than 120 seconds.
>> [  242.877835]       Not tainted 4.15.0-041500rc6-generic #201712312330
>
> It seems like something got stuck in the block layer. The traditional way to
> debug this is to analyze the information that is available under
> /sys/kernel/debug/block. However, since login is not possible we can't use
> that approach. Would it be possible for you to check whether this has been
> resolved in kernel v4.15-rc6, and if not, bisect this?
>
> Thanks,
>
> Bart.

Hi.

The machine still hangs with Linux 4.15-rc6.

I did a bisect. The hang is introduced with Linux 4.13-rc1 commit
c5cb83bb337c25caae995d992d1cdf9b317f83de "genirq/cpuhotplug: Handle
managed IRQs on CPU hotplug".

There is a startup script that disables hyperthreading by offlining
sibling CPUs.

for CPU in $(cut -s -d, -f2
$SYS_PATH/cpu*/topology/thread_siblings_list | sort -un); do
    echo 0 > /sys/devices/system/cpu/cpu$CPU/online
done

If the above script is not run, the machine does not hang with Linux 4.13.

Cheers,
Vinson
