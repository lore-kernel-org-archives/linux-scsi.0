From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCHv3 1/8] target: Add locking to some accesses to nacl.device_list
Date: Tue, 01 Jul 2014 10:48:10 +0200
Message-ID: <53B275CA.50002@redhat.com>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com> <1404171587-28845-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbaGAIsQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2014 04:48:16 -0400
In-Reply-To: <1404171587-28845-2-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

Hi Andy,

On 07/01/2014 01:39 AM, Andy Grover wrote:
> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
> index 101858e..5c9d980 100644
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c
> @@ -51,9 +51,12 @@ target_scsi3_ua_check(struct se_cmd *cmd)
>  	if (!nacl)
>  		return 0;
>  
> +	spin_lock_irq(&nacl->device_list_lock);
>  	deve = nacl->device_list[cmd->orig_fe_lun];
>  	if (!atomic_read(&deve->ua_count))
>  		return 0;
> +	spin_unlock_irq(&nacl->device_list_lock);
> +

Shouldn't the spinlock unlocked before the "return 0;" ?

Regards,
Maurizio Lombardi
