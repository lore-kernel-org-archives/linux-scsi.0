Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A667C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1E1224D1
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502384AbgLNRzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:55:00 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:48555 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438375AbgLNRy4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 12:54:56 -0500
Received: from [192.168.0.6] (ip5f5af462.dynamic.kabel-deutschland.de [95.90.244.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id ACB402064787B;
        Mon, 14 Dec 2020 18:54:08 +0100 (CET)
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
To:     Don Brace <don.brace@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Justin.Lindley@microchip.com,
        Scott Benesh <scott.benesh@microchip.com>,
        gerry.morong@microchip.com,
        Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
        hch@infradead.org, joseph.szczypek@hpe.com, POSWALD@suse.com,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        Donald Buczek <buczek@molgen.mpg.de>,
        Greg KH <gregkh@linuxfoundation.org>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
Date:   Mon, 14 Dec 2020 18:54:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160763254769.26927.9249430312259308888.stgit@brunhilda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don, dear Mahesh,


Am 10.12.20 um 21:35 schrieb Don Brace:
> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> 
> * Correct scsi-mid-layer sending more requests than
>    exposed host Q depth causing firmware ASSERT issue.
>    * Add host Qdepth counter.

This supposedly fixes the regression between Linux 5.4 and 5.9, which we 
reported in [1].

     kernel: smartpqi 0000:89:00.0: controller is offline: status code 
0x6100c
     kernel: smartpqi 0000:89:00.0: controller offline

Thank you for looking into this issue and fixing it. We are going to 
test this.

For easily finding these things in the git history or the WWW, it would 
be great if these log messages could be included (in the future).

Also, that means, that the regression is still present in Linux 5.10, 
released yesterday, and this commit does not apply to these versions.

Mahesh, do you have any idea, what commit caused the regression and why 
the issue started to show up?

James, Martin, how are regressions handled for the SCSI subsystem?

Regarding the diff, personally, I find the commit message much too 
terse. `pqi_scsi_queue_command()` will return `SCSI_MLQUEUE_HOST_BUSY` 
for the case of too many requests. Will that be logged by Linux in some 
log level? In my opinion it points to a performance problem, and should 
be at least logged as a notice or warning.

Can `ctrl_info->scsi_ml_can_queue` be queried somehow maybe in the logs? 
`sudo find /sys -name queue` did not display something interesting.

[1]: https://marc.info/?l=linux-scsi&m=160271263114829&w=2
      "Linux 5.9: smartpqi: controller is offline: status code 0x6100c"

> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi.h      |    2 ++
>   drivers/scsi/smartpqi/smartpqi_init.c |   19 ++++++++++++++++---
>   2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index 0b94c755a74c..c3b103b15924 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1345,6 +1345,8 @@ struct pqi_ctrl_info {
>   	struct work_struct ofa_quiesce_work;
>   	u32		ofa_bytes_requested;
>   	u16		ofa_cancel_reason;
> +
> +	atomic_t	total_scmds_outstanding;
>   };

What is the difference between the already existing

     atomic_t scsi_cmds_outstanding;

and the new counter?

     atomic_t	total_scmds_outstanding;

The names are quite similar, so different names or a comment might be 
useful.

>   
>   enum pqi_ctrl_mode {
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 082b17e9bd80..4e088f47d95f 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -5578,6 +5578,8 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
>   void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
>   {
>   	struct pqi_scsi_dev *device;
> +	struct pqi_ctrl_info *ctrl_info;
> +	struct Scsi_Host *shost;
>   
>   	if (!scmd->device) {
>   		set_host_byte(scmd, DID_NO_CONNECT);
> @@ -5590,7 +5592,11 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
>   		return;
>   	}
>   
> +	shost = scmd->device->host;

The function already has a variable `device`, which is assigned 
“hostdata” though:

     device = scmd->device->hostdata;

This confuses me. Maybe this should be cleaned up in a followup commit, 
and the variable device be reused above in the `shost` assignment.

> +	ctrl_info = shost_to_hba(shost);
> +
>   	atomic_dec(&device->scsi_cmds_outstanding);
> +	atomic_dec(&ctrl_info->total_scmds_outstanding);
>   }
>   
>   static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
> @@ -5678,6 +5684,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
>   	bool raid_bypassed;
>   
>   	device = scmd->device->hostdata;
> +	ctrl_info = shost_to_hba(shost);
>   
>   	if (!device) {
>   		set_host_byte(scmd, DID_NO_CONNECT);
> @@ -5686,8 +5693,11 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
>   	}
>   
>   	atomic_inc(&device->scsi_cmds_outstanding);
> -
> -	ctrl_info = shost_to_hba(shost);

I believe, style changes (re-ordering) in commits fixing regressions 
make it harder to backport it.

> +	if (atomic_inc_return(&ctrl_info->total_scmds_outstanding) >
> +		ctrl_info->scsi_ml_can_queue) {
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
>   
>   	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
>   		set_host_byte(scmd, DID_NO_CONNECT);
> @@ -5730,8 +5740,10 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
>   	}
>   
>   out:
> -	if (rc)
> +	if (rc) {
>   		atomic_dec(&device->scsi_cmds_outstanding);
> +		atomic_dec(&ctrl_info->total_scmds_outstanding);
> +	}
>   
>   	return rc;
>   }
> @@ -8054,6 +8066,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
>   
>   	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
>   	atomic_set(&ctrl_info->num_interrupts, 0);
> +	atomic_set(&ctrl_info->total_scmds_outstanding, 0);
>   
>   	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
>   	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);


Kind regards,

Paul
