From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/7] make scsi_eh_try_stu use block timeout
Date: Sun, 30 Nov 2008 17:51:10 +0100
Message-ID: <4932C47E.7070203@s5r6.in-berlin.de>
References: <1228062746.4115.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60637 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbYK3Qvn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 11:51:43 -0500
In-Reply-To: <1228062746.4115.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>

James Bottomley wrote:
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -933,8 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
>  		int i, rtn = NEEDS_RETRY;
>  
>  		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> -			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> -						scmd->device->timeout, 0);
> +			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
>  
>  		if (rtn == SUCCESS)
>  			return 0;

Tested, works.  Thanks,
-- 
Stefan Richter
-=====-==--- =-== ====-
http://arcgraph.de/sr/
