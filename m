From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 3/5] qla2xxx: Restrict max_luns to 16-bit for older
 HBAs
Date: Tue, 10 Dec 2013 13:26:21 -0500
Message-ID: <alpine.WNT.2.00.1312101325550.5984@N5102REMCQXM4BS.qlogic.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de> <1386673515-87133-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1808 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473Ab3LJS0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 13:26:34 -0500
In-Reply-To: <1386673515-87133-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>



On Tue, 10 Dec 2013, Hannes Reinecke wrote:

> Older HBAs are only capable of supporting 16-bit LUNs,
> so we need to make sure to adjust the 'ql2xmaxlun'
> parameter accordingly.
>
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 89a5300..a088e5b 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2600,6 +2600,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
> 	else
> 		host->max_cmd_len = MAX_CMDSZ;
> 	host->max_channel = MAX_BUSES - 1;
> +	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha)) {
> +		/* HW supports only 16-bit LUNs */
> +		if (ql2xmaxlun > 0xffff)
> +			ql2xmaxlun = 0xffff;
> +	}
> 	host->max_lun = ql2xmaxlun;
> 	host->transportt = qla2xxx_transport_template;
> 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
>

Hannes, this looks good.  Thanks.
