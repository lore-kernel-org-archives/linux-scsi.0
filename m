From: Laurence Oberman <loberman@redhat.com>
Subject: Re: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Sun, 14 Jan 2018 18:40:40 -0500
Message-ID: <1515973240.8994.2.camel@redhat.com>
References: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:38720 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbeANXkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jan 2018 18:40:42 -0500
Received: by mail-qk0-f175.google.com with SMTP id j185so14970752qkc.5
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jan 2018 15:40:42 -0800 (PST)
In-Reply-To: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinson Lee <vlee@freedesktop.org>, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: "Hellwig, Christoph" <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>

On Thu, 2018-01-04 at 14:32 -0800, Vinson Lee wrote:
> Hi.
> 
> HP ProLiant DL360p Gen8 with Smart Array P420i boots to the login
> prompt and hangs with Linux 4.13 or later. I cannot log in on console
> or SSH into the machine. Linux 4.12 and older boot fine.
> 
> 
...

...

This issue bit me for for two straight days.
I was testing Mike Snitzers combined tree and this commit crept into
the latest combined tree.

commit 84676c1f21e8ff54befe985f4f14dc1edc10046b
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jan 12 10:53:05 2018 +0800

    genirq/affinity: assign vectors to all possible CPUs
   
    Currently we assign managed interrupt vectors to all present
CPUs.  This
    works fine for systems were we only online/offline CPUs.  But in
case of
    systems that support physical CPU hotplug (or the virtualized
version of
    it) this means the additional CPUs covered for in the ACPI tables
or on
    the command line are not catered for.  To fix this we'd either need
to
    introduce new hotplug CPU states just for this case, or we can
start
    assining vectors to possible but not present CPUs.
   
    Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Tested-by: Stefan Haberland <sth@linux.vnet.ibm.com>
    Fixes: 4b855ad37194 ("blk-mq: Create hctx for each present CPU")
    Cc: linux-kernel@vger.kernel.org
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reason I never thought about this being my reason for the latest hang
is I have used Linus' tree all the way to 4.15-rc7 with no issues.

Vinson reporting it against 4.13 or later was not making sense because
I had not seen the hang until this weekend.

I checked  and its in Linus's tree but its not an issue in the generic
4.15-rc7 for me.

Anyway, its going to possibly bite anybody running HP DL servers with
HPSA boot devices. I have not tried the workaround below.
>From Vinsons message repeated here

"The machine still hangs with Linux 4.15-rc6.

I did a bisect. The hang is introduced with Linux 4.13-rc1 commit
c5cb83bb337c25caae995d992d1cdf9b317f83de "genirq/cpuhotplug: Handle
managed IRQs on CPU hotplug".

There is a startup script that disables hyperthreading by offlining
sibling CPUs.

for CPU in $(cut -s -d, -f2
$SYS_PATH/cpu*/topology/thread_siblings_list | sort -un); do
    echo 0 > /sys/devices/system/cpu/cpu$CPU/online
done

If the above script is not run, the machine does not hang with Linux
4.13.

Cheers,
Vinson"

Thanks
Laurence
