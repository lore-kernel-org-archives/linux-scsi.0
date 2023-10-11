Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB98ACDB468
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Oct 2023 16:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbjJKQgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjJKQf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2023 12:35:59 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55953B0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2023 09:35:57 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5a4c073cc06so10090377b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2023 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697042156; x=1697646956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sw6mj/h/Othaauj1KzZj+WcOxGaj2GsAV8lx5j5SGoM=;
        b=d3PfN/c5Y0LgTtfxsA9M/Wp7snXIuZnplRghe5Owg1AyLcuwe8LHTyzkGv0WcNuVKD
         W8dNnzNs4Y/3TgmeKQ4q2mRHQf4gjr9oLNE0Ok7xV+0g9UsY9NOUotOwkZmwITvIODhu
         MuEhHWKhtSnEYv+0chX/eoU4zUsaq8TR6vPx2BARnIKy2MU7L+Xze1j4FYJnLRdA+hGS
         v7bLKeKiWJuwuXgpVqCqPSOq9dLdQ1p0nBXO72VnBuMZn6Bwb6sp2dpj0NNUT0SnJ4Yl
         RA0yeEkns5awQNc1UTe/KBgejrv5Fwg0yJ3jbahwtYxGRZIFV6pb8JfC1O2UynW+d5zU
         5/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697042156; x=1697646956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sw6mj/h/Othaauj1KzZj+WcOxGaj2GsAV8lx5j5SGoM=;
        b=wQAzB9ZZ1/tfO5SpnfRPheLsXG2sLWHd9/Zto53DxM5aGryLgDlhSEIbauC7SzN5wA
         A/MzPBMXZTFe1h7gy9NgrW9V9TetW9mCoxTu2HRe2hyJIrch3ME53FyuAxuljSH6LNll
         4LOLa9FOWGf/XU8f8kRzc7eeVxcW7qMRNELkdUD6sNFCHkhl1Mjlq4gKzvDRvNWr5Kqn
         HoJIrHK25A1ODHtzyW9xpj0GIvnq1XU1QSoYses99ImAT2dmiVHvhhkKbs+WZL9NtLuI
         Y8oT/XAk1lgyHpCyyNZ/EQGYsbAE9A8oxjYLVS6em6mxQHUYsB5eO6bHQdskpnbpQxzx
         qi9Q==
X-Gm-Message-State: AOJu0YwSFpBiPptZ/Q6oB+CZqjyhE94vxHL3MIVq+Orq4EsRjxfs2+PF
        YJ9hG8ZPe1yqyODOddtGVF5nCcYs5B+RH6ZThy0OD2vuApW4S01r
X-Google-Smtp-Source: AGHT+IEMwF1yMN/GUa2W6sD2Cw9F/L8kwb/DZTtpgp94idWOlh3E8CCq7tsZDTXXN3RkQhNXZhS42W7SmkUcpiSxDN4=
X-Received: by 2002:a25:2f45:0:b0:d9a:4f02:c6af with SMTP id
 v66-20020a252f45000000b00d9a4f02c6afmr3965873ybv.32.1697042156457; Wed, 11
 Oct 2023 09:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20231002155915.109359-1-hare@suse.de>
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
From:   Wenchao Hao <haowenchao22@gmail.com>
Date:   Thu, 12 Oct 2023 00:35:45 +0800
Message-ID: <CAOptpSPx3oCzV2wzOMQuxrvv7oZi2gcPOXnP6DWE4Bo1tgoysw@mail.gmail.com>
Subject: Re: [PATCHv5 0/7] scsi: EH rework, main part
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 3, 2023 at 12:57=E2=80=AFAM Hannes Reinecke <hare@suse.de> wrot=
e:
>
> Hi all,
>
> (taking up an old thread:)
> here's now the main part of my EH rework.
> It modifies the reset callbacks for SCSI EH such that
> each callback (eh_host_reset_handler, eh_bus_reset_handler,
> eh_target_reset_handler, eh_device_reset_handler) only
> references the actual entity it needs to work on
> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
> and the 'struct scsi_cmnd' is dropped from the argument list.
> This simplifies the handler themselves as they don't need to
> exclude some 'magic' command, and we don't need to allocate
> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
>
> The entire patchset can be found at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch eh-rework.v5
>
> As usual, comments and reviews are welcome.
>

Hi, Hannes, I reviewed your patches and have some questions
to consult.

