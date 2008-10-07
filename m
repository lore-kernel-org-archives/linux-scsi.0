From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [patch 09/17] ipr: use memory_read_from_buffer()
Date: Tue, 07 Oct 2008 13:50:07 -0500
Message-ID: <48EBAF5F.2000805@linux.vnet.ibm.com>
References: <200809222156.m8MLulrK032288@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49023 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYJGSuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 14:50:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m97IoLNP018314
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 14:50:21 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m97IoGXE203456
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 12:50:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m97InkUN005233
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 12:49:47 -0600
In-Reply-To: <200809222156.m8MLulrK032288@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, akinobu.mita@gmail.com, brking@us.ibm.com

Acked by: Brian King <brking@linux.vnet.ibm.com>

akpm@linux-foundation.org wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Brian King <brking@us.ibm.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/ipr.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff -puN drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer drivers/scsi/ipr.c
> --- a/drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer
> +++ a/drivers/scsi/ipr.c
> @@ -2456,20 +2456,14 @@ static ssize_t ipr_read_trace(struct kob
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
>  	unsigned long lock_flags = 0;
> -	int size = IPR_TRACE_SIZE;
> -	char *src = (char *)ioa_cfg->trace;
> -
> -	if (off > size)
> -		return 0;
> -	if (off + count > size) {
> -		size -= off;
> -		count = size;
> -	}
> +	ssize_t ret;
> 
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> -	memcpy(buf, &src[off], count);
> +	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
> +				IPR_TRACE_SIZE);
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> -	return count;
> +
> +	return ret;
>  }
> 
>  static struct bin_attribute ipr_trace_attr = {
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


