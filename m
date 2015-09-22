From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 20/30] cxlflash: Correct usage of scsi_host_put()
Date: Tue, 22 Sep 2015 15:53:06 -0500
Message-ID: <5601BFB2.4010308@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442439049-49970-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41320 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703AbbIVUxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2015 16:53:13 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 22 Sep 2015 14:53:13 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id E6212C9003C
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 16:44:12 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8MKr9kf50200768
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 20:53:09 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8MKr7cV028843
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 16:53:09 -0400
In-Reply-To: <1442439049-49970-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:30 PM, Matthew R. Ochs wrote:
> Currently, scsi_host_put() is being called prematurely in the
> remove path and is missing entirely in an error cleanup path.
> The former can lead to memory being freed too early with
> subsequent access potentially corrupting data whilst the former
> would result in a memory leak.
> 
> Move the usage on remove to be the last cleanup action taken
> and introduce a call to scsi_host_put() in the one initialization
> error path that does not use remove to cleanup.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index fc77cd4..1856a73 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -734,7 +734,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
>  	case INIT_STATE_SCSI:
>  		cxlflash_term_local_luns(cfg);
>  		scsi_remove_host(cfg->host);
> -		scsi_host_put(cfg->host);
>  		/* Fall through */
>  	case INIT_STATE_AFU:
>  		term_afu(cfg);
> @@ -744,6 +743,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
>  	case INIT_STATE_NONE:
>  		flush_work(&cfg->work_q);
>  		free_mem(cfg);
> +		scsi_host_put(cfg->host);
>  		break;
>  	}
> 
> @@ -2415,6 +2415,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
>  		dev_err(&pdev->dev, "%s: call to scsi_host_alloc failed!\n",

This message text is wrong. Its the call to alloc_mem that has failed in this
leg, not the call to scsi_host_alloc.

>  			__func__);
>  		rc = -ENOMEM;
> +		scsi_host_put(cfg->host);
>  		goto out;
>  	}
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

