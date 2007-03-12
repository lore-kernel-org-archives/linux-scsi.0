From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Mon, 12 Mar 2007 16:58:19 -0700
Message-ID: <45F5E91B.7000000@gmail.com>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com> <45F093E4.9060805@cs.wisc.edu> <45F1EFA2.9070800@gmail.com> <45F31C2D.7000401@cs.wisc.edu> <45F3573E.2040802@aim.com> <45F596BE.8030103@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:23561 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXCLX6X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 19:58:23 -0400
Received: by wr-out-0506.google.com with SMTP id i28so1165730wra
        for <linux-scsi@vger.kernel.org>; Mon, 12 Mar 2007 16:58:23 -0700 (PDT)
In-Reply-To: <45F596BE.8030103@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> Aravind Parchuri wrote:
>> michaelc@cs.wisc.edu wrote:
>>> Aravind Parchuri wrote:
>>>   
>>>> My log messages were getting all mixed up, so I cleaned up my little
>>>> test to send just one command at a time. It actually looks like the mid
>>>> layer passes the command through to open-iscsi with the right size the
>>>> first time, but then it sends a second command with request_bufflen = 0.
>>>>
>>>> I can verify that the command completed on the target just like the
>>>> regular ones did, so there should be no reason for a retry of any sort.
>>>>
>>>> Here's the log for a 32896 byte command:
>>>> Mar  9 11:27:43 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcbadc000
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>>>> buff_size=32768, blk_size=32768
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768,
>>>> k_use_sg=1
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_common_write:  scsi
>>>> opcode=0x3b, cmd_size=10
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>>>> buff_size=32896, blk_size=33280
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896,
>>>> iovec_count=0, k_use_sg=2
>>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b
>>>> request_bufflen 32896 transfersize 32896
>>>>     
>>> Did you add your own output? Could you enable iscsi debugging? What
>>> kernel is this with and what versions of open-iscsi (upstream or svn or
>>> tarball release)?
>>>   
>> No custom output, all of this is from scsi (SCSI_LOG_TIMEOUT=5) and
>> open-iscsi (DEBUG_SCSI enabled). I thought I mentioned this in an
>> earlier mail -  the kernel is 2.6.19, but the open-iscsi drivers and
> 
> The output here does not have DEBUG_SCSI enabled. It just has your
> custom iscsi output. The first log had DEBUG_SCSI iscsi output.
> 

I'm extremely sorry - I think I forgot to enable it while recompiling 
stuff with your patch, and I was fooled by that print that we put in 
iscsi_queuecommand.

> But what I want is not just parts you cut out. I am looking for all of
> it. If I run:
> 
> sg_write_buffer /dev/sdi -l 32896

I wasn't aware that such a utility existed - it must be part of 
sg_utils, I guess. I just hacked up a test to fire an SG_IO ioctl to a 
given device. I guess I should try with this one next, just to check.

> 
> with my patch and a netapp target, I get the error:
> 
> Write buffer command not supported
> 
> If I look at the iscsi log, I see
> 
> Mar 12 12:59:54 madmax kernel: iscsi: cmd [itt 0x25 total 32896 imm_data
> 32896 unsol count 0, unsol offset 32896]
> Mar 12 12:59:54 madmax kernel: iscsi: ctask enq [write cid 0 sc
> ffff81000e82d6c0 cdb 0x3b itt 0x25 len 32896 cmdsn 294 win 128]
> Mar 12 12:59:54 madmax kernel: iscsi: ctask deq [cid 0 xmstate 2 itt 0x25]
> Mar 12 12:59:55 madmax kernel: iscsi: cmdrsp [op 0x21 cid 0 itt 0x25 len 24]
> Mar 12 12:59:55 madmax kernel: iscsi: copied 22 bytes of sense
> Mar 12 12:59:55 madmax kernel: iscsi: done [sc ffff81000e82d6c0 res 2
> itt 0x25]
> 
> 
> which shows the len got set and that the target failed the target and we
> got some sense back. The command is then failed to sg and sg returns to
> userspace.
> 
> Your output just shows that we may be retrying the same command over and
> over and it never completes which would be strange because the command
> is a block pc command. It would help to see what happens with iscsi's
> DEBUG_SCSI option to see if the command failed or completed ok. It would
> also be nice to get the scsi-ml output to see what the sense is and what
> is going on there, but as a first step we can look at the iscsi output.
>

