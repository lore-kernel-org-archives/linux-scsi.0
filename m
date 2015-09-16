From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] target: Fix target_sense_desc_format NULL pointer
 dereference
Date: Wed, 16 Sep 2015 15:08:34 +0300
Message-ID: <55F95BC2.8090104@dev.mellanox.co.il>
References: <1442385079-749-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36829 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbIPMId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 08:08:33 -0400
Received: by wicgb1 with SMTP id gb1so70837302wic.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 05:08:32 -0700 (PDT)
In-Reply-To: <1442385079-749-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

On 9/16/2015 9:31 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch allows target_sense_desc_format() to be called without a
> valid se_device pointer, which can occur during an early exception
> ahead of transport_lookup_cmd_lun() setting up se_cmd->se_device.
>
> This addresses a v4.3-rc1 specific NULL pointer dereference
> regression introduced by commit 4e4937e8.
>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_hba.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> index 9522960..22390e0 100644
> --- a/drivers/target/target_core_hba.c
> +++ b/drivers/target/target_core_hba.c
> @@ -187,5 +187,5 @@ core_delete_hba(struct se_hba *hba)
>
>   bool target_sense_desc_format(struct se_device *dev)
>   {
> -	return dev->transport->get_blocks(dev) > U32_MAX;
> +	return (dev) ? dev->transport->get_blocks(dev) > U32_MAX : false;
>   }
>

Can we be sure that the only case we'll call target_sense_desc_format()
with a NULL se_device will be when returning a CHECK_CONDITION on a
non-existing LUN?

We return the sense format in the D_SENSE of the control modepage
response and if some future bug will happen to call this function with
a NULL se_device we might violate what we reported to the initiator.

Maybe we should enforce this by having transport_lookup_cmd_lun() set
se_cmd->se_device = TARGET_NON_EXISTENT_LUN reserved identifier and 
check for that rather then NULL?

Thoughts?
