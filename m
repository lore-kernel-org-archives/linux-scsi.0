From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/9] target/iblock: Fix double bioset_integrity_free bug
Date: Mon, 07 Apr 2014 10:19:28 +0300
Message-ID: <53425180.7000403@dev.mellanox.co.il>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com> <1396517753-23546-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61681 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaDGHTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 03:19:34 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so5684278wib.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2014 00:19:33 -0700 (PDT)
In-Reply-To: <1396517753-23546-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch fixes a double free bug during IBLOCK backend shutdown
> where bioset_integrity_free() was incorrectly called ahead of
> bioset_free(), who is already making the same call directly.
>
> This bug was introduced with commit ecebbf6cc, and will end up
> triggering a general protection fault in iblock_free_device()
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Cc: <stable@vger.kernel.org> #3.14+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_iblock.c |    5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 554d4f7..9e0232c 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -203,10 +203,9 @@ static void iblock_free_device(struct se_device *dev)
>   
>   	if (ib_dev->ibd_bd != NULL)
>   		blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
> -	if (ib_dev->ibd_bio_set != NULL) {
> -		bioset_integrity_free(ib_dev->ibd_bio_set);
> +	if (ib_dev->ibd_bio_set != NULL)
>   		bioset_free(ib_dev->ibd_bio_set);
> -	}
> +
>   	kfree(ib_dev);
>   }
>   

Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
