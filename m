From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 3/5] qla2xxx: Restrict max_lun to 16-bit for older HBAs
Date: Tue, 20 May 2014 09:32:57 -0400
Message-ID: <alpine.OSX.2.00.1405200932160.1003@administrators-macbook-pro.local>
References: <1400583791-123120-1-git-send-email-hare@suse.de> <1400583791-123120-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:60387 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaETNdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 09:33:33 -0400
In-Reply-To: <1400583791-123120-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>


On Tue, 20 May 2014, Hannes Reinecke wrote:

> Older HBAs are only capable of supporting 16-bit LUNs,
> so we need to make sure to adjust max_lun accordingly.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 19e99cc..264d97e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2656,7 +2656,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
> 	else
> 		host->max_cmd_len = MAX_CMDSZ;
> 	host->max_channel = MAX_BUSES - 1;
> -	host->max_lun = ql2xmaxlun;
> +	/* Older HBAs support only 16-bit LUNs */
> +	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha) &&
> +	    ql2xmaxlun > 0xffff)
> +		host->max_lun = 0xffff;
> +	else
> +		host->max_lun = ql2xmaxlun;
> 	host->transportt = qla2xxx_transport_template;
> 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
>
>

New patch looks good as well.
