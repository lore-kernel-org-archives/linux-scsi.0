Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A31CDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 07:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377883AbjJLHaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 03:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377791AbjJLHao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 03:30:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922A690
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 00:30:41 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S5h6N2QKYzVlV0;
        Thu, 12 Oct 2023 15:27:08 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 12 Oct 2023 15:30:38 +0800
Message-ID: <0ba7153c-c630-aa0b-9d79-5676005112ee@huawei.com>
Date:   Thu, 12 Oct 2023 15:30:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv5 0/7] scsi: EH rework, main part
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <CAOptpSPx3oCzV2wzOMQuxrvv7oZi2gcPOXnP6DWE4Bo1tgoysw@mail.gmail.com>
 <901ef6ae-d0fe-4430-a84b-567db631bd44@suse.de>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <901ef6ae-d0fe-4430-a84b-567db631bd44@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/12 14:19, Hannes Reinecke wrote:
> On 10/11/23 18:35, Wenchao Hao wrote:
>> On Tue, Oct 3, 2023 at 12:57 AM Hannes Reinecke <hare@suse.de> wrote:
>>>
>>> Hi all,
>>>
>>> (taking up an old thread:)
>>> here's now the main part of my EH rework.
>>> It modifies the reset callbacks for SCSI EH such that
>>> each callback (eh_host_reset_handler, eh_bus_reset_handler,
>>> eh_target_reset_handler, eh_device_reset_handler) only
>>> references the actual entity it needs to work on
>>> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
>>> and the 'struct scsi_cmnd' is dropped from the argument list.
>>> This simplifies the handler themselves as they don't need to
>>> exclude some 'magic' command, and we don't need to allocate
>>> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
>>>
>>> The entire patchset can be found at:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>>> branch eh-rework.v5
>>>
>>> As usual, comments and reviews are welcome.
>>>
>>
>> Hi, Hannes, I reviewed your patches and have some questions
>> to consult.
>>
>> It seems your patches can be divided into 2 parts, the first part
>> modifies various LLDDs, decouple each driver's TMFs and scsi_cmnd,
>> in addition fixes some driver eh_reset function like device_reset
>> callback actually does target_reset should do things and so on.
>>
>> The second part modifies the SCSI middle layer by passing
>> Scsi_host/bus ID/scsi_target/scsi_device to the TMF callback of
>> LLDDs during error handling, so as to avoid using scsi_cmnd as
>> parameter during error handling.
>>
>> But I haven't seen any changes to support concurrent TMF, and
>> from what I understand, concurrent TMF still needs to be supported
>> by devices like virtio-scsi, which is designed to naturally support
>> concurrent TMF.
>>
>> Is my understanding correct? Or I left out some important details?
>>
> Your understanding is entirely correct.
> These patches do not modify the behaviour regarding concurrent TMFs.
> However, for aborts we already do concurrent TMFs, as for most drivers
> abort TMFs are sent directly after a command timeout triggers.
> 

Yes, from some of the drivers I've analyzed so far, these drivers support
fake concurrent TMFs. In most cases, there's a mutex lock used to mutex in
a complete TMFs, this kind of concurrent TMFs does not mean multiple
processes can execute TMFs simultaneously.

> Concurrent 'device reset' (or higher) TMFs are not implemented, and
> will be hard to support in general. One would need to redesign the
> SCSI EH flow, and find a way on how to 'coalesce' TMFs results when
> escalating to the next level; eg when 'device reset' fails for one
> device, you would have to wait for all 'device reset' TMFs on the
> same target to complete before you can advance to 'target reset'.

I totally agree that it seems unlikely to support real concurrent
TMFs in general.

In fact, I start focus on concurrent TMFs because we need introduce
a new EH mechanism which do not block whole host's IO in EH.

In my design, escalating to the next level of recovery still need wait for
other devices in the same level to complete.

For example, if driver enables device-based EH, sda and sdb belong to a same
target, both sda and sdb triggered EH. If EH of sda failed and need to
escalate to the next-level reset, the next-level recovery would not be waked
up until sdb's EH completed.

The previous patchset I posted earlier has some issues in the fallback logic.
After your patch applied, I will adapt and repost the patch based on your
modification.

Thanks.

