From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH v2] ufs: adjust queue settings to PRDT limitations
Date: Fri, 11 Oct 2013 10:35:20 +0530
Message-ID: <CAKVbJB842FuzH28mt+mXG7DaAx-OLz5sh3X758=SYN+uOzkpmQ@mail.gmail.com>
References: <1380116852-21240-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47538 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3JKFFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Oct 2013 01:05:20 -0400
Received: by mail-qc0-f181.google.com with SMTP id q4so2635337qcx.12
        for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2013 22:05:20 -0700 (PDT)
In-Reply-To: <1380116852-21240-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, Sep 25, 2013 at 7:17 PM, Akinobu Mita <mita@fixstars.com> wrote:
> The data byte count field of PRDT indicates the length of data block
> which is a segment of data transfer for SCSI commands.  The value of
> this field shall have Dword granularity and the the maximum of length
> is 256KB.
>
> This adjusts dma pad mask and max segment size to the above-mentioned
> PRDT limitations.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> * Change from v1
> - Add comments for PRDT limitations as suggested by Subhash Jadavani
>
>  drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
>  drivers/scsi/ufs/ufshci.h |  5 +++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a2abe9a..660792e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1918,6 +1918,20 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
>  }
>
>  /**
> + * ufshcd_slave_configure - adjust SCSI device configurations
> + * @sdev: pointer to SCSI device
> + */
> +static int ufshcd_slave_configure(struct scsi_device *sdev)
> +{
> +       struct request_queue *q = sdev->request_queue;
> +
> +       blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
> +       blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
> +
> +       return 0;
> +}
> +
> +/**
>   * ufshcd_slave_destroy - remove SCSI device configurations
>   * @sdev: pointer to SCSI device
>   */
> @@ -2748,6 +2762,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>         .proc_name              = UFSHCD,
>         .queuecommand           = ufshcd_queuecommand,
>         .slave_alloc            = ufshcd_slave_alloc,
> +       .slave_configure        = ufshcd_slave_configure,
>         .slave_destroy          = ufshcd_slave_destroy,
>         .eh_abort_handler       = ufshcd_abort,
>         .eh_device_reset_handler = ufshcd_device_reset,
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 0475c66..b2b7004 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -296,6 +296,11 @@ enum {
>         MASK_OCS                        = 0x0F,
>  };
>
> +/* The maximum length of the data byte count field in the PRDT is 256KB */
> +#define PRDT_DATA_BYTE_COUNT_MAX       (256 * 1024)
> +/* The granularity of the data byte count field in the PRDT is 32-bit */
> +#define PRDT_DATA_BYTE_COUNT_PAD       4
> +
>  /**
>   * struct ufshcd_sg_entry - UFSHCI PRD Entry
>   * @base_addr: Lower 32bit physical address DW-0

Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
