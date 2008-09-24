From: David Miller <davem@davemloft.net>
Subject: Re: qlogicpti driver hangs the machine
Date: Wed, 24 Sep 2008 02:03:45 -0700 (PDT)
Message-ID: <20080924.020345.188819713.davem@davemloft.net>
References: <20080923.215302.152506074.davem@davemloft.net>
	<20080924.014553.221132445.davem@davemloft.net>
	<48DA01A6.1010807@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbYIXJD5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 05:03:57 -0400
In-Reply-To: <48DA01A6.1010807@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: matthew@wil.cx, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, jens.axboe@oracle.com

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 24 Sep 2008 12:00:22 +0300

> Subject: [PATCH] fix fall out of sg-chaining patch
> 
> I've reviewed all patches since Matthew's, and I find one small
> problem.
> 
> In the load_cmd() there is a compound loop where the first 4 sg's are
> set then the rest are set into a memory structure in group of 7 sg's.
> 
> Well the second 7-group and on is a bug because sg pointer does not advance.
> This is a fall out from Jens's patch.
> 
> I'm not sure if this is it but it should be fixed

Definitely a bug, and I looked at the patch that addded this code,
specifically audited this stuff, and didn't notice the problem. :-)

Meelis, see if this patch helps out your case, thanks!

> ---
> git diff --stat -p
>  drivers/scsi/qlogicpti.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index 4a1cf63..9053508 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -914,6 +914,7 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
>  				ds[i].d_count = sg_dma_len(s);
>  			}
>  			sg_count -= n;
> +			sg = s;
>  		}
>  	} else {
>  		cmd->dataseg[0].d_base = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
