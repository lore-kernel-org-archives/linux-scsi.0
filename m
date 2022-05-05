Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FE2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 02:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiEECbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 22:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiEECbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 22:31:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC360240A4
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 19:27:28 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KtyJD47zkzhYrB;
        Thu,  5 May 2022 10:26:52 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 10:27:21 +0800
Subject: Re: [PATCH 0/7] scsi: EH rework main part
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220502215953.5463-1-hare@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <4d4586e1-c25c-5452-2252-cf533842250d@hisilicon.com>
Date:   Thu, 5 May 2022 10:27:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes and other guys,

For SCSI EH, i have a question (sorry, it is not related to this 
patchset): for current flow of SCSI EH, if IOs of one disk is failed

(if there are many disks under the same scsi host), it will block all 
the IOs of total scsi host.

So during SCSI EH, all IOs are blocked even if some disks are normal. 
That's the place product line sometimes complain about

as it blocks IO bussiness of some normal disks because of just one bad 
disk during SCSI EH.

Is it possible to split the SCSI EH into two parts, the process of 
recovering the disk and the process of recovering scsi host, at the 
beginning

it just blocks the IOs of the disk and not need to block all the IOs,  
do some recovery related to the disk (such as abort IO/lun reset), and 
if failed,

then block all the IOs and do some recoverys related to scsi host (such 
as host reset) ?


Best regards,

chenxiang


