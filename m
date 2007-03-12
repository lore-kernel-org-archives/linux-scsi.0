From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Mon, 12 Mar 2007 13:06:54 -0500
Message-ID: <45F596BE.8030103@cs.wisc.edu>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com> <45F093E4.9060805@cs.wisc.edu> <45F1EFA2.9070800@gmail.com> <45F31C2D.7000401@cs.wisc.edu> <45F3573E.2040802@aim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54799 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXCLSHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2007 14:07:08 -0400
In-Reply-To: <45F3573E.2040802@aim.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aravind Parchuri <aravind.parchuri@gmail.com>
Cc: linux-scsi@vger.kernel.org

Aravind Parchuri wrote:
> michaelc@cs.wisc.edu wrote:
>> Aravind Parchuri wrote:
>>   
>>> My log messages were getting all mixed up, so I cleaned up my little
>>> test to send just one command at a time. It actually looks like the mid
>>> layer passes the command through to open-iscsi with the right size the
>>> first time, but then it sends a second command with request_bufflen = 0.
>>>
>>> I can verify that the command completed on the target just like the
>>> regular ones did, so there should be no reason for a retry of any sort.
>>>
>>> Here's the log for a 32896 byte command:
>>> Mar  9 11:27:43 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcbadc000
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>>> buff_size=32768, blk_size=32768
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768,
>>> k_use_sg=1
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_common_write:  scsi
>>> opcode=0x3b, cmd_size=10
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>>> buff_size=32896, blk_size=33280
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896,
>>> iovec_count=0, k_use_sg=2
>>> Mar  8 11:27:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b
>>> request_bufflen 32896 transfersize 32896
>>>     
>> Did you add your own output? Could you enable iscsi debugging? What
>> kernel is this with and what versions of open-iscsi (upstream or svn or
>> tarball release)?
>>   
> No custom output, all of this is from scsi (SCSI_LOG_TIMEOUT=5) and
> open-iscsi (DEBUG_SCSI enabled). I thought I mentioned this in an
> earlier mail -  the kernel is 2.6.19, but the open-iscsi drivers and

The output here does not have DEBUG_SCSI enabled. It just has your
custom iscsi output. The first log had DEBUG_SCSI iscsi output.

But what I want is not just parts you cut out. I am looking for all of
it. If I run:

sg_write_buffer /dev/sdi -l 32896

with my patch and a netapp target, I get the error:

Write buffer command not supported

If I look at the iscsi log, I see

Mar 12 12:59:54 madmax kernel: iscsi: cmd [itt 0x25 total 32896 imm_data
32896 unsol count 0, unsol offset 32896]
Mar 12 12:59:54 madmax kernel: iscsi: ctask enq [write cid 0 sc
ffff81000e82d6c0 cdb 0x3b itt 0x25 len 32896 cmdsn 294 win 128]
Mar 12 12:59:54 madmax kernel: iscsi: ctask deq [cid 0 xmstate 2 itt 0x25]
Mar 12 12:59:55 madmax kernel: iscsi: cmdrsp [op 0x21 cid 0 itt 0x25 len 24]
Mar 12 12:59:55 madmax kernel: iscsi: copied 22 bytes of sense
Mar 12 12:59:55 madmax kernel: iscsi: done [sc ffff81000e82d6c0 res 2
itt 0x25]


which shows the len got set and that the target failed the target and we
got some sense back. The command is then failed to sg and sg returns to
userspace.

Your output just shows that we may be retrying the same command over and
over and it never completes which would be strange because the command
is a block pc command. It would help to see what happens with iscsi's
DEBUG_SCSI option to see if the command failed or completed ok. It would
also be nice to get the scsi-ml output to see what the sense is and what
is going on there, but as a first step we can look at the iscsi output.

Also what target are you using?
