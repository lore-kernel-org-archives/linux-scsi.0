Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14A3E743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbjJBP73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238323AbjJBP72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:59:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72916F0
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:59:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A182421866;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696262357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=uxhQvceLcM33GPL3rAML/cEKKncmRtZFs+VpjwrfXSk=;
        b=Xq1kaHoyeQIm8z5ffqN++uFNWzF97j1st3MsUMInRFPjUyb0w6c4ma9NWvz6UxvTwovb0Q
        X95G8taaEpDKceVk3kRGk7Dewjx/bkHD8JOvlay8WIYIJ90G7HtbfxERKJDH58kG3L4uQu
        64lxegYOvl/j8Ph670xk1pyNkmUOHPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696262357;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=uxhQvceLcM33GPL3rAML/cEKKncmRtZFs+VpjwrfXSk=;
        b=AWA3IJtrnVmQnmo4GU2EbTte9HJDEIWpBjT553hRIAzdgBd6Fb6QA1jx2lRzhQtKsMuRQM
        1KRg3+2Q8aE6qJAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4C0962C142;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 5DFDD51E757E; Mon,  2 Oct 2023 17:59:17 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 0/7] scsi: EH rework, main part
Date:   Mon,  2 Oct 2023 17:59:08 +0200
Message-Id: <20231002155915.109359-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

