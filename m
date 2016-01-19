From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 13/15] megaraid_sas: Introduce module parameter for SCSI
 command-timeout
Date: Tue, 19 Jan 2016 15:57:28 +0100
Message-ID: <569E4ED8.9010904@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-14-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbcASO5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 09:57:31 -0500
In-Reply-To: <1450445228-26571-14-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:27, Sumit Saxena wrote:
> This patch will introduce module-parameter for SCSI command timeout value and fix setting of resetwaitime beyond a value.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   15 ++++++++++++---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index cc843d6..316d5a0 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -83,7 +83,7 @@ module_param(throttlequeuedepth, int, S_IRUGO);
>  MODULE_PARM_DESC(throttlequeuedepth,
>  	"Adapter queue depth when throttled due to I/O timeout. Default: 16");
>  
> -int resetwaittime = MEGASAS_RESET_WAIT_TIME;
> +unsigned int resetwaittime = MEGASAS_RESET_WAIT_TIME;
>  module_param(resetwaittime, int, S_IRUGO);
>  MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O timeout "
>  		 "before resetting adapter. Default: 180");
> @@ -100,6 +100,10 @@ unsigned int dual_qdepth_disable;
>  module_param(dual_qdepth_disable, int, S_IRUGO);
>  MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
>  
> +unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
> +module_param(scmd_timeout, int, S_IRUGO);
> +MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");

When you know that "The RAID firmware may require extended timeouts" what do you expect
when an user sets a short timeout value ?
Other than that, I don't think that lot of tunables in a driver makes it better,
from my point of view you could remove both resetwaittime + scmd_timeout.
Okay, I don't want to stay in the way if you really need it so -

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

