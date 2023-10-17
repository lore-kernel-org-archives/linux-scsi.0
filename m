Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B08CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 14:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344006AbjJQOHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 10:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344009AbjJQOHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 10:07:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B47BFA
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 07:07:10 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S8wfz40skzCrPP;
        Tue, 17 Oct 2023 22:03:07 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 17 Oct 2023 22:07:06 +0800
Message-ID: <dabbd6bb-cacb-eeb0-7647-b0ef459b1444@huawei.com>
Date:   Tue, 17 Oct 2023 22:07:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/9] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-5-hare@suse.de>
Content-Language: en-US
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <20231016121542.111501-5-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/16 20:15, Hannes Reinecke wrote:
> The device reset function should only depend on the scsi device,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   Documentation/scsi/scsi_eh.rst          |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst |  4 +-
>   drivers/infiniband/ulp/srp/ib_srp.c     |  6 +--
>   drivers/message/fusion/mptfc.c          | 12 +++---
>   drivers/message/fusion/mptscsih.c       | 27 ++++---------
>   drivers/message/fusion/mptscsih.h       |  2 +-
>   drivers/s390/scsi/zfcp_scsi.c           |  4 +-
>   drivers/scsi/a100u2w.c                  |  7 ++--
>   drivers/scsi/aacraid/linit.c            |  9 ++---
>   drivers/scsi/aha152x.c                  |  6 +--
>   drivers/scsi/aha1542.c                  |  8 ++--
>   drivers/scsi/aic7xxx/aic79xx_osm.c      | 27 +++++--------
>   drivers/scsi/aic7xxx/aic7xxx_osm.c      |  4 +-
>   drivers/scsi/arm/fas216.c               |  5 +--
>   drivers/scsi/arm/fas216.h               |  6 +--
>   drivers/scsi/be2iscsi/be_main.c         |  8 ++--
>   drivers/scsi/bfa/bfad_im.c              |  3 +-
>   drivers/scsi/bnx2fc/bnx2fc.h            |  2 +-
>   drivers/scsi/bnx2fc/bnx2fc_io.c         |  6 +--
>   drivers/scsi/csiostor/csio_scsi.c       |  5 +--
>   drivers/scsi/cxlflash/main.c            |  5 +--
>   drivers/scsi/esas2r/esas2r.h            |  2 +-
>   drivers/scsi/esas2r/esas2r_main.c       |  3 +-
>   drivers/scsi/fnic/fnic.h                |  2 +-
>   drivers/scsi/fnic/fnic_scsi.c           |  5 +--
>   drivers/scsi/hpsa.c                     | 14 +++----
>   drivers/scsi/ibmvscsi/ibmvfc.c          |  8 ++--
>   drivers/scsi/ibmvscsi/ibmvscsi.c        | 19 ++++-----
>   drivers/scsi/ipr.c                      | 24 +++++------
>   drivers/scsi/libfc/fc_fcp.c             | 13 +++---
>   drivers/scsi/libiscsi.c                 | 15 ++++---
>   drivers/scsi/libsas/sas_scsi_host.c     | 12 +++---
>   drivers/scsi/lpfc/lpfc_scsi.c           | 12 +++---
>   drivers/scsi/mpi3mr/mpi3mr_os.c         | 40 ++++++++-----------
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c    | 30 ++++++--------
>   drivers/scsi/pcmcia/nsp_cs.h            |  2 -
>   drivers/scsi/pmcraid.c                  |  8 ++--
>   drivers/scsi/qedf/qedf_main.c           |  6 +--
>   drivers/scsi/qla1280.c                  | 53 ++++++++-----------------
>   drivers/scsi/qla2xxx/qla_os.c           | 24 +++++------
>   drivers/scsi/qla4xxx/ql4_os.c           | 23 +++++------
>   drivers/scsi/scsi_debug.c               |  3 +-
>   drivers/scsi/scsi_error.c               |  2 +-
>   drivers/scsi/smartpqi/smartpqi.h        |  1 -
>   drivers/scsi/smartpqi/smartpqi_init.c   | 19 ++++-----
>   drivers/scsi/snic/snic.h                |  2 +-
>   drivers/scsi/snic/snic_scsi.c           |  4 +-
>   drivers/scsi/virtio_scsi.c              | 12 +++---
>   drivers/scsi/vmw_pvscsi.c               | 10 ++---
>   drivers/scsi/wd719x.c                   |  6 +--
>   drivers/scsi/xen-scsifront.c            |  6 +--
>   drivers/staging/rts5208/rtsx.c          |  6 ++-
>   drivers/target/loopback/tcm_loop.c      |  8 ++--
>   drivers/ufs/core/ufshcd.c               |  8 ++--
>   drivers/usb/storage/scsiglue.c          |  4 +-
>   drivers/usb/storage/uas.c               |  3 +-
>   include/scsi/libfc.h                    |  2 +-
>   include/scsi/libiscsi.h                 |  2 +-
>   include/scsi/libsas.h                   |  2 +-
>   include/scsi/scsi_host.h                |  2 +-
>   60 files changed, 253 insertions(+), 322 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c247a3c7ae17..a2c3ffa2b5bd 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5306,9 +5306,8 @@ static void scsi_debug_stop_all_queued(struct scsi_device *sdp)
>   				scsi_debug_stop_all_queued_iter, sdp);
>   }
>   
> -static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
> +static int scsi_debug_device_reset(struct scsi_device *sdp)
>   {
> -	struct scsi_device *sdp = SCpnt->device;
>   	struct sdebug_dev_info *devip = sdp->hostdata;
>   
>   	++num_dev_resets;

The change of my scsi_debug error injection conflict with it, you can
fix the conflict with following:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a7c374b399a1..60070d12c949 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5590,12 +5590,10 @@ static void scsi_debug_stop_all_queued(struct scsi_device *sdp)
  				scsi_debug_stop_all_queued_iter, sdp);
  }
  
-static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
+static int sdebug_fail_lun_reset(struct scsi_device *sdp)
  {
-	struct scsi_device *sdp = cmnd->device;
  	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
  	struct sdebug_err_inject *err;
-	unsigned char *cmd = cmnd->cmnd;
  	int ret = 0;
  
  	if (devip == NULL)
@@ -5603,8 +5601,7 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
  
  	rcu_read_lock();
  	list_for_each_entry_rcu(err, &devip->inject_err_list, list) {
-		if (err->type == ERR_LUN_RESET_FAILED &&
-		    (err->cmd == cmd[0] || err->cmd == 0xff)) {
+		if (err->type == ERR_LUN_RESET_FAILED) {
  			ret = !!err->cnt;
  			if (err->cnt < 0)
  				err->cnt++;
@@ -5618,12 +5615,9 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
  	return 0;
  }
  
-static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_device_reset(struct scsi_device *sdp)
  {
-	struct scsi_device *sdp = SCpnt->device;
  	struct sdebug_dev_info *devip = sdp->hostdata;
-	u8 *cmd = SCpnt->cmnd;
-	u8 opcode = cmd[0];
  
  	++num_dev_resets;
  
@@ -5634,8 +5628,8 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
  	if (devip)
  		set_bit(SDEBUG_UA_POR, devip->uas_bm);
  
-	if (sdebug_fail_lun_reset(SCpnt)) {
-		scmd_printk(KERN_INFO, SCpnt, "fail lun reset 0x%x\n", opcode);
+	if (sdebug_fail_lun_reset(sdp)) {
+		sdev_printk(KERN_INFO, sdp, "fail lun reset\n");
  		return FAILED;
  	}
  


