From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 7/8] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Wed, 23 Oct 2013 17:30:57 +0800
Message-ID: <52679751.2040309@cn.fujitsu.com>
References: <1382518282-107606-1-git-send-email-hare@suse.de> <1382518282-107606-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab3JWJaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 05:30:12 -0400
In-Reply-To: <1382518282-107606-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

Hi, Hannes:

On 10/23/2013 04:51 PM, Hannes Reinecke wrote:
> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
> host which limits the overall runtime of the SCSI EH.
> The 'eh_deadline' value is stored in the now obsolete field
> 'resetting'.
> When a command is failed the start time of the EH is stored
> in 'last_reset'. If the overall runtime of the SCSI EH is longer
> than last_reset + eh_deadline, the EH is short-circuited and
> falls through to issue a host reset only.
>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> ---
>   drivers/scsi/hosts.c      |   7 +++
>   drivers/scsi/scsi_error.c | 130 +++++++++++++++++++++++++++++++++++++++++++---
>   drivers/scsi/scsi_sysfs.c |  37 +++++++++++++
>   include/scsi/scsi_host.h  |   4 +-
>   4 files changed, 170 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index df0c3c7..f334859 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -316,6 +316,12 @@ static void scsi_host_dev_release(struct device *dev)
>   	kfree(shost);
>   }
>
> +static unsigned int shost_eh_deadline;
> +
> +module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(eh_deadline,
> +		 "SCSI EH timeout in seconds (should be between 1 and 2^32-1)");

Sorry, didn't consider '0' as the minimum valid value as we talked on
Oct 9?

Thanks,
Ren

<snip>
> +	int eh_deadline;
>   	unsigned long last_reset;
>
>   	/*

