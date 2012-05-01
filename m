From: Andi Shyti <andi.shyti@gmail.com>
Subject: Re: [PATCH 07/17] hpsa: do not give up retry of driver cmds after
 only 3 retries
Date: Tue, 1 May 2012 19:26:34 +0200
Message-ID: <20120501172634.GA11302@andi>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
 <20120501164240.11705.10308.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57725 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2EAR0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 13:26:47 -0400
Content-Disposition: inline
In-Reply-To: <20120501164240.11705.10308.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

Hi,

> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1380,17 +1380,24 @@ static void hpsa_scsi_do_simple_cmd_core_if_no_lockup(struct ctlr_info *h,
>  	}
>  }
>  
> +#define MAX_DRIVER_CMD_RETRIES 25
>  static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
>  	struct CommandList *c, int data_direction)
>  {
> -	int retry_count = 0;
> +	int backoff_time = 10, retry_count = 0;
>  
>  	do {
>  		memset(c->err_info, 0, sizeof(*c->err_info));
>  		hpsa_scsi_do_simple_cmd_core(h, c);
>  		retry_count++;
> +		if (retry_count > 3) {
> +			msleep(backoff_time);

for 10ms isn't it better to avoid using msleep?

Andi

> +			if (backoff_time < 1000)
> +				backoff_time *= 2;
> +		}
>  	} while ((check_for_unit_attention(h, c) ||
> -			check_for_busy(h, c)) && retry_count <= 3);
> +			check_for_busy(h, c)) &&
> +			retry_count <= MAX_DRIVER_CMD_RETRIES);
>  	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
>  }