It seems your patches can be divided into 2 parts, the first part
modifies various LLDDs, decouple each driver's TMFs and scsi_cmnd,
in addition fixes some driver eh_reset function like device_reset
callback actually does target_reset should do things and so on.

The second part modifies the SCSI middle layer by passing
Scsi_host/bus ID/scsi_target/scsi_device to the TMF callback of
LLDDs during error handling, so as to avoid using scsi_cmnd as
parameter during error handling.

But I haven't seen any changes to support concurrent TMF, and
from what I understand, concurrent TMF still needs to be supported
by devices like virtio-scsi, which is designed to naturally support
concurrent TMF.

Is my understanding correct? Or I left out some important details?

Thanks.

> Hannes Reinecke (7):
>   scsi: Use Scsi_Host as argument for eh_host_reset_handler
>   scsi: Use Scsi_Host and channel number as argument for
>     eh_bus_reset_handler()
>   scsi: Use scsi_target as argument for eh_target_reset_handler()
>   scsi: Use scsi_device as argument to eh_device_reset_handler()
>   scsi: Do not allocate scsi command in scsi_ioctl_reset()
>   scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
>   scsi_error: streamline scsi_eh_bus_device_reset()
>
>  Documentation/scsi/scsi_eh.rst              |  16 +-
>  Documentation/scsi/scsi_mid_low_api.rst     |  31 +++-
>  drivers/infiniband/ulp/srp/ib_srp.c         |  12 +-
>  drivers/message/fusion/mptfc.c              |  25 ++--
>  drivers/message/fusion/mptsas.c             |  12 +-
>  drivers/message/fusion/mptscsih.c           |  86 +++++------
>  drivers/message/fusion/mptscsih.h           |   8 +-
>  drivers/message/fusion/mptspi.c             |  10 +-
>  drivers/s390/scsi/zfcp_scsi.c               |  16 +-
>  drivers/scsi/3w-9xxx.c                      |  11 +-
>  drivers/scsi/3w-sas.c                       |  11 +-
>  drivers/scsi/3w-xxxx.c                      |  11 +-
>  drivers/scsi/53c700.c                       |  39 ++---
>  drivers/scsi/BusLogic.c                     |  14 +-
>  drivers/scsi/NCR5380.c                      |   3 +-
>  drivers/scsi/a100u2w.c                      |  11 +-
>  drivers/scsi/aacraid/linit.c                |  35 ++---
>  drivers/scsi/advansys.c                     |  26 ++--
>  drivers/scsi/aha152x.c                      |  10 +-
>  drivers/scsi/aha1542.c                      |  30 ++--
>  drivers/scsi/aic7xxx/aic79xx_osm.c          |  37 ++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c          |  10 +-
>  drivers/scsi/arcmsr/arcmsr_hba.c            |   6 +-
>  drivers/scsi/arm/acornscsi.c                |   8 +-
>  drivers/scsi/arm/fas216.c                   |  18 +--
>  drivers/scsi/arm/fas216.h                   |  17 ++-
>  drivers/scsi/atari_scsi.c                   |   4 +-
>  drivers/scsi/be2iscsi/be_main.c             |  12 +-
>  drivers/scsi/bfa/bfad_im.c                  |   8 +-
>  drivers/scsi/bnx2fc/bnx2fc.h                |   4 +-
>  drivers/scsi/bnx2fc/bnx2fc_io.c             |  10 +-
>  drivers/scsi/csiostor/csio_scsi.c           |   5 +-
>  drivers/scsi/cxlflash/main.c                |  10 +-
>  drivers/scsi/dc395x.c                       |  25 ++--
>  drivers/scsi/esas2r/esas2r.h                |   8 +-
>  drivers/scsi/esas2r/esas2r_main.c           |  55 +++----
>  drivers/scsi/esp_scsi.c                     |   8 +-
>  drivers/scsi/fdomain.c                      |   3 +-
>  drivers/scsi/fnic/fnic.h                    |   4 +-
>  drivers/scsi/fnic/fnic_scsi.c               |   8 +-
>  drivers/scsi/hpsa.c                         |  14 +-
>  drivers/scsi/hptiop.c                       |   6 +-
>  drivers/scsi/ibmvscsi/ibmvfc.c              |  15 +-
>  drivers/scsi/ibmvscsi/ibmvscsi.c            |  23 +--
>  drivers/scsi/imm.c                          |   4 +-
>  drivers/scsi/initio.c                       |  11 +-
>  drivers/scsi/ipr.c                          |  26 ++--
>  drivers/scsi/ips.c                          |  22 +--
>  drivers/scsi/libfc/fc_fcp.c                 |  18 +--
>  drivers/scsi/libiscsi.c                     |  19 ++-
>  drivers/scsi/libsas/sas_scsi_host.c         |  21 +--
>  drivers/scsi/lpfc/lpfc_scsi.c               |  23 ++-
>  drivers/scsi/mac53c94.c                     |   8 +-
>  drivers/scsi/megaraid.c                     |   4 +-
>  drivers/scsi/megaraid.h                     |   2 +-
>  drivers/scsi/megaraid/megaraid_mbox.c       |  14 +-
>  drivers/scsi/megaraid/megaraid_sas.h        |   3 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  44 +++---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  54 ++++---
>  drivers/scsi/mesh.c                         |  10 +-
>  drivers/scsi/mpi3mr/mpi3mr_os.c             | 135 ++++++++---------
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  72 ++++-----
>  drivers/scsi/mvumi.c                        |   7 +-
>  drivers/scsi/myrb.c                         |   3 +-
>  drivers/scsi/myrs.c                         |   3 +-
>  drivers/scsi/ncr53c8xx.c                    |   4 +-
>  drivers/scsi/nsp32.c                        |  12 +-
>  drivers/scsi/pcmcia/nsp_cs.c                |  10 +-
>  drivers/scsi/pcmcia/nsp_cs.h                |   6 +-
>  drivers/scsi/pcmcia/qlogic_stub.c           |   4 +-
>  drivers/scsi/pcmcia/sym53c500_cs.c          |   8 +-
>  drivers/scsi/pmcraid.c                      |  27 ++--
>  drivers/scsi/ppa.c                          |   4 +-
>  drivers/scsi/qedf/qedf_main.c               |  13 +-
>  drivers/scsi/qedi/qedi_iscsi.c              |   3 +-
>  drivers/scsi/qla1280.c                      |  36 +++--
>  drivers/scsi/qla2xxx/qla_os.c               |  83 +++++------
>  drivers/scsi/qla4xxx/ql4_os.c               |  54 +++----
>  drivers/scsi/qlogicfas408.c                 |  10 +-
>  drivers/scsi/qlogicfas408.h                 |   2 +-
>  drivers/scsi/qlogicpti.c                    |   3 +-
>  drivers/scsi/scsi_debug.c                   |  33 ++---
>  drivers/scsi/scsi_error.c                   | 153 ++++++++++----------
>  drivers/scsi/scsi_lib.c                     |   2 -
>  drivers/scsi/smartpqi/smartpqi.h            |   1 -
>  drivers/scsi/smartpqi/smartpqi_init.c       |  19 +--
>  drivers/scsi/snic/snic.h                    |   5 +-
>  drivers/scsi/snic/snic_scsi.c               |  41 ++----
>  drivers/scsi/stex.c                         |   7 +-
>  drivers/scsi/storvsc_drv.c                  |   4 +-
>  drivers/scsi/sym53c8xx_2/sym_glue.c         |  13 +-
>  drivers/scsi/virtio_scsi.c                  |  12 +-
>  drivers/scsi/vmw_pvscsi.c                   |  20 ++-
>  drivers/scsi/wd33c93.c                      |   5 +-
>  drivers/scsi/wd33c93.h                      |   2 +-
>  drivers/scsi/wd719x.c                       |  17 ++-
>  drivers/scsi/xen-scsifront.c                |   6 +-
>  drivers/staging/rts5208/rtsx.c              |   6 +-
>  drivers/target/loopback/tcm_loop.c          |  17 ++-
>  drivers/ufs/core/ufshcd.c                   |  14 +-
>  drivers/usb/image/microtek.c                |   4 +-
>  drivers/usb/storage/scsiglue.c              |   8 +-
>  drivers/usb/storage/uas.c                   |   3 +-
>  include/scsi/libfc.h                        |   4 +-
>  include/scsi/libiscsi.h                     |   4 +-
>  include/scsi/libsas.h                       |   4 +-
>  include/scsi/scsi_cmnd.h                    |   1 -
>  include/scsi/scsi_host.h                    |   8 +-
>  108 files changed, 921 insertions(+), 1009 deletions(-)
>
> --
> 2.35.3
>
