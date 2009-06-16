From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: fix duplicate host number
Date: Tue, 16 Jun 2009 19:01:30 +0200
Message-ID: <4A37CFEA.3070106@s5r6.in-berlin.de>
References: <20090616062214.15969.55575.stgit@savbu-fcoe15.qa.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50810 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZFPRBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 13:01:42 -0400
In-Reply-To: <20090616062214.15969.55575.stgit@savbu-fcoe15.qa.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org

Joe Eykholt wrote:
> Subtract 1, so that scsi_host still starts with 0.
...
> -static int scsi_host_next_hn;		/* host_no for next new host */
> +static atomic_t scsi_host_next_hn;	/* host_no for next new host */
>  
>  
>  static void scsi_host_cls_release(struct device *dev)
> @@ -333,7 +333,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  
>  	mutex_init(&shost->scan_mutex);
>  
> -	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
> +	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;

Can also be written

static atomic_t scsi_host_next_hn = ATOMIC_INIT(-1);
...
	shost->host_no = atomic_inc_return(&scsi_host_next_hn);
-- 
Stefan Richter
-=====-==--= -==- =----
http://arcgraph.de/sr/
