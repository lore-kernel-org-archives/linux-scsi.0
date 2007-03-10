From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Fri, 09 Mar 2007 20:56:42 -0800
Message-ID: <45F23A8A.5020703@gmail.com>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com> <45F093E4.9060805@cs.wisc.edu> <45F1EFA2.9070800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:27297 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767820AbXCJE4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2007 23:56:47 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1573848uga
        for <linux-scsi@vger.kernel.org>; Fri, 09 Mar 2007 20:56:45 -0800 (PST)
In-Reply-To: <45F1EFA2.9070800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

FYI, commenting out the sector roundup in sg_build_indirect ( blk_size = 
(blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK); ) made everything work 
fine with my test and open-iscsi in general. I'm sure there's a 
glaringly obvious reason for that roundup (one that I'm unaware of), so 
I presume this isn't an acceptable solution,

Aravind.


michaelc@cs.wisc.edu wrote:
> My log messages were getting all mixed up, so I cleaned up my little 
> test to send just one command at a time. It actually looks like the mid 
> layer passes the command through to open-iscsi with the right size the 
> first time, but then it sends a second command with request_bufflen = 0.
> 
> I can verify that the command completed on the target just like the 
> regular ones did, so there should be no reason for a retry of any sort.
> 
> Here's the log for a 32896 byte command:
> Mar  9 11:27:43 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcbadc000
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect: 
> buff_size=32768, blk_size=32768
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768, 
> k_use_sg=1
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_common_write:  scsi 
> opcode=0x3b, cmd_size=10
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect: 
> buff_size=32896, blk_size=33280
> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896, 
> iovec_count=0, k_use_sg=2
> Mar  8 11:27:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 32896 transfersize 32896
> Mar  8 11:27:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 0 transfersize 0
> Mar  8 11:27:44 ITX000c292c3c8d last message repeated 289 times
> Mar  8 11:27:44 ITX000c292c3c8d kernel: sg_release: sg0
> Mar  8 11:27:44 ITX000c292c3c8d kernel: sg_fasync: sg0, mode=0
> Mar  8 11:27:44 ITX000c292c3c8d kernel: sg_remove_sfp: worrisome, 1 
> writes pending
> Mar  8 11:27:44 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 0 transfersize 0
> Mar  8 11:27:57 ITX000c292c3c8d last message repeated 3197 times
> Mar  8 11:27:57 ITX000c292c3c8d kernel: SysRq : Changing Loglevel
> Mar  8 11:27:57 ITX000c292c3c8d kernel: Loglevel set to 0
> Mar  8 11:27:57 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 0 transfersize 0
> 
> For comparison, here's a 30 kB command:
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcb826000
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_build_indirect: 
> buff_size=32768, blk_size=32768
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768, 
> k_use_sg=1
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_common_write:  scsi 
> opcode=0x3b, cmd_size=10
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=30848
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_link_reserve: size=30848
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=30848, 
> iovec_count=0, k_use_sg=1
> Mar  8 11:24:20 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 30848 transfersize 30848
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_cmd_done: sg0, pack_id=0, 
> res=0x0
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_finish_rem_req: res_used=1
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_unlink_reserve: req->k_use_sg=1
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_release: sg0
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_fasync: sg0, mode=0
> Mar  8 11:24:20 ITX000c292c3c8d kernel: sg_remove_scat: k_use_sg=1
> 
> 
> Here's a 33 kB command, which also goes through fine:
> Mar  8 12:21:53 ITX000c292c3c8d kernel: Kernel logging (proc) stopped.
> Mar  8 12:21:53 ITX000c292c3c8d kernel: Kernel log daemon terminating.
> Mar  8 12:21:54 ITX000c292c3c8d exiting on signal 15
> Mar  8 12:21:54 ITX000c292c3c8d syslogd 1.4.1: restart.
> Mar  8 12:21:55 ITX000c292c3c8d kernel: klogd 1.4.1, log source = 
> /proc/kmsg started.
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcb9ef000
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_build_indirect: 
> buff_size=32768, blk_size=32768
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768, 
> k_use_sg=1
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_common_write:  scsi 
> opcode=0x3b, cmd_size=10
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=33792
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_build_indirect: 
> buff_size=33792, blk_size=33792
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=33792, 
> iovec_count=0, k_use_sg=2
> Mar  8 12:22:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b 
> request_bufflen 33792 transfersize 33792
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_cmd_done: sg0, pack_id=0, 
> res=0x0
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_finish_rem_req: res_used=0
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_remove_scat: k_use_sg=2
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_release: sg0
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_fasync: sg0, mode=0
> Mar  8 12:22:43 ITX000c292c3c8d kernel: sg_remove_scat: k_use_sg=1
> 
> It's still got something to do with the sector-aligned scatter-gather 
> buffer allocation in sg_build_indirect. sg_cmd_done isn't ever called, 
> so is there a check somewhere in the completion path that's still using 
> the wrong size?
> 
> Aravind.
> 
> 
> 
> 
> 
> michaelc@cs.wisc.edu wrote:
>> Aravind Parchuri wrote:
>>> The patch has some problem. While ioctls with dxfer_len < 32k still make
>>> it through properly, the problematic ones now show up in open-iscsi's
>>> queuecommand with request_bufflen = 0. I'm not sure what the problem is
>>> now.
>>>
>>
>> Could you send the sg and iscsi log output with the patch?
> 
> 
> 

