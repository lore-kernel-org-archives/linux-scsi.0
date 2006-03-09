From: Brian King <brking@us.ibm.com>
Subject: Re: two leaks in scsi_alloc_sdev failure paths
Date: Thu, 09 Mar 2006 09:07:34 -0600
Message-ID: <441044B6.3000802@us.ibm.com>
References: <20060309033620.GA19906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32444 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751901AbWCIPHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 10:07:40 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k29F7d43021096
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 10:07:39 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k29F7d8D109458
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 10:07:39 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k29F7cO6009892
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 10:07:39 -0500
In-Reply-To: <20060309033620.GA19906@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

Dave Jones wrote:
> If the scsi_alloc_queue or the slave_alloc calls in scsi_alloc_device fail,
> we forget to release the locally allocated sdev on the failure path.

Actually, I think the slave_alloc failure path works today, and this patch
breaks it. Today, in the slave_alloc failure path, the release function called
as a result of the put_device in out_device_destroy should end up freeing the
sdev. Your patch will result in a double free in this path.

> --- linux-2.6/drivers/scsi/scsi_scan.c~	2006-03-08 22:28:50.000000000 -0500
> +++ linux-2.6/drivers/scsi/scsi_scan.c	2006-03-08 22:31:38.000000000 -0500
> @@ -252,7 +252,7 @@ static struct scsi_device *scsi_alloc_sd
>  		/* release fn is set up in scsi_sysfs_device_initialise, so
>  		 * have to free and put manually here */
>  		put_device(&starget->dev);
> -		goto out;
> +		goto out_free;

Rather than this change, I think just adding a kfree(sdev) before the goto out would
accomplish what you want.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
