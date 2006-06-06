From: Vasily Averin <vvs@sw.ru>
Subject: Re: [SCSI] 3w-9xxx: kmap_atomic in twa_scsiop_execute_scsi
Date: Tue, 06 Jun 2006 09:49:44 +0400
Message-ID: <44851778.7010107@sw.ru>
References: <DB599F406D04E34389140B7D99C71B1B0203D625@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:18219 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S932106AbWFFFq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2006 01:46:27 -0400
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B0203D625@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: adam radford <aradford@gmail.com>, linuxraid <linuxraid@amcc.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, devel@openvz.org, Andrew Morton <akpm@osdl.org>

Adam Radford wrote:
> Vasily,
> 
> I actually didn't forget this.  I think it isn't needed.  The reason
> being
> that in scsi.c: scsi_dispatch_command(), where hostt->queuecommand() is
> called,
> there is a spin_lock_irqsave()/spin_unlock_irqrestore() wrapper in
> there, disabling
> interrupts.

Adam,

I'm agree that queuecommand() executed with disabled interrupts. However
twa_scsiop_execute_scsi() can be called not only from queuecommand. For example,

twa_interrupts (note: with _enabled_ interrupts)
   twa_aen_read_queue
     twa_scsiop_execute_scsi

or

twa_chrdev_ioctl
   twa_reset_device_extension
      twa_reset_sequence
         twa_aen_drain_queue
            twa_scsiop_execute_scsi

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team

> -----Original Message-----
> From: Vasily Averin [mailto:vvs@sw.ru] 
> Sent: Sunday, June 04, 2006 1:49 AM
> To: adam radford; linuxraid
> Cc: James Bottomley; Linux Kernel Mailing List;
> linux-scsi@vger.kernel.org; devel@openvz.org; Andrew Morton
> Subject: [SCSI] 3w-9xxx: kmap_atomic in twa_scsiop_execute_scsi
> 
> Hello Adam,
> 
> you have fixed recently potential memory corruption, kmap_atomic issue
> in 3w-9xxx driver, however it seems for me you have forgotten to fix the
> same issue in yet another similar place, in twa_scsiop_execute_scsi()
> function.
> 
> Signed-off-by: Vasily Averin <vvs@sw.ru>
> 
> Thank you,
> 	Vasily Averin
> 
> SWsoft Virtuozzo/OpenVZ Linux kernel team
> 
> 

