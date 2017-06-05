From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 4/6] libata: factor out a ata_identify_page_supported
 helper
Date: Mon, 5 Jun 2017 15:46:42 +0300
Message-ID: <950a1c26-c691-9bce-eaa4-873165d7a98b@cogentembedded.com>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34595 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751294AbdFEMqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 08:46:46 -0400
Received: by mail-lf0-f53.google.com with SMTP id v20so38291934lfa.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jun 2017 05:46:46 -0700 (PDT)
In-Reply-To: <20170604124225.27032-5-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Hello!

On 06/04/2017 03:42 PM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/ata/libata-core.c | 59 +++++++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 445e7050637b..f57131115594 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2120,6 +2120,37 @@ static bool ata_log_supported(struct ata_device *dev, u8 log)
>  	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
>  }
>
> +static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
> +{
> +	struct ata_port *ap = dev->link->ap;
> +	unsigned int err, i;
> +
> +	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE)) {
> +		ata_dev_warn(dev, "ATA Identify Device Log not supported\n");
> +		return false;
> +	}
> +
> +	/*
> +	 * Read IDENTIFY DEVICE data log, page 0, to figure out if the page is
> +	 * supported.
> +	 */
> +	err = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE, 0, ap->sector_buf,
> +			1);
> +	if (err) {
> +		ata_dev_info(dev,
> +			     "failed to get Device Identify Log Emask 0x%x\n",
> +			     err);

    Your line continuation style is spomewhat inconsistent: 2 tabs above and 
tabs/spaces here...

[...]

MBR, Sergei
