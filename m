From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg MiB writes scheduling while atomic
Date: 10 Sep 2003 13:30:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063222216.3669.87.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2>  <1063219776.3669.72.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:7308 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265680AbTIJT3N
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 15:29:13 -0400
In-Reply-To: <1063219776.3669.72.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


By the way, I notice I can quickly repeat the first couple of lines of
Call Trace if I interrupt the default 0.25 MiB writes of sg_dd with
Ctrl+C:

> http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/sg3_utils.html
> Appendix A. Sg3_utils package
> variants of the Unix dd command:
> sg_dd, sgp_dd, sgq_dd and sgm_dd, ...
> ...
> http://www.torque.net/sg/
> http://www.torque.net/sg/p/sg3_utils-1.05.tgz
> $ tar -zx ...
> $ cd sg3_utils-1.05
> $ make
> $ sudo ./sg_scan -i
> $ sudo ./sg_dd of=/dev/sg1 if=/dev/zero bs=2k
> ^C

Where I quote ^C I mean I use Ctrl+C to interrupt sg i/o.  I see I
provoke such dmsg as:

...
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 00 0f 80 00 00 80 00
usb-storage: Bulk Command S 0x43425355 T 0x1dfbf L 262144 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 262144 bytes, 8 entries
usb-storage: Status code 0; transferred 262144/262144
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1dfbf R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 00 10 00 00 00 80 00
usb-storage: Bulk Command S 0x43425355 T 0x1dfc0 L 262144 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 262144 bytes, 8 entries
usb-storage: Status code 0; transferred 262144/262144
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1dfc0 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
Debug: sleeping function called from invalid context at include/linux/rwsem.h:66
Call Trace:
 [<c0121f16>] __might_sleep+0x5f/0x72
 [<c0280ec0>] scsi_device_put+0x3c/0xfe
 [<df9263e3>] sg_cmd_done+0x19e/0x266 [sg]
 [<c0280ba6>] scsi_finish_command+0x78/0xb0
 [<c0280ad2>] scsi_softirq+0xb4/0xd9
 [<c0128c0b>] do_softirq+0xd3/0xd5
 [<c012912f>] ksoftirqd+0xbf/0xf8
 [<c0129070>] ksoftirqd+0x0/0xf8
 [<c0109245>] kernel_thread_helper+0x5/0xb

Another time:

Debug: sleeping function called from invalid context at include/linux/rwsem.h:66
Call Trace:
 [<c0121f16>] __might_sleep+0x5f/0x72
 [<c0280ec0>] scsi_device_put+0x3c/0xfe
 [<df9263e3>] sg_cmd_done+0x19e/0x266 [sg]
 [<c021fa59>] read_chan+0x0/0x98c
 [<c0280ba6>] scsi_finish_command+0x78/0xb0
 [<c0280ad2>] scsi_softirq+0xb4/0xd9
 [<c0128c0b>] do_softirq+0xd3/0xd5
 [<c011b4a0>] smp_apic_timer_interrupt+0xd8/0x140
 [<c010beae>] apic_timer_interrupt+0x1a/0x20



