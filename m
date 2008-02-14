From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Wed, 13 Feb 2008 16:04:17 -0800
Message-ID: <20080214000417.GA2741@tpepper-t42p.dolavim.us>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us> <532ABFBDAAC3A34EB12EBA6CEC2838F439964688@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60804 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYBNAEw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 19:04:52 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1E04JhQ017868
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 19:04:19 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1E04JAE167994
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 19:04:19 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1E04IMb019739
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2008 19:04:19 -0500
Content-Disposition: inline
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F439964688@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mark_Salyzyn@adaptec.com

(replaced missing cc's including linux-scsi)

On Wed 13 Feb at 14:39:07 -0800 Mark_Salyzyn@adaptec.com said:
> 
> - Is the command path code even reaching the controller's processor inquiry
>   spoofing section?
> 
>                 if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
>                 IPS_SCSI_INQ_DATA inquiry;
> 
>                 memset(&inquiry, 0,
>                sizeof (IPS_SCSI_INQ_DATA));
> 
>                 inquiry.DeviceType =
>                     IPS_SCSI_INQ_TYPE_PROCESSOR;

I just added printk's in ips_send_cmd()'s INQUIRY case just before
the above condition test and just within the conditional block.
Neither showed on the console.

> The target_id check may be flawed? It is not using the
> scmd/sdev accessors and could be the wrong value as a result. Wild goose
> since arrays are working correctly (?)

In the original case the arrays appeared to be working correctly although
we were worried.  In the repro case we don't actually have any disk
attached...Forgot to mention that in the original email.

> - There appears to be a missing 'break' statement for the START_STOP command
>   immediately preceding the TEST_UNIT_READY/INQUIRY cases. What are the side
>   effects of that? It appears to be innocuous.

No change noted with the missing break added.

> - ips_scmd_buf_write is used for array capacity and other fiddly bits and
>   must be functioning correctly (?), so I can NOT harm it's functionality
>   except to question if the kmap_atomic returned a non-null value, it's
>   return value apparently is not checked. It's failure could speak of
>   problem(s) elsewhere.

I've got a printk there and haven't seen any output from it.  Haven't seen
anything from any of the printk's I've tried actually before:

In the run above to check if ips_send_cmd() hits the condition you were
curious about...I did capture the following from printk's I added in
ips_allocatescbs():

pci_alloc_consistent returns ha->scbs    @ 0x18446604437762007040
pci_alloc_consistent returns ips_sg.list @ 0x18446604437762002944
pci_alloc_consistent returns ha->scbs    @ 0x18446604437698871296
pci_alloc_consistent returns ips_sg.list @ 0x18446604437756837888

I take that as ips_init_phase2() being called and presumable returning
SUCCESS.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
