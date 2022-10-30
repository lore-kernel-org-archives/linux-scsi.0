Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3470AFA3742
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Oct 2022 08:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJ3IRQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Oct 2022 04:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3IRO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2022 04:17:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110DCC0A;
        Sun, 30 Oct 2022 01:17:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91DFB68BEB; Sun, 30 Oct 2022 09:17:08 +0100 (CET)
Date:   Sun, 30 Oct 2022 09:17:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v3 09/19] nvme: Add pr_ops read_keys support
Message-ID: <20221030081708.GA4774@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com> <20221026231945.6609-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026231945.6609-10-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 26, 2022 at 06:19:35PM -0500, Mike Christie wrote:
> This patch adds support for the pr_ops read_keys callout by calling the
> NVMe Reservation Report helper, then parsing that info to get the
> controller's registered keys. Because the callout is only used in the
> kernel where the callers do not know about controller/host IDs, the
> callout just returns the registered keys which is required by the SCSI PR
> in READ KEYS command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/nvme/host/pr.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/nvme.h   |  4 +++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> index aa88c55879b2..df7eb2440c67 100644
> --- a/drivers/nvme/host/pr.c
> +++ b/drivers/nvme/host/pr.c
> @@ -118,10 +118,83 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
>  	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
>  }
>  
> +static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
> +		u32 data_len, bool *eds)

Is there any good reason this method seems to take a u8 instead of a void
pointer?  As that seems to make a few things a bit messy.

> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
> +	else
> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
> +					      data, data_len);

Can you please add a hlper for this logic?

> +	for (i = 0; i < num_ret_keys; i++) {
> +		if (eds) {
> +			keys_info->keys[i] =
> +					le64_to_cpu(status->regctl_eds[i].rkey);
> +		} else {
> +			keys_info->keys[i] =
> +					le64_to_cpu(status->regctl_ds[i].rkey);
> +		}

If you shorten the status variable name to something like rs this becomes
much easier to follow :)
