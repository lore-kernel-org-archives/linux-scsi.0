From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] hpsa: fix potential resource leak
Date: Fri, 07 Nov 2014 13:49:58 +0100
Message-ID: <545CBFF6.3000401@redhat.com>
References: <1415363276-9765-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaKGMuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 07:50:04 -0500
In-Reply-To: <1415363276-9765-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Elliott@hp.com, brace77070@gmail.com

My apologies for sending the same mail twice.

Please ignore this one.

--tms


On 11/07/2014 01:27 PM, Tomas Henzl wrote:

> We should free the cfgtable allocated a few lines above.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1ce2b43608..7d4cef779f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5994,7 +5994,7 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
>  	}
>  	rc = write_driver_ver_to_cfgtable(cfgtable);
>  	if (rc)
> -		goto unmap_vaddr;
> +		goto unmap_cfgtable;
>  
>  	/* If reset via doorbell register is supported, use that.
>  	 * There are two such methods.  Favor the newest method.

