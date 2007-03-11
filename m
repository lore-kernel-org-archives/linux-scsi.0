From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Sat, 10 Mar 2007 17:11:26 -0800
Message-ID: <45F3573E.2040802@aim.com>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com> <45F093E4.9060805@cs.wisc.edu> <45F1EFA2.9070800@gmail.com> <45F31C2D.7000401@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.236]:47021 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbXCKBIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Mar 2007 20:08:53 -0500
Received: by nz-out-0506.google.com with SMTP id s1so1122323nze
        for <linux-scsi@vger.kernel.org>; Sat, 10 Mar 2007 17:08:52 -0800 (PST)
In-Reply-To: <45F31C2D.7000401@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> Aravind Parchuri wrote:
>   
>> My log messages were getting all mixed up, so I cleaned up my little
>> test to send just one command at a time. It actually looks like the mid
>> layer passes the command through to open-iscsi with the right size the
>> first time, but then it sends a second command with request_bufflen = 0.
>>
>> I can verify that the command completed on the target just like the
>> regular ones did, so there should be no reason for a retry of any sort.
>>
>> Here's the log for a 32896 byte command:
>> Mar  9 11:27:43 ITX000c292c3c8d kernel: sg_open: dev=0, flags=0x802
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp: sfp=0xcbadc000
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_reserve: req_size=32768
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>> buff_size=32768, blk_size=32768
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_add_sfp:   bufflen=32768,
>> k_use_sg=1
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_ioctl: sg0, cmd=0x2285
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_common_write:  scsi
>> opcode=0x3b, cmd_size=10
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_start_req: dxfer_len=32896
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_build_indirect:
>> buff_size=32896, blk_size=33280
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: sg_write_xfer: num_xfer=32896,
>> iovec_count=0, k_use_sg=2
>> Mar  8 11:27:43 ITX000c292c3c8d kernel: iscsi_queuecommand: opcode 3b
>> request_bufflen 32896 transfersize 32896
>>     
>
> Did you add your own output? Could you enable iscsi debugging? What
> kernel is this with and what versions of open-iscsi (upstream or svn or
> tarball release)?
>   
No custom output, all of this is from scsi (SCSI_LOG_TIMEOUT=5) and
open-iscsi (DEBUG_SCSI enabled). I thought I mentioned this in an
earlier mail -  the kernel is 2.6.19, but the open-iscsi drivers and
utils are from the 2.0-754 tarball.

I'm not sure what other debugging to enable in open-iscsi. Are you
talking about DEBUG_TCP or iscsid's debug? If you think it'll help, I
can enable them and try again. Has anyone tried to reproduce this
behavior independently though, maybe with a dummy LLD of some sort?

Aravind.
