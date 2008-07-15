From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: scsi_host_alloc does not check for used shost->host_no
Date: Tue, 15 Jul 2008 15:16:28 -0500
Message-ID: <487D059C.60400@linux.vnet.ibm.com>
References: <48775DCD.5010202@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:38213 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762112AbYGOUQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 16:16:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FKGkc3015040
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 16:16:46 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FKGh5S134158
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 14:16:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FKGgWl020144
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 14:16:42 -0600
In-Reply-To: <48775DCD.5010202@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Daniel Debonzi wrote:
> Hi everyone,
> 
> First of all, it is the first time I am sending something to one of the
> kernel mail lists. So, if it is not the right place for that, if it is
> not the only place for that, or I am doing something wrong, or wherever,
> please, just let me know.

A couple of comments regarding patch submission..

1. Read Documentation/SubmittingPatches and follow the guidelines contained
   within regarding patch format.
2. Subject should be something like:
	[PATCH] SCSI: scsi_host_alloc does not check for used shost->host_no

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index c6457bf..2e191f4 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -310,7 +310,7 @@ struct device_type scsi_host_type = {
>   **/
>  struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  {
> -	struct Scsi_Host *shost;
> +	struct Scsi_Host *shost, *tmp_shost;
>  	gfp_t gfp_mask = GFP_KERNEL;
>  	int rval;
> 
> @@ -332,7 +332,18 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
> 
>  	mutex_init(&shost->scan_mutex);
> 
> +	/* 
> +	 * Look if host_no is not been used somewhere else. Is is used to
> +	 * happen when scsi_host_next_hn overflows and goes back to 0.
> +	 */
> + host_no_already_exists:
>  	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
> +        if(!IS_ERR(tmp_shost = scsi_host_lookup(shost->host_no)))
> +          {

This needs to follow Documentation/CodingStyle, in this particular case, K&R braces.

> +            scsi_host_put(tmp_shost);
> +            goto host_no_already_exists;
> +          }
> +

Do we need to worry about a host in the SHOST_DEL state? In that case, it will still
exist to some degree, but scsi_host_get will fail. For example, what happens if a
shell is in /sys/class/scsi_host/host5/ and you delete host 5 and try to add another.
Couldn't you run into the same problem? In that case the scsi_host_get will fail.
I suppose you could check specifically for -ENXIO getting returned...

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
