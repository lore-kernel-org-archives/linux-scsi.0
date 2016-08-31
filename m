From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 04/17] smartpqi: enhance drive offline informational
 message
Date: Wed, 31 Aug 2016 15:00:38 +0200
Message-ID: <32f5d95c-daf2-a501-0b6f-2f7d9efbc48f@redhat.com>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222987005.31214.15421477679512221805.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934196AbcHaNAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 09:00:53 -0400
In-Reply-To: <147222987005.31214.15421477679512221805.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 26.8.2016 18:44, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>
> Made a couple of error messages more verbose.
>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 9922e31..198a7c2 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2298,11 +2298,16 @@ static inline void pqi_aio_path_disabled(struct pqi_io_request *io_request)
>  static inline void pqi_take_device_offline(struct scsi_device *sdev)
>  {
>  	struct pqi_ctrl_info *ctrl_info;
> +	struct pqi_scsi_dev *device;
>  
>  	if (scsi_device_online(sdev)) {
>  		scsi_device_set_state(sdev, SDEV_OFFLINE);
>  		ctrl_info = shost_to_hba(sdev->host);
>  		schedule_delayed_work(&ctrl_info->rescan_work, 0);
> +		device = sdev->hostdata;
> +		dev_err(&ctrl_info->pci_dev->dev, "offlined scsi %d:%d:%d:%d\n",
> +			ctrl_info->scsi_host->host_no, device->bus,
> +			device->target, device->lun);
>  	}
>  }
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