在 2022/5/3 5:59, Hannes Reinecke 写道:
> Hi all,
>
> now that the prep is done we can convert the call sequence
> of the SCSI EH callbacks to use the respective object
> (ie struct Scsi_Host or struct scsi_device) and the Scsi command.
> With that we don't have to allocate a 'fake' command for
> ioctl reset anymore.
>
> As usual, comments and reviews are welcome.
>
> Hannes Reinecke (7):
>    scsi: Use Scsi_Host as argument for eh_host_reset_handler
>    scsi: Use Scsi_Host and channel number as argument for
>      eh_bus_reset_handler()
>    scsi: Use scsi_target as argument for eh_target_reset_handler()
>    scsi: Use scsi_device as argument to eh_device_reset_handler()
>    scsi: Do not allocate scsi command in scsi_ioctl_reset()
>    scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
>    scsi_error: streamline scsi_eh_bus_device_reset()
>
>   Documentation/scsi/scsi_eh.rst                |  16 +-
>   Documentation/scsi/scsi_mid_low_api.rst       |  31 +++-
>   drivers/infiniband/ulp/srp/ib_srp.c           |  12 +-
>   drivers/message/fusion/mptfc.c                |  25 ++-
>   drivers/message/fusion/mptsas.c               |  10 +-
>   drivers/message/fusion/mptscsih.c             |  86 ++++-----
>   drivers/message/fusion/mptscsih.h             |   8 +-
>   drivers/message/fusion/mptspi.c               |   8 +-
>   drivers/s390/scsi/zfcp_scsi.c                 |  14 +-
>   drivers/scsi/3w-9xxx.c                        |  11 +-
>   drivers/scsi/3w-sas.c                         |  11 +-
>   drivers/scsi/3w-xxxx.c                        |  11 +-
>   drivers/scsi/53c700.c                         |  39 ++--
>   drivers/scsi/BusLogic.c                       |  14 +-
>   drivers/scsi/NCR5380.c                        |   3 +-
>   drivers/scsi/a100u2w.c                        |  11 +-
>   drivers/scsi/aacraid/linit.c                  |  35 ++--
>   drivers/scsi/advansys.c                       |  26 +--
>   drivers/scsi/aha152x.c                        |  10 +-
>   drivers/scsi/aha1542.c                        |  30 +--
>   drivers/scsi/aic7xxx/aic79xx_osm.c            |  37 ++--
>   drivers/scsi/aic7xxx/aic7xxx_osm.c            |  10 +-
>   drivers/scsi/arcmsr/arcmsr_hba.c              |   6 +-
>   drivers/scsi/arm/acornscsi.c                  |   8 +-
>   drivers/scsi/arm/fas216.c                     |  18 +-
>   drivers/scsi/arm/fas216.h                     |  17 +-
>   drivers/scsi/atari_scsi.c                     |   4 +-
>   drivers/scsi/be2iscsi/be_main.c               |  12 +-
>   drivers/scsi/bfa/bfad_im.c                    |   8 +-
>   drivers/scsi/bnx2fc/bnx2fc.h                  |   4 +-
>   drivers/scsi/bnx2fc/bnx2fc_io.c               |  10 +-
>   drivers/scsi/csiostor/csio_scsi.c             |   3 +-
>   drivers/scsi/cxlflash/main.c                  |  10 +-
>   drivers/scsi/dc395x.c                         |  25 ++-
>   drivers/scsi/dpt_i2o.c                        |  43 +++--
>   drivers/scsi/dpti.h                           |   6 +-
>   drivers/scsi/esas2r/esas2r.h                  |   8 +-
>   drivers/scsi/esas2r/esas2r_main.c             |  55 +++---
>   drivers/scsi/esp_scsi.c                       |   8 +-
>   drivers/scsi/fdomain.c                        |   3 +-
>   drivers/scsi/fnic/fnic.h                      |   4 +-
>   drivers/scsi/fnic/fnic_scsi.c                 |   9 +-
>   drivers/scsi/hpsa.c                           |  14 +-
>   drivers/scsi/hptiop.c                         |   6 +-
>   drivers/scsi/ibmvscsi/ibmvfc.c                |  12 +-
>   drivers/scsi/ibmvscsi/ibmvscsi.c              |  23 +--
>   drivers/scsi/imm.c                            |   4 +-
>   drivers/scsi/initio.c                         |  11 +-
>   drivers/scsi/ipr.c                            |  35 ++--
>   drivers/scsi/ips.c                            |  22 +--
>   drivers/scsi/libfc/fc_fcp.c                   |  16 +-
>   drivers/scsi/libiscsi.c                       |  19 +-
>   drivers/scsi/libsas/sas_scsi_host.c           |  21 ++-
>   drivers/scsi/lpfc/lpfc_scsi.c                 |  23 ++-
>   drivers/scsi/mac53c94.c                       |   8 +-
>   drivers/scsi/megaraid.c                       |   4 +-
>   drivers/scsi/megaraid.h                       |   2 +-
>   drivers/scsi/megaraid/megaraid_mbox.c         |  14 +-
>   drivers/scsi/megaraid/megaraid_sas.h          |   3 +-
>   drivers/scsi/megaraid/megaraid_sas_base.c     |  44 ++---
>   drivers/scsi/megaraid/megaraid_sas_fusion.c   |  56 +++---
>   drivers/scsi/mesh.c                           |  10 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c               | 123 ++++++------
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  72 +++----
>   drivers/scsi/mvumi.c                          |   7 +-
>   drivers/scsi/myrb.c                           |   3 +-
>   drivers/scsi/myrs.c                           |   3 +-
>   drivers/scsi/ncr53c8xx.c                      |   4 +-
>   drivers/scsi/nsp32.c                          |  12 +-
>   drivers/scsi/pcmcia/nsp_cs.c                  |  10 +-
>   drivers/scsi/pcmcia/nsp_cs.h                  |   6 +-
>   drivers/scsi/pcmcia/qlogic_stub.c             |   4 +-
>   drivers/scsi/pcmcia/sym53c500_cs.c            |   8 +-
>   drivers/scsi/pmcraid.c                        |  27 ++-
>   drivers/scsi/ppa.c                            |   4 +-
>   drivers/scsi/qedf/qedf_main.c                 |  13 +-
>   drivers/scsi/qedi/qedi_iscsi.c                |   3 +-
>   drivers/scsi/qla1280.c                        |  36 ++--
>   drivers/scsi/qla2xxx/qla_os.c                 |  83 ++++-----
>   drivers/scsi/qla4xxx/ql4_os.c                 |  54 +++---
>   drivers/scsi/qlogicfas408.c                   |  10 +-
>   drivers/scsi/qlogicfas408.h                   |   2 +-
>   drivers/scsi/qlogicpti.c                      |   3 +-
>   drivers/scsi/scsi_debug.c                     |  78 +++-----
>   drivers/scsi/scsi_error.c                     | 175 +++++++++---------
>   drivers/scsi/scsi_lib.c                       |   2 -
>   drivers/scsi/smartpqi/smartpqi_init.c         |  11 +-
>   drivers/scsi/snic/snic.h                      |   5 +-
>   drivers/scsi/snic/snic_scsi.c                 |  41 +---
>   drivers/scsi/stex.c                           |   7 +-
>   drivers/scsi/storvsc_drv.c                    |   4 +-
>   drivers/scsi/sym53c8xx_2/sym_glue.c           |  13 +-
>   drivers/scsi/ufs/ufshcd.c                     |  14 +-
>   drivers/scsi/virtio_scsi.c                    |  12 +-
>   drivers/scsi/vmw_pvscsi.c                     |  20 +-
>   drivers/scsi/wd33c93.c                        |   5 +-
>   drivers/scsi/wd33c93.h                        |   2 +-
>   drivers/scsi/wd719x.c                         |  17 +-
>   drivers/scsi/xen-scsifront.c                  |  23 ++-
>   drivers/staging/rts5208/rtsx.c                |   6 +-
>   .../staging/unisys/visorhba/visorhba_main.c   |  24 +--
>   drivers/target/loopback/tcm_loop.c            |  17 +-
>   drivers/usb/image/microtek.c                  |   4 +-
>   drivers/usb/storage/scsiglue.c                |   8 +-
>   drivers/usb/storage/uas.c                     |   3 +-
>   include/scsi/libfc.h                          |   4 +-
>   include/scsi/libiscsi.h                       |   4 +-
>   include/scsi/libsas.h                         |   4 +-
>   include/scsi/scsi_cmnd.h                      |   1 -
>   include/scsi/scsi_host.h                      |   8 +-
>   110 files changed, 989 insertions(+), 1076 deletions(-)
>

