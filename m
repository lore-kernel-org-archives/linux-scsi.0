Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1ECFCD80B7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 12:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjJJMMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 08:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjJJMMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 08:12:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584A2A4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 05:12:07 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S4ZS36PLtzVlVP;
        Tue, 10 Oct 2023 20:08:35 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 10 Oct 2023 20:12:03 +0800
Message-ID: <6e9f6626-5303-3d17-c807-67905f2d03e1@huawei.com>
Date:   Tue, 10 Oct 2023 20:12:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/7] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-5-hare@suse.de>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <20231002155915.109359-5-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/2 23:59, Hannes Reinecke wrote:
> The device reset function should only depend on the scsi device,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   Documentation/scsi/scsi_eh.rst          |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst |  4 +--
>   drivers/infiniband/ulp/srp/ib_srp.c     |  6 ++--
>   drivers/message/fusion/mptfc.c          | 12 ++++----
>   drivers/message/fusion/mptscsih.c       | 19 +++++-------
>   drivers/message/fusion/mptscsih.h       |  2 +-
>   drivers/s390/scsi/zfcp_scsi.c           |  4 +--
>   drivers/scsi/a100u2w.c                  |  7 ++---
>   drivers/scsi/aacraid/linit.c            |  9 +++---
>   drivers/scsi/aha152x.c                  |  6 ++--
>   drivers/scsi/aha1542.c                  |  8 ++---
>   drivers/scsi/aic7xxx/aic79xx_osm.c      | 27 +++++++----------
>   drivers/scsi/aic7xxx/aic7xxx_osm.c      |  4 +--
>   drivers/scsi/arm/fas216.c               |  5 ++--
>   drivers/scsi/arm/fas216.h               |  6 ++--
>   drivers/scsi/be2iscsi/be_main.c         |  8 ++---
>   drivers/scsi/bfa/bfad_im.c              |  3 +-
>   drivers/scsi/bnx2fc/bnx2fc.h            |  2 +-
>   drivers/scsi/bnx2fc/bnx2fc_io.c         |  6 ++--
>   drivers/scsi/csiostor/csio_scsi.c       |  5 ++--
>   drivers/scsi/cxlflash/main.c            |  5 ++--
>   drivers/scsi/esas2r/esas2r.h            |  2 +-
>   drivers/scsi/esas2r/esas2r_main.c       |  3 +-
>   drivers/scsi/fnic/fnic.h                |  2 +-
>   drivers/scsi/fnic/fnic_scsi.c           |  5 ++--
>   drivers/scsi/hpsa.c                     | 14 ++++-----
>   drivers/scsi/ibmvscsi/ibmvfc.c          |  8 ++---
>   drivers/scsi/ibmvscsi/ibmvscsi.c        | 19 ++++++------
>   drivers/scsi/ipr.c                      | 22 +++++++-------
>   drivers/scsi/libfc/fc_fcp.c             | 13 ++++----
>   drivers/scsi/libiscsi.c                 | 15 +++++-----
>   drivers/scsi/libsas/sas_scsi_host.c     | 12 ++++----
>   drivers/scsi/lpfc/lpfc_scsi.c           | 10 +++----
>   drivers/scsi/mpi3mr/mpi3mr_os.c         | 40 +++++++++++--------------
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c    | 30 ++++++++-----------
>   drivers/scsi/pcmcia/nsp_cs.h            |  2 --
>   drivers/scsi/pmcraid.c                  |  6 ++--
>   drivers/scsi/qedf/qedf_main.c           |  6 ++--
>   drivers/scsi/qla1280.c                  | 21 +++++++++----
>   drivers/scsi/qla2xxx/qla_os.c           | 24 +++++++--------
>   drivers/scsi/qla4xxx/ql4_os.c           | 23 ++++++--------
>   drivers/scsi/scsi_debug.c               |  3 +-
>   drivers/scsi/scsi_error.c               | 35 +++++++++++++++-------
>   drivers/scsi/smartpqi/smartpqi.h        |  1 -
>   drivers/scsi/smartpqi/smartpqi_init.c   | 19 +++++-------
>   drivers/scsi/snic/snic.h                |  2 +-
>   drivers/scsi/snic/snic_scsi.c           |  4 +--
>   drivers/scsi/virtio_scsi.c              | 12 ++++----
>   drivers/scsi/vmw_pvscsi.c               | 10 +++----
>   drivers/scsi/wd719x.c                   |  6 ++--
>   drivers/scsi/xen-scsifront.c            |  6 ++--
>   drivers/staging/rts5208/rtsx.c          |  6 +++-
>   drivers/target/loopback/tcm_loop.c      |  8 ++---
>   drivers/ufs/core/ufshcd.c               |  8 ++---
>   drivers/usb/storage/scsiglue.c          |  4 +--
>   drivers/usb/storage/uas.c               |  3 +-
>   include/scsi/libfc.h                    |  2 +-
>   include/scsi/libiscsi.h                 |  2 +-
>   include/scsi/libsas.h                   |  2 +-
>   include/scsi/scsi_host.h                |  2 +-
>   60 files changed, 272 insertions(+), 290 deletions(-)
> 

> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index df012977a25e..8e0696448590 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -5037,7 +5037,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
>   
>   /**
>    * __ipr_eh_dev_reset - Reset the device
> - * @scsi_cmd:	scsi command struct
> + * @scsi_dev:	scsi device struct
>    *
>    * This function issues a device reset to the affected device.
>    * A LUN reset will be sent to the device first. If that does
> @@ -5046,15 +5046,15 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
>    * Return value:
>    *	SUCCESS / FAILED
>    **/
> -static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
> +static int __ipr_eh_dev_reset(struct scsi_device *scsi_dev)
>   {
>   	struct ipr_ioa_cfg *ioa_cfg;
>   	struct ipr_resource_entry *res;
>   	int rc = 0;
>   
>   	ENTER;
> -	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
> -	res = scsi_cmd->device->hostdata;
> +	ioa_cfg = (struct ipr_ioa_cfg *) scsi_dev->host->hostdata;
> +	res = scsi_dev->hostdata;
>   
>   	/*
>   	 * If we are currently going through reset/reload, return failed. This will force the
> @@ -5067,7 +5067,7 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
>   		return FAILED;
>   
>   	res->resetting_device = 1;
> -	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
> +	sdev_printk(KERN_ERR, scsi_dev, "Resetting device\n");
>   
>   	rc = ipr_device_reset(ioa_cfg, res);
>   	res->resetting_device = 0;
> @@ -5077,21 +5077,21 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
>   	return rc ? FAILED : SUCCESS;
>   }
>   
> -static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
> +static int ipr_eh_dev_reset(struct scsi_device *sdev)
>   {
>   	int rc;
>   	struct ipr_ioa_cfg *ioa_cfg;
>   	struct ipr_resource_entry *res;
>   
> -	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
> -	res = cmd->device->hostdata;
> +	ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
> +	res = sdev->hostdata;
>   
>   	if (!res)
>   		return FAILED;
>   
> -	spin_lock_irq(cmd->device->host->host_lock);
> -	rc = __ipr_eh_dev_reset(cmd);
> -	spin_unlock_irq(cmd->device->host->host_lock);
> +	spin_lock_irq(sdev->host->host_lock);
> +	rc = __ipr_eh_dev_reset(sdev);
> +	spin_unlock_irq(sdev->host->host_lock);
>   
>   	if (rc == SUCCESS)
>   		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);

This line should also be updated:

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 8e0696448590..a94babec74eb 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5094,7 +5094,7 @@ static int ipr_eh_dev_reset(struct scsi_device *sdev)
         spin_unlock_irq(sdev->host->host_lock);
  
         if (rc == SUCCESS)
-               rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+               rc = ipr_wait_for_ops(ioa_cfg, sdev, ipr_match_lun);
  
         return rc;
  }


