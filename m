Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCB7C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjJWJ2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjJWJ2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:28:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703DC97
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:28:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 11BFF1FE13;
        Mon, 23 Oct 2023 09:28:43 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B81D2CF4F;
        Mon, 23 Oct 2023 09:28:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C61B751EC342; Mon, 23 Oct 2023 11:28:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 00/10] scsi: EH rework, main part
Date:   Mon, 23 Oct 2023 11:28:27 +0200
Message-Id: <20231023092837.33786-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [2.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCPT_COUNT_FIVE(0.00)[5];
         R_SPF_SOFTFAIL(0.60)[~all];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: 11BFF1FE13
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
branch eh-rework.v8

As usual, comments and reviews are welcome.

Changes to v6:
- Include reviews from Bart
- Add patch to return -EAGAIN from scsi_ioctl_reset()

Changes to v5:
- Improve description for patch to modify scsi_eh_bus_device_reset()
- Add patch to modify the iteratrion in scsi_eh_bus_reset()

Hannes Reinecke (10):
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  scsi: Use Scsi_Host and channel number as argument for
    eh_bus_reset_handler()
  scsi: Use scsi_target as argument for eh_target_reset_handler()
  scsi: Use scsi_device as argument to eh_device_reset_handler()
  scsi: set host byte after EH completed
  scsi_error: iterate over list of failed commands in
    scsi_eh_bus_reset()
  scsi: Do not allocate scsi command in scsi_ioctl_reset()
  scsi_error: iterate over list of failed commands in
    scsi_eh_bus_device_reset()
  scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
  scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL

 Documentation/scsi/scsi_eh.rst              |  15 +-
 Documentation/scsi/scsi_mid_low_api.rst     |  35 ++-
 drivers/infiniband/ulp/srp/ib_srp.c         |  12 +-
 drivers/message/fusion/mptfc.c              |  25 +-
 drivers/message/fusion/mptsas.c             |  10 +-
 drivers/message/fusion/mptscsih.c           | 114 +++------
 drivers/message/fusion/mptscsih.h           |   8 +-
 drivers/message/fusion/mptspi.c             |   8 +-
 drivers/s390/scsi/zfcp_scsi.c               |  16 +-
 drivers/scsi/3w-9xxx.c                      |  11 +-
 drivers/scsi/3w-sas.c                       |  11 +-
 drivers/scsi/3w-xxxx.c                      |  13 +-
 drivers/scsi/53c700.c                       |  39 +--
 drivers/scsi/BusLogic.c                     |  24 +-
 drivers/scsi/NCR5380.c                      |   5 +-
 drivers/scsi/a100u2w.c                      |  14 +-
 drivers/scsi/aacraid/linit.c                |  41 ++-
 drivers/scsi/advansys.c                     |  28 ++-
 drivers/scsi/aha152x.c                      |  10 +-
 drivers/scsi/aha1542.c                      |  28 +--
 drivers/scsi/aic7xxx/aic79xx_osm.c          |  37 ++-
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |  10 +-
 drivers/scsi/arcmsr/arcmsr_hba.c            |   8 +-
 drivers/scsi/arm/acornscsi.c                |   8 +-
 drivers/scsi/arm/fas216.c                   |  24 +-
 drivers/scsi/arm/fas216.h                   |  17 +-
 drivers/scsi/atari_scsi.c                   |   4 +-
 drivers/scsi/be2iscsi/be_main.c             |  12 +-
 drivers/scsi/bfa/bfad_im.c                  |   8 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  14 +-
 drivers/scsi/csiostor/csio_scsi.c           |   5 +-
 drivers/scsi/cxlflash/main.c                |  10 +-
 drivers/scsi/dc395x.c                       |  24 +-
 drivers/scsi/esas2r/esas2r.h                |   8 +-
 drivers/scsi/esas2r/esas2r_main.c           |  57 +++--
 drivers/scsi/esp_scsi.c                     |   9 +-
 drivers/scsi/fdomain.c                      |   3 +-
 drivers/scsi/fnic/fnic.h                    |   4 +-
 drivers/scsi/fnic/fnic_scsi.c               |  12 +-
 drivers/scsi/hpsa.c                         |  14 +-
 drivers/scsi/hptiop.c                       |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  19 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  25 +-
 drivers/scsi/imm.c                          |   6 +-
 drivers/scsi/initio.c                       |  14 +-
 drivers/scsi/ipr.c                          |  29 ++-
 drivers/scsi/ips.c                          |  30 +--
 drivers/scsi/libfc/fc_fcp.c                 |  18 +-
 drivers/scsi/libiscsi.c                     |  21 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  21 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |  29 ++-
 drivers/scsi/mac53c94.c                     |   8 +-
 drivers/scsi/megaraid.c                     |   6 +-
 drivers/scsi/megaraid.h                     |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  18 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  60 ++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  55 +++--
 drivers/scsi/mesh.c                         |  12 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c             | 134 +++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  82 +++---
 drivers/scsi/mvumi.c                        |   9 +-
 drivers/scsi/myrb.c                         |   3 +-
 drivers/scsi/myrs.c                         |   3 +-
 drivers/scsi/ncr53c8xx.c                    |   4 +-
 drivers/scsi/nsp32.c                        |  14 +-
 drivers/scsi/pcmcia/nsp_cs.c                |  10 +-
 drivers/scsi/pcmcia/nsp_cs.h                |   6 +-
 drivers/scsi/pcmcia/qlogic_stub.c           |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |   8 +-
 drivers/scsi/pmcraid.c                      |  36 ++-
 drivers/scsi/ppa.c                          |   6 +-
 drivers/scsi/qedf/qedf_main.c               |  13 +-
 drivers/scsi/qedi/qedi_iscsi.c              |   3 +-
 drivers/scsi/qla1280.c                      |  74 +++---
 drivers/scsi/qla2xxx/qla_os.c               |  85 +++----
 drivers/scsi/qla4xxx/ql4_os.c               |  58 ++---
 drivers/scsi/qlogicfas408.c                 |  10 +-
 drivers/scsi/qlogicfas408.h                 |   2 +-
 drivers/scsi/qlogicpti.c                    |   3 +-
 drivers/scsi/scsi_debug.c                   |  54 ++--
 drivers/scsi/scsi_error.c                   | 260 ++++++++++----------
 drivers/scsi/scsi_lib.c                     |   2 -
 drivers/scsi/smartpqi/smartpqi.h            |   1 -
 drivers/scsi/smartpqi/smartpqi_init.c       |  19 +-
 drivers/scsi/snic/snic.h                    |   5 +-
 drivers/scsi/snic/snic_scsi.c               |  41 +--
 drivers/scsi/stex.c                         |   9 +-
 drivers/scsi/storvsc_drv.c                  |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  14 +-
 drivers/scsi/virtio_scsi.c                  |  12 +-
 drivers/scsi/vmw_pvscsi.c                   |  20 +-
 drivers/scsi/wd33c93.c                      |   8 +-
 drivers/scsi/wd33c93.h                      |   2 +-
 drivers/scsi/wd719x.c                       |  17 +-
 drivers/scsi/xen-scsifront.c                |   6 +-
 drivers/staging/rts5208/rtsx.c              |   6 +-
 drivers/target/loopback/tcm_loop.c          |  17 +-
 drivers/ufs/core/ufshcd.c                   |  18 +-
 drivers/usb/image/microtek.c                |   4 +-
 drivers/usb/storage/scsiglue.c              |   8 +-
 drivers/usb/storage/uas.c                   |   3 +-
 include/scsi/libfc.h                        |   4 +-
 include/scsi/libiscsi.h                     |   4 +-
 include/scsi/libsas.h                       |   4 +-
 include/scsi/scsi_cmnd.h                    |   1 -
 include/scsi/scsi_eh.h                      |   2 +-
 include/scsi/scsi_host.h                    |   8 +-
 109 files changed, 1038 insertions(+), 1223 deletions(-)

-- 
2.35.3

