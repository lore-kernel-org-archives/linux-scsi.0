From: Brian King <brking@us.ibm.com>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Thu, 16 Dec 2004 10:31:45 -0600
Message-ID: <41C1B871.2010504@us.ibm.com>
References: <41BF7C18.9090303@us.ibm.com> <20041215071852.GM3157@suse.de> <41C08CD5.10309@us.ibm.com> <41C0BE3E.3060003@us.ibm.com> <20041216063218.GA22982@suse.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:18612 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261397AbULPQbu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 11:31:50 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBGGVkFJ541998
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 11:31:46 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBGGVkBw420766
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 09:31:46 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBGGVjGi005675
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 09:31:46 -0700
In-Reply-To: <20041216063218.GA22982@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Dec 15 2004, Brian King wrote:
> 
>>Brian King wrote:
>>
>>>>It was added to be able to find out which opcode was rejected and thus
>>>>caused an application malfunction. It dumps the specific opcode only
>>>>once, is that such a huge problem?
>>>
>>>
>>>Ok. I didn't realize that it was only dumped once. That's not as bad. I 
>>>guess it might be better if it were only dumped if the op actually failed.
>>
>>How about something like this...
> 
> 
>>Currently if an SG_IO ioctl is issued to a block device with an
>>unknown opcode, an error is logged. This error is logged regardless
>>the device successfully processes the command or not. This results in
>>an error getting logged for each unknown opcode ever issued. This patch
>>changes this policy and only prints the unknown opcode if the command
>>fails.
> 
> 
> How about just moving it after the CAP_SYS_RAWIO check, so that it only
> logs for commands we explicitly reject? The purpose of the opcode dump
> is not to log failed commands (the app should do that itself), but
> mainly why a specific opcode was _not_ sent to the drive. This is
> something you cannot always directly gauge, unless you have the source
> for the app. And even then you have to dig :-)

I guess that would make more sense. Patch looks good.

Thanks

-Brian

> 
> ===== drivers/block/scsi_ioctl.c 1.62 vs edited =====
> --- 1.62/drivers/block/scsi_ioctl.c	2004-11-20 01:50:56 +01:00
> +++ edited/drivers/block/scsi_ioctl.c	2004-12-16 07:30:39 +01:00
> @@ -199,14 +199,14 @@
>  			return 0;
>  	}
>  
> +	/* And root can do any command.. */
> +	if (capable(CAP_SYS_RAWIO))
> +		return 0;
> +
>  	if (!(type & CMD_WARNED)) {
>  		cmd_type[cmd[0]] = CMD_WARNED;
>  		printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
>  	}
> -
> -	/* And root can do any command.. */
> -	if (capable(CAP_SYS_RAWIO))
> -		return 0;
>  
>  	/* Otherwise fail it with an "Operation not permitted" */
>  	return -EPERM;
> 
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