(taking up an old thread:)
here's now the main part of my EH rework.
It modifies the reset callbacks for SCSI EH such that
each callback (eh_host_reset_handler, eh_bus_reset_handler,
eh_target_reset_handler, eh_device_reset_handler) only
references the actual entity it needs to work on
(ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
and the 'struct scsi_cmnd' is dropped from the argument list.
This simplifies the handler themselves as they don't need to
exclude some 'magic' command, and we don't need to allocate
a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.

The entire patchset can be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
branch eh-rework.v5

As usual, comments and reviews are welcome.

Hannes Reinecke (7):
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  scsi: Use Scsi_Host and channel number as argument for
    eh_bus_reset_handler()
  scsi: Use scsi_target as argument for eh_target_reset_handler()
  scsi: Use scsi_device as argument to eh_device_reset_handler()
  scsi: Do not allocate scsi command in scsi_ioctl_reset()
  scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
  scsi_error: streamline scsi_eh_bus_device_reset()

 Documentation/scsi/scsi_eh.rst              |  16 +-
 Documentation/scsi/scsi_mid_low_api.rst     |  31 +++-
 drivers/infiniband/ulp/srp/ib_srp.c         |  12 +-
 drivers/message/fusion/mptfc.c              |  25 ++--
 drivers/message/fusion/mptsas.c             |  12 +-
 drivers/message/fusion/mptscsih.c           |  86 +++++------
 drivers/message/fusion/mptscsih.h           |   8 +-
 drivers/message/fusion/mptspi.c             |  10 +-
 drivers/s390/scsi/zfcp_scsi.c               |  16 +-
 drivers/scsi/3w-9xxx.c                      |  11 +-
 drivers/scsi/3w-sas.c                       |  11 +-
 drivers/scsi/3w-xxxx.c                      |  11 +-
 drivers/scsi/53c700.c                       |  39 ++---
 drivers/scsi/BusLogic.c                     |  14 +-
 drivers/scsi/NCR5380.c                      |   3 +-
 drivers/scsi/a100u2w.c                      |  11 +-
 drivers/scsi/aacraid/linit.c                |  35 ++---
 drivers/scsi/advansys.c                     |  26 ++--
 drivers/scsi/aha152x.c                      |  10 +-
 drivers/scsi/aha1542.c                      |  30 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.c          |  37 ++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |  10 +-
 drivers/scsi/arcmsr/arcmsr_hba.c            |   6 +-
 drivers/scsi/arm/acornscsi.c                |   8 +-
 drivers/scsi/arm/fas216.c                   |  18 +--
 drivers/scsi/arm/fas216.h                   |  17 ++-
 drivers/scsi/atari_scsi.c                   |   4 +-
 drivers/scsi/be2iscsi/be_main.c             |  12 +-
 drivers/scsi/bfa/bfad_im.c                  |   8 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  10 +-
 drivers/scsi/csiostor/csio_scsi.c           |   5 +-
 drivers/scsi/cxlflash/main.c                |  10 +-
 drivers/scsi/dc395x.c                       |  25 ++--
 drivers/scsi/esas2r/esas2r.h                |   8 +-
 drivers/scsi/esas2r/esas2r_main.c           |  55 +++----
 drivers/scsi/esp_scsi.c                     |   8 +-
 drivers/scsi/fdomain.c                      |   3 +-
 drivers/scsi/fnic/fnic.h                    |   4 +-
 drivers/scsi/fnic/fnic_scsi.c               |   8 +-
 drivers/scsi/hpsa.c                         |  14 +-
 drivers/scsi/hptiop.c                       |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  15 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  23 +--
 drivers/scsi/imm.c                          |   4 +-
 drivers/scsi/initio.c                       |  11 +-
 drivers/scsi/ipr.c                          |  26 ++--
 drivers/scsi/ips.c                          |  22 +--
 drivers/scsi/libfc/fc_fcp.c                 |  18 +--
 drivers/scsi/libiscsi.c                     |  19 ++-
 drivers/scsi/libsas/sas_scsi_host.c         |  21 +--
 drivers/scsi/lpfc/lpfc_scsi.c               |  23 ++-
 drivers/scsi/mac53c94.c                     |   8 +-
 drivers/scsi/megaraid.c                     |   4 +-
 drivers/scsi/megaraid.h                     |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  14 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  44 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  54 ++++---
 drivers/scsi/mesh.c                         |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c             | 135 ++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  72 ++++-----
 drivers/scsi/mvumi.c                        |   7 +-
 drivers/scsi/myrb.c                         |   3 +-
 drivers/scsi/myrs.c                         |   3 +-
 drivers/scsi/ncr53c8xx.c                    |   4 +-
 drivers/scsi/nsp32.c                        |  12 +-
 drivers/scsi/pcmcia/nsp_cs.c                |  10 +-
 drivers/scsi/pcmcia/nsp_cs.h                |   6 +-
 drivers/scsi/pcmcia/qlogic_stub.c           |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |   8 +-
 drivers/scsi/pmcraid.c                      |  27 ++--
 drivers/scsi/ppa.c                          |   4 +-
 drivers/scsi/qedf/qedf_main.c               |  13 +-
 drivers/scsi/qedi/qedi_iscsi.c              |   3 +-
 drivers/scsi/qla1280.c                      |  36 +++--
 drivers/scsi/qla2xxx/qla_os.c               |  83 +++++------
 drivers/scsi/qla4xxx/ql4_os.c               |  54 +++----
 drivers/scsi/qlogicfas408.c                 |  10 +-
 drivers/scsi/qlogicfas408.h                 |   2 +-
 drivers/scsi/qlogicpti.c                    |   3 +-
 drivers/scsi/scsi_debug.c                   |  33 ++---
 drivers/scsi/scsi_error.c                   | 153 ++++++++++----------
 drivers/scsi/scsi_lib.c                     |   2 -
 drivers/scsi/smartpqi/smartpqi.h            |   1 -
 drivers/scsi/smartpqi/smartpqi_init.c       |  19 +--
 drivers/scsi/snic/snic.h                    |   5 +-
 drivers/scsi/snic/snic_scsi.c               |  41 ++----
 drivers/scsi/stex.c                         |   7 +-
 drivers/scsi/storvsc_drv.c                  |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  13 +-
 drivers/scsi/virtio_scsi.c                  |  12 +-
 drivers/scsi/vmw_pvscsi.c                   |  20 ++-
 drivers/scsi/wd33c93.c                      |   5 +-
 drivers/scsi/wd33c93.h                      |   2 +-
 drivers/scsi/wd719x.c                       |  17 ++-
 drivers/scsi/xen-scsifront.c                |   6 +-
 drivers/staging/rts5208/rtsx.c              |   6 +-
 drivers/target/loopback/tcm_loop.c          |  17 ++-
 drivers/ufs/core/ufshcd.c                   |  14 +-
 drivers/usb/image/microtek.c                |   4 +-
 drivers/usb/storage/scsiglue.c              |   8 +-
 drivers/usb/storage/uas.c                   |   3 +-
 include/scsi/libfc.h                        |   4 +-
 include/scsi/libiscsi.h                     |   4 +-
 include/scsi/libsas.h                       |   4 +-
 include/scsi/scsi_cmnd.h                    |   1 -
 include/scsi/scsi_host.h                    |   8 +-
 108 files changed, 921 insertions(+), 1009 deletions(-)

-- 
2.35.3

