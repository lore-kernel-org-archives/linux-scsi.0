From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Mon, 02 Apr 2007 08:38:18 -0500
Message-ID: <4611074A.30706@us.ibm.com>
References: <11751999513070-patch-mail.ibm.com> <1175445379.27675.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36468 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416AbXDBNiZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 09:38:25 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l32DcNNY006141
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 09:38:23 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l32DcNpO185906
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 07:38:23 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l32DcMQu000537
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 07:38:22 -0600
In-Reply-To: <1175445379.27675.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

James Bottomley wrote:
> On Thu, 2007-03-29 at 15:25 -0500, Brian King wrote:
> This is pretty much an open coded for loop ... how about just doing a
> for loop as attached below?

Fine by me. I was simply coding it up to look like scsi_eh_tur.

Thanks,

Brian

> 
> The two advantages to this are:
> 
>      1. it's cleaner and more readable
>      2. the compiler knows how to optimize it better
> 
> James
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 7a1a1bb..28a266c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -932,10 +932,12 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
>  	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
> 
>  	if (scmd->device->allow_restart) {
> -		int rtn;
> +		int i, rtn = NEEDS_RETRY;
> +
> +		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> +			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> +						START_UNIT_TIMEOUT, 0);
> 
> -		rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> -					START_UNIT_TIMEOUT, 0);
>  		if (rtn == SUCCESS)
>  			return 0;
>  	}
> 
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
