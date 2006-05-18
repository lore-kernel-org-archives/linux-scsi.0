From: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>
Subject: dpt_i2o and sd driver's problem
Date: Thu, 18 May 2006 19:39:07 +0900
Message-ID: <20060518103556.AF7451C00B@mail2-sv.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:3543 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S1750811AbWERKgA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 06:36:00 -0400
Received: from m9.gw.fujitsu.co.jp ([10.0.50.79])
        by fgwmail5.fujitsu.co.jp (Fujitsu Gateway)
        with ESMTP id k4IAZwb4022752 for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 19:35:58 +0900
        (envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from smail (m9 [127.0.0.1])
	by outgoing.m9.gw.fujitsu.co.jp (Postfix) with ESMTP id AE74A53C024
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 19:35:58 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (vs3.gw.fujitsu.co.jp [10.0.50.63])
	by m9.gw.fujitsu.co.jp (Postfix) with ESMTP id 6771324005F
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 19:35:58 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4 [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2E0491CC151
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 19:35:58 +0900 (JST)
Received: from mail2-sv.soft.fujitsu.com (smtp.soft.fujitsu.com [10.124.20.53])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 023BD1CC149
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 19:35:57 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com

Dear Mark,

When I was using MO device , following messages showed in
our /var/log/messages.
The kernel version is kernel-2.6.16.16.

kernel: Cmd len 00001000 Cmd underflow 00000400

This messages is reported from dpt_i2o driver.
It is reported when request_bufflen member/underflow member
of the Scsi_Cmnd structure is not match.
---------------------------------------
dpt_i2o.c
static s32 adpt_scsi_to_i2o(adpt_hba* pHba,
                            Scsi_Cmnd* cmd, struct adpt_device* d)
{
                :
        len = cmd->request_bufflen;
                :
        if(cmd->underflow && len != cmd->underflow){
                printk(KERN_WARNING"Cmd len %08X Cmd underflow %08X\n",
                        len, cmd->underflow);
        }
                :
}
---------------------------------------

The request_bufflen member/underflow member is set in sd driver.
But, each sector size is not match except 512 bytes.
---------------------------------------
sd.c
static int sd_init_command(Scsi_Cmnd * SCpnt)
{
                :
        this_count = SCpnt->request_bufflen >> 9;
                :
        if (sdp->sector_size == 1024) {
                if ((block & 1) || (rq->nr_sectors & 1)) {
                        printk(KERN_ERR "sd: Bad block number requested");
                        return 0;
                } else {
                        block = block >> 1;
                        this_count = this_count >> 1;
                }
        }
        if (sdp->sector_size == 2048) {
                if ((block & 3) || (rq->nr_sectors & 3)) {
                        printk(KERN_ERR "sd: Bad block number requested");
                        return 0;
                } else {
                        block = block >> 2;
                        this_count = this_count >> 2;
                }
        }
        if (sdp->sector_size == 4096) {
                if ((block & 7) || (rq->nr_sectors & 7)) {
                        printk(KERN_ERR "sd: Bad block number requested");
                        return 0;
                } else {
                        block = block >> 3;
                        this_count = this_count >> 3;
                }
        }
                :
        SCpnt->underflow = this_count << 9;
}
---------------------------------------

There are no problem for the hard disk because of 512 bytes in the sector size.
But, when I tested MO media(1.3GB), the sector size was 2048 byte.

I have 2 questions.

1. I think the value of underflow is a calculation mistake.
   Is it true?

2. What is the purpose to compare the values of
   request_bufflen member/underflow member with dpt_i2o driver?


I'm not participated in the linux-scsi mailing list.
Please reply to the following addresses. 

    E-Mail : sakurai_hiro@soft.fujitsu.com

Best Regards
Hiroomi Sakurai



