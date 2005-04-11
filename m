From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 4473] New: QLogic 2100: SCSI timeouts, device resets, and crashes kernel
Date: Mon, 11 Apr 2005 14:18:29 -0700
Message-ID: <20050411211829.GA822@us.ibm.com>
References: <20050411135132.13b258dd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:55450 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261938AbVDKVTO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 17:19:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j3BLJD5b468818
	for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2005 17:19:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3BLJD6O253896
	for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2005 15:19:13 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j3BLJCij016776
	for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2005 15:19:13 -0600
Content-Disposition: inline
In-Reply-To: <20050411135132.13b258dd.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, gregsurbey@hotmail.com

Greg,

I will add the same comment to the bug.

Did this work on a previous version of the kernel? Just checking to
understand if your connectivity to the storage unit or the unit itself
could be an issue.

If appears we are receiving timeouts, but on abort the qla is indicating
that the IO has already been completed. We could have IOs that are taking
near max timeout and then the error handler races with the completion of
the IO.

A debug step you could try is to raise the default timeout from 30 to
something like 60 seconds to see if this effects the error. To do this
just echo "60" > /sys/block/sd${N}/device/timeout. Also you can run iostat
during your testing to see what you IO times / queue depths look like.

Andrew Vasquez may be able to add more info.

Andrew Morton [akpm@osdl.org] wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 11 Apr 2005 13:03:16 -0700
> From: bugme-daemon@osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 4473] New: QLogic 2100: SCSI timeouts, device resets, and crashes kernel
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=4473
> 
>            Summary: QLogic 2100: SCSI timeouts, device resets, and crashes
>                     kernel
>     Kernel Version: 2.6.10 2.6.11.6.6 2.6.11-gentoo-r5
>             Status: NEW
>           Severity: blocking
>              Owner: andmike@us.ibm.com
>          Submitter: gregsurbey@hotmail.com
> 
> 
> Distribution: Gentoo 2005.0
> Hardware Environment: Dell PowerEdge 600SC
> Configuration: md RAID-5 11 disks 1 spare 
> 
> Card Description:
> QLogic PCI to Fibre Channel Host Adapter for QLA2100:
>         Firmware version 1.19.24 TP, Driver version 8.00.02b4-k
> ISP: ISP2100, Serial# A61828
> Request Queue = 0x1fce8000, Response Queue = 0x1fce2000
> Request Queue count = 128, Response Queue count = 64
> Total number of active commands = 0
> Total number of interrupts = 77339
>     Device queue depth = 0x10
> Number of free request entries = 59
> Number of mailbox timeouts = 0
> Number of ISP aborts = 0
> Number of loop resyncs = 0
> Number of retries for empty slots = 0
> Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
> Host adapter:loop state = <READY>, flags = 0x1c93
> Dpc flags = 0x80000
> MBX flags = 0x0
> Link down Timeout = 000
> Port down retry = 030
> Login retry count = 030
> Commands retried with dropped frame(s) = 0
> Product ID = 4953 5020 2020 0001
> 
> During the heavy use of md RAID reconstruction the card creates output in dmesg
> which I will attach to this bug report in my next post. 
> 
> Steps to reproduce:
> Use a Qlogic 2100 card with the qla2xxx driver
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-andmike
--
Michael Anderson
andmike@us.ibm.com

