From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] bnx2fc: Add driver tunables.
Date: Fri, 01 Apr 2016 15:56:15 +0200
Message-ID: <c1a2f3b08c8e334a29e82fbee6843f9d@suse.de>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
 <1459516223-32106-2-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbcDAN4S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 09:56:18 -0400
In-Reply-To: <1459516223-32106-2-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-04-01 15:10, Chad Dupuis wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
> 
> Per customer request, add the following driver tunables:
> 
> o devloss_tmo
> o max_luns
> o queue_depth
> o tm_timeout
> 
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 38 
> +++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/bnx2fc/bnx2fc_io.c   |  4 +++-
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index d7029ea..600c29d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -107,6 +107,26 @@ MODULE_PARM_DESC(debug_logging,
>  		"\t\t0x10 - fcoe L2 fame related logs.\n"
>  		"\t\t0xff - LOG all messages.");
> 
> +uint bnx2fc_devloss_tmo;
> +module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
> +MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote 
> ports "
> +	"attached via bnx2fc.");
> +
> +uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
> +module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
> +MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI
> host. Default "
> +	"0xffff.");
> +
> +uint bnx2fc_queue_depth;
> +module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
> +MODULE_PARM_DESC(queue_depth, " Change the default queue depth of
> SCSI devices "
> +	"attached via bnx2fc.");
> +
> +uint bnx2fc_tm_timeout = BNX2FC_TM_TIMEOUT;
> +module_param_named(tm_timeout, bnx2fc_tm_timeout, uint, 
> S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(tm_timeout, " Change the default timeout for "
> +	"task management commands. Default 60 seconds.");
> +

Just a question, can't this be made dynamically adjustable via sysfs 
instead of a module parameter?