> With current SCSI EH you can escalate directly, with no need to
> wait for any other TMFs (as there won't be any).
> 
> So I think the gains for doing concurrent TMFs are offset by the
> losses incurred by having to wait for TMF timeouts.
> 
> Cheers,
> 
> Hannes
> 
>> Thanks.
>>
>>> Hannes Reinecke (7):
>>>    scsi: Use Scsi_Host as argument for eh_host_reset_handler
>>>    scsi: Use Scsi_Host and channel number as argument for
>>>      eh_bus_reset_handler()
>>>    scsi: Use scsi_target as argument for eh_target_reset_handler()
>>>    scsi: Use scsi_device as argument to eh_device_reset_handler()
>>>    scsi: Do not allocate scsi command in scsi_ioctl_reset()
>>>    scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
>>>    scsi_error: streamline scsi_eh_bus_device_reset()
>>>
>>>   Documentation/scsi/scsi_eh.rst              |  16 +-
>>>   Documentation/scsi/scsi_mid_low_api.rst     |  31 +++-
>>>   drivers/infiniband/ulp/srp/ib_srp.c         |  12 +-
>>>   drivers/message/fusion/mptfc.c              |  25 ++--
>>>   drivers/message/fusion/mptsas.c             |  12 +-
>>>   drivers/message/fusion/mptscsih.c           |  86 +++++------
>>>   drivers/message/fusion/mptscsih.h           |   8 +-
>>>   drivers/message/fusion/mptspi.c             |  10 +-
>>>   drivers/s390/scsi/zfcp_scsi.c               |  16 +-
>>>   drivers/scsi/3w-9xxx.c                      |  11 +-
>>>   drivers/scsi/3w-sas.c                       |  11 +-
>>>   drivers/scsi/3w-xxxx.c                      |  11 +-
>>>   drivers/scsi/53c700.c                       |  39 ++---
>>>   drivers/scsi/BusLogic.c                     |  14 +-
>>>   drivers/scsi/NCR5380.c                      |   3 +-
>>>   drivers/scsi/a100u2w.c                      |  11 +-
>>>   drivers/scsi/aacraid/linit.c                |  35 ++---
>>>   drivers/scsi/advansys.c                     |  26 ++--
>>>   drivers/scsi/aha152x.c                      |  10 +-
>>>   drivers/scsi/aha1542.c                      |  30 ++--
>>>   drivers/scsi/aic7xxx/aic79xx_osm.c          |  37 ++---
>>>   drivers/scsi/aic7xxx/aic7xxx_osm.c          |  10 +-
>>>   drivers/scsi/arcmsr/arcmsr_hba.c            |   6 +-
>>>   drivers/scsi/arm/acornscsi.c                |   8 +-
>>>   drivers/scsi/arm/fas216.c                   |  18 +--
>>>   drivers/scsi/arm/fas216.h                   |  17 ++-
>>>   drivers/scsi/atari_scsi.c                   |   4 +-
>>>   drivers/scsi/be2iscsi/be_main.c             |  12 +-
>>>   drivers/scsi/bfa/bfad_im.c                  |   8 +-
>>>   drivers/scsi/bnx2fc/bnx2fc.h                |   4 +-
>>>   drivers/scsi/bnx2fc/bnx2fc_io.c             |  10 +-
>>>   drivers/scsi/csiostor/csio_scsi.c           |   5 +-
>>>   drivers/scsi/cxlflash/main.c                |  10 +-
>>>   drivers/scsi/dc395x.c                       |  25 ++--
>>>   drivers/scsi/esas2r/esas2r.h                |   8 +-
>>>   drivers/scsi/esas2r/esas2r_main.c           |  55 +++----
>>>   drivers/scsi/esp_scsi.c                     |   8 +-
>>>   drivers/scsi/fdomain.c                      |   3 +-
>>>   drivers/scsi/fnic/fnic.h                    |   4 +-
>>>   drivers/scsi/fnic/fnic_scsi.c               |   8 +-
>>>   drivers/scsi/hpsa.c                         |  14 +-
>>>   drivers/scsi/hptiop.c                       |   6 +-
>>>   drivers/scsi/ibmvscsi/ibmvfc.c              |  15 +-
>>>   drivers/scsi/ibmvscsi/ibmvscsi.c            |  23 +--
>>>   drivers/scsi/imm.c                          |   4 +-
>>>   drivers/scsi/initio.c                       |  11 +-
>>>   drivers/scsi/ipr.c                          |  26 ++--
>>>   drivers/scsi/ips.c                          |  22 +--
>>>   drivers/scsi/libfc/fc_fcp.c                 |  18 +--
>>>   drivers/scsi/libiscsi.c                     |  19 ++-
>>>   drivers/scsi/libsas/sas_scsi_host.c         |  21 +--
>>>   drivers/scsi/lpfc/lpfc_scsi.c               |  23 ++-
>>>   drivers/scsi/mac53c94.c                     |   8 +-
>>>   drivers/scsi/megaraid.c                     |   4 +-
>>>   drivers/scsi/megaraid.h                     |   2 +-
>>>   drivers/scsi/megaraid/megaraid_mbox.c       |  14 +-
>>>   drivers/scsi/megaraid/megaraid_sas.h        |   3 +-
>>>   drivers/scsi/megaraid/megaraid_sas_base.c   |  44 +++---
>>>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  54 ++++---
>>>   drivers/scsi/mesh.c                         |  10 +-
>>>   drivers/scsi/mpi3mr/mpi3mr_os.c             | 135 ++++++++---------
>>>   drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  72 ++++-----
>>>   drivers/scsi/mvumi.c                        |   7 +-
>>>   drivers/scsi/myrb.c                         |   3 +-
>>>   drivers/scsi/myrs.c                         |   3 +-
>>>   drivers/scsi/ncr53c8xx.c                    |   4 +-
>>>   drivers/scsi/nsp32.c                        |  12 +-
>>>   drivers/scsi/pcmcia/nsp_cs.c                |  10 +-
>>>   drivers/scsi/pcmcia/nsp_cs.h                |   6 +-
>>>   drivers/scsi/pcmcia/qlogic_stub.c           |   4 +-
>>>   drivers/scsi/pcmcia/sym53c500_cs.c          |   8 +-
>>>   drivers/scsi/pmcraid.c                      |  27 ++--
>>>   drivers/scsi/ppa.c                          |   4 +-
>>>   drivers/scsi/qedf/qedf_main.c               |  13 +-
>>>   drivers/scsi/qedi/qedi_iscsi.c              |   3 +-
>>>   drivers/scsi/qla1280.c                      |  36 +++--
>>>   drivers/scsi/qla2xxx/qla_os.c               |  83 +++++------
>>>   drivers/scsi/qla4xxx/ql4_os.c               |  54 +++----
>>>   drivers/scsi/qlogicfas408.c                 |  10 +-
>>>   drivers/scsi/qlogicfas408.h                 |   2 +-
>>>   drivers/scsi/qlogicpti.c                    |   3 +-
>>>   drivers/scsi/scsi_debug.c                   |  33 ++---
>>>   drivers/scsi/scsi_error.c                   | 153 ++++++++++----------
>>>   drivers/scsi/scsi_lib.c                     |   2 -
>>>   drivers/scsi/smartpqi/smartpqi.h            |   1 -
>>>   drivers/scsi/smartpqi/smartpqi_init.c       |  19 +--
>>>   drivers/scsi/snic/snic.h                    |   5 +-
>>>   drivers/scsi/snic/snic_scsi.c               |  41 ++----
>>>   drivers/scsi/stex.c                         |   7 +-
>>>   drivers/scsi/storvsc_drv.c                  |   4 +-
>>>   drivers/scsi/sym53c8xx_2/sym_glue.c         |  13 +-
>>>   drivers/scsi/virtio_scsi.c                  |  12 +-
>>>   drivers/scsi/vmw_pvscsi.c                   |  20 ++-
>>>   drivers/scsi/wd33c93.c                      |   5 +-
>>>   drivers/scsi/wd33c93.h                      |   2 +-
>>>   drivers/scsi/wd719x.c                       |  17 ++-
>>>   drivers/scsi/xen-scsifront.c                |   6 +-
>>>   drivers/staging/rts5208/rtsx.c              |   6 +-
>>>   drivers/target/loopback/tcm_loop.c          |  17 ++-
>>>   drivers/ufs/core/ufshcd.c                   |  14 +-
>>>   drivers/usb/image/microtek.c                |   4 +-
>>>   drivers/usb/storage/scsiglue.c              |   8 +-
>>>   drivers/usb/storage/uas.c                   |   3 +-
>>>   include/scsi/libfc.h                        |   4 +-
>>>   include/scsi/libiscsi.h                     |   4 +-
>>>   include/scsi/libsas.h                       |   4 +-
>>>   include/scsi/scsi_cmnd.h                    |   1 -
>>>   include/scsi/scsi_host.h                    |   8 +-
>>>   108 files changed, 921 insertions(+), 1009 deletions(-)
>>>
>>> -- 
>>> 2.35.3
>>>
> 

