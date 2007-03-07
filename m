From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Tue, 06 Mar 2007 16:01:52 -0800
Message-ID: <45EE00F0.2010702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:27627 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030743AbXCGABz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 19:01:55 -0500
Received: by nz-out-0506.google.com with SMTP id s1so2309749nze
        for <linux-scsi@vger.kernel.org>; Tue, 06 Mar 2007 16:01:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

While trying to fire WRITE BUFFER commands to an iscsi target, we found 
that if the command is larger than 32kB, it gets rounded up to the next 
sector before it reaches the LLD (in this case, open-iscsi). If this is 
expected behavior, please disregard the rest of the message. 
Unfortunately, I haven't found any documentation that mandates 
sector-multiple sizes for SG_IO ioctls, and besides,  the above behavior 
seems to have been introduced recently (post 2.6.12). The above scenario 
was produced in 2.6.19.2 (a Fedora update kernel, actually).

Here is the relevant log section for a command with dxfer_len 32896 
bytes, with SCSI_LOG_TIMEOUT=5 and DEBUG_SCSI enabled in open-iscsi:

Mar  5 12:39:12 ITX003048865470 kernel: sg_ioctl: sg4, cmd=0x2285
Mar  5 12:39:12 ITX003048865470 kernel: sg_common_write:  scsi 
opcode=0x3b, cmd_size=10
Mar  5 12:39:12 ITX003048865470 kernel: sg_start_req: dxfer_len=32896
Mar  5 12:39:12 ITX003048865470 kernel: sg_build_indirect: 
buff_size=32896, blk_size=33280
Mar  5 12:39:12 ITX003048865470 kernel: sg_write_xfer: num_xfer=32896, 
iovec_count=0, k_use_sg=2
Mar  5 12:39:12 ITX003048865470 kernel: iscsi: cmd [itt 0x23 total 33280 
imm_data 33280 unsol count 0, unsol offset 33280]
Mar  5 12:39:12 ITX003048865470 kernel: iscsi: ctask enq [write cid 0 sc 
e5ffcb00 cdb 0x3b itt 0x23 len 33280 cmdsn 36 win 257]
Mar  5 12:39:12 ITX003048865470 kernel: iscsi: ctask deq [cid 0 xmstate 
2 itt 0x23]
Mar  5 12:39:12 ITX003048865470 kernel:  connection0:0: iscsi: detected 
conn error (1011)
Mar  5 12:39:12 ITX003048865470 kernel: iscsi: blocking session
Mar  5 12:39:12 ITX003048865470 kernel: iscsi: failing in progress sc 
e5ffcb00 itt 0x23
Mar  5 12:39:12 ITX003048865470 kernel: sg_cmd_done: sg4, pack_id=0, 
res=0x20000Mar  5 12:39:12 ITX003048865470 kernel: sg_finish_rem_req: 
res_used=0
Mar  5 12:39:12 ITX003048865470 kernel: sg_remove_scat: k_use_sg=2

The first print from open-iscsi is from inside its queuecommand, and it 
shows that the scsi_cmnd->request_bufflen is 33280 ("total 33280"). When 
I tried the same experiment with 2.6.12, the number matched the dxfer_len.

In fact, even with the newer kernel, all commands smaller than 32k make 
it through with the right size, which leads me to think it's something 
to do with the scatter-gather list. I'm not particularly familiar with 
the scsi code, but inside scsi_execute_async, in scsi_map_req_sg, should 
the request's data_len be set to the dxfer_len instead of summing up the 
scatter-gather list lengths? I must mention again that I haven't really 
gone through the code thoroughly.

Anyway, the above behavior leads to a problem with open-iscsi - it fills 
in a pdu with the Data Segment Length equal to the sector-rounded 
number, while the cdb contains the original dxfer_len. The target uses 
the cdb's value to allocate buffers for the command, so it fails to 
receive the whole packet. Any help would be appreciated. Thanks,


Aravind.

