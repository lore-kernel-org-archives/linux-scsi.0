From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 1/2] SRP transport: Move queuecommand() wait code to SCSI
 core
Date: Sat, 26 Nov 2016 01:21:53 +0200
Message-ID: <0187d160-5985-32c4-95c0-466c4f09bdf9@mellanox.com>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
 <649cb037-3196-df4d-0d31-47f040ce44a2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db5eur01on0051.outbound.protection.outlook.com ([104.47.2.51]:20408
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750783AbcKZJC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Nov 2016 04:02:56 -0500
In-Reply-To: <649cb037-3196-df4d-0d31-47f040ce44a2@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>



On 11/23/2016 2:17 AM, Bart Van Assche wrote:
> Additionally, rename srp_wait_for_queuecommand() into
> scsi_wait_for_queuecommand() and add a comment about the
> queuecommand() call from scsi_send_eh_cmnd().
>
> Note: this patch changes scsi_internal_device_block from a function
> that did not sleep into a function that may sleep. This is fine for
> all callers of this function:
> * scsi_internal_device_block() is called from the mpt3sas device while
>   that driver holds the ioc->dm_cmds.mutex. This means that the mpt3sas
>   driver calls this function from thread context.
> * scsi_target_block() is called by __iscsi_block_session() from
>   kernel thread context and with IRQs enabled.
> * The SRP transport code also calls scsi_target_block() from kernel
>   thread context while sleeping is allowed.
> * The snic driver also calls scsi_target_block() from a context from
>   which sleeping is allowed. The scsi_target_block() call namely occurs
>   immediately after a scsi_flush_work() call.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: James Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Doug Ledford <dledford@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c           | 41 +++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/scsi_transport_srp.c | 41 ++++++---------------------------------
>  2 files changed, 45 insertions(+), 37 deletions(-)
>


> +
> +/**
> + * scsi_wait_for_queuecommand() - wait for ongoing queuecommand() calls
> + * @shost: SCSI host pointer.

the arg is sdev.

> + *
> + * Wait until the ongoing shost->hostt->queuecommand() calls that are
> + * invoked from scsi_request_fn() have finished.
> + */
> +static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
> +{
> +	WARN_ON_ONCE(sdev->host->use_blk_mq);
> +
> +	while (scsi_request_fn_active(sdev))
> +		msleep(20);
> +}
> +
> +/**
>   *	scsi_device_quiesce - Block user issued commands.