Thanks for explaining in detail what's useful in debugging the problem. 
Here are logs with DEBUG_SCSI enabled, SCSI_LOG_TIMEOUT set to level 5, 
SCSI_LOG_MLQUEUE to 4 and SCSI_LOG_MLCOMPLETE to 4. This is everything 
in /var/log/messages from the time I issued the ioctl.

Command with 32896 bytes:

Mar 12 11:02:33 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt 
0xffffffff datalen 0]
Mar 12 11:02:33 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4 
itt 0xa05]
Mar 12 11:03:03 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt 
0xffffffff datalen 0]
Mar 12 11:03:03 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4 
itt 0xa06]
Mar 12 11:03:32 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt 
0xffffffff datalen 0]
Mar 12 11:03:32 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4 
itt 0xa07]
Mar 12 11:04:02 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt 
0xffffffff datalen 0]
Mar 12 11:04:02 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4 
itt 0xa08]
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcb554000
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_indirect: 
buff_size=32768, blk_size=32768
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768, 
k_use_sg=1
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_common_write:  scsi 
opcode=0x3b, cmd_size=10
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_build_indirect: 
buff_size=32896, blk_size=33280
Mar 12 11:04:21 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896, 
iovec_count=0, k_use_sg=2
Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi 4:0:0:0: send 0xd7b16380 
                scsi 4:0:0:0:
Mar 12 11:04:21 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 80 80 00
Mar 12 11:04:21 ITX000c292c3c8d kernel: buffer = 0xd7497c80, bufflen = 
32896, done = 0xd8876a7b, queuecommand 0xd8a9de6e
Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: cmd [itt 0x3 total 32896 
imm_data 32896 unsol count 0, unsol offset 32896]
Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: ctask enq [write cid 0 sc 
d7b16380 cdb 0x3b itt 0x3 len 32896 cmdsn 4 win 257]
Mar 12 11:04:21 ITX000c292c3c8d kernel: leaving scsi_dispatch_cmnd()
Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: ctask deq [cid 0 xmstate 
2 itt 0x3]
Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: cmdrsp [op 0x21 cid 0 itt 
0x3 len 0]
Mar 12 11:04:21 ITX000c292c3c8d kernel: iscsi: done [sc d7b16380 res 0 
itt 0x3]
Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi 4:0:0:0: done 0xd7b16380 
SUCCESS        0 scsi 4:0:0:0:
Mar 12 11:04:21 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 80 80 00
Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi host busy 1 failed 0
Mar 12 11:04:21 ITX000c292c3c8d kernel: scsi 4:0:0:0: Notifying upper 
driver of completion (result 0)
Mar 12 11:04:22 ITX000c292c3c8d kernel: scsi 4:0:0:0: send 0xd7b16380 
                scsi 4:0:0:0:
Mar 12 11:04:22 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 80 80 00
Mar 12 11:04:22 ITX000c292c3c8d kernel: buffer = 0xd749be00, bufflen = 
0, done = 0xd8876a7b, queuecommand 0xd8a9de6e
Mar 12 11:04:22 ITX000c292c3c8d kernel: iscsi: ctask enq [read cid 0 sc 
d7b16380 cdb 0x3b itt 0x4 len 0 cmdsn 5 win 257]
Mar 12 11:04:22 ITX000c292c3c8d kernel: leaving scsi_dispatch_cmnd()
Mar 12 11:04:22 ITX000c292c3c8d kernel: iscsi: ctask deq [cid 0 xmstate 
1 itt 0x4]
Mar 12 11:04:22 ITX000c292c3c8d kernel: iscsi: cmdrsp [op 0x21 cid 0 itt 
0x4 len 0]
Mar 12 11:04:22 ITX000c292c3c8d kernel: iscsi: done [sc d7b16380 res 0 
itt 0x4]
Mar 12 11:04:22 ITX000c292c3c8d kernel: scsi 4:0:0:0: done 0xd7b16380 
SUCCESS        0 scsi 4:0:0:0:
Mar 12 11:04:22 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 80 80 00
Mar 12 11:04:22 ITX000c292c3c8d kernel: scsi host busy 1 failed 0
Mar 12 11:04:22 ITX000c292c3c8d kernel: scsi 4:0:0:0: Notifying upper 
driver of completion (result 0)
Mar 12 11:04:22 ITX000c292c3c8d kernel: scsi 4:0:0:0: send 0xd7b16380 
                scsi 4:0:0:0:
Mar 12 11:04:22 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 80 80 00
Mar 12 11:04:22 ITX000c292c3c8d kernel: buffer = 0xd749be00, bufflen = 
0, done = 0xd8876a7b, queuecommand 0xd8a9de6e
.
.
.
[repeats forever]


33k command (successfully completes):

Mar 12 11:00:19 ITX000c292c3c8d kernel: iscsi: mgmtpdu [op 0x40 hdr->itt 
0xffffffff datalen 0]
Mar 12 11:00:19 ITX000c292c3c8d kernel: iscsi: mtask deq [cid 0 state 4 
itt 0xa01]
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcb43f000
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_build_indirect: 
buff_size=32768, blk_size=32768
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768, 
k_use_sg=1
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_common_write:  scsi 
opcode=0x3b, cmd_size=10
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=33792
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_build_indirect: 
buff_size=33792, blk_size=33792
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=33792, 
iovec_count=0, k_use_sg=2
Mar 12 11:00:35 ITX000c292c3c8d kernel: scsi 4:0:0:0: send 0xd7b16080 
                scsi 4:0:0:0:
Mar 12 11:00:35 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 84 00 00
Mar 12 11:00:35 ITX000c292c3c8d kernel: buffer = 0xd7497080, bufflen = 
33792, done = 0xd8876a7b, queuecommand 0xd8a9de6e
Mar 12 11:00:35 ITX000c292c3c8d kernel: iscsi: cmd [itt 0x2 total 33792 
imm_data 33792 unsol count 0, unsol offset 33792]
Mar 12 11:00:35 ITX000c292c3c8d kernel: iscsi: ctask enq [write cid 0 sc 
d7b16080 cdb 0x3b itt 0x2 len 33792 cmdsn 3 win 257]
Mar 12 11:00:35 ITX000c292c3c8d kernel: leaving scsi_dispatch_cmnd()
Mar 12 11:00:35 ITX000c292c3c8d kernel: iscsi: ctask deq [cid 0 xmstate 
2 itt 0x2]
Mar 12 11:00:35 ITX000c292c3c8d kernel: iscsi: cmdrsp [op 0x21 cid 0 itt 
0x2 len 0]
Mar 12 11:00:35 ITX000c292c3c8d kernel: iscsi: done [sc d7b16080 res 0 
itt 0x2]
Mar 12 11:00:35 ITX000c292c3c8d kernel: scsi 4:0:0:0: done 0xd7b16080 
SUCCESS        0 scsi 4:0:0:0:
Mar 12 11:00:35 ITX000c292c3c8d kernel:         command: Write Buffer: 
3b 01 01 00 00 00 00 84 00 00
Mar 12 11:00:35 ITX000c292c3c8d kernel: scsi host busy 1 failed 0
Mar 12 11:00:35 ITX000c292c3c8d kernel: scsi 4:0:0:0: Notifying upper 
driver of completion (result 0)
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_cmd_done: sg0, pack_id=0, res=0x0
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_finish_rem_req: res_used=0
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_remove_scat: k_use_sg=2
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_release: sg0
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_fasync: sg0, mode=0
Mar 12 11:00:35 ITX000c292c3c8d kernel: sg_remove_scat: k_use_sg=1


> Also what target are you using?

We're using a slightly modified unh-iscsi target.

Aravind.

