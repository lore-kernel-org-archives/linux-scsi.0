Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5135C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F737600D4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhD0Ibv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:31:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhD0Ibt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 10736B009;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/40] SCSI result cleanup, part 2
Date:   Tue, 27 Apr 2021 10:30:06 +0200
Message-Id: <20210427083046.31620-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here is now my alternative approach on how the SCSI result could be
cleaned up. It's based on the observation that two fields (namely
driver_byte and message_byte) are essentially unused.
The driver byte really is an unloved thing, with very few drivers
using it, and not really consistent, either.
It's only DRIVER_SENSE which has a meaning for userspace, and that
just indicates if a sense code is present; as such it can easily
inferred by looking at the sense code itself.
The message byte is a different story, as it's being used internally
by some SCSI parallel drivers. But even here, in the end the message
byte is only ever relevant for SCSI EH, and that just checks if
any message byte is set apart from COMMAND_COMPLETE.
And we have the SCp.Message field, which can be used to hold the
message values for drivers which had been using the message byte
in the SCSI result. If we do that the message byte itself becomes
irrelevant and can be dropped, too.

So with this approach we can stop using the driver_byte and the
message_byte values in the SCSI result, which means we only
have two values (host byte and status byte) left to deal with.

My plan here is move every driver to use accessors for the
remaining bytes in the SCSI result, and with that move the
SCSI result over into two separate values.

A patchset implementing this can be found at:

git://git.kernel.org/pub/scm/linux/kernel/hare/scsi-devel.git
scsi-result-rework

This patchset is the first part of that; later parts will
be posted once this one is accepted.

As it has been noted that there is a confusion between
'status_byte()' (which returns the linux status code) and
'get_status_byte()' (which returns the SAM status code) I've
added another patch to rip out the linux-specific SCSI
status code; they have been obsoleted years ago and it's
time for them to go.

As usual, comments and reviews are welcome.

Changes to v2:
- Include reviews from Finn Thain and Christoph
- Add a new patch to modify response handling in
  scsi_mode_sense() as suggested by Christoph

Changes to v1:
- Drop patches not relevant to this series
- Include reviews from Bart and Doug Gilbert
- Add patch to remove status_byte()

Hannes Reinecke (40):
  st: return error code in st_scsi_execute()
  scsi_ioctl: return error code when blk_rq_map_kern() fails
  scsi: Fixup calling convention for scsi_mode_sense()
  scsi: reshuffle response handling in scsi_mode_sense()
  scsi_dh_alua: check for negative result value
  scsi: stop using DRIVER_ERROR
  scsi: introduce scsi_build_sense()
  scsi: introduce scsi_status_is_check_condition()
  scsi: Kill DRIVER_SENSE
  scsi: do not use DRIVER_INVALID
  scsi_error: use DID_TIME_OUT instead of DRIVER_TIMEOUT
  xen-scsiback: use DID_ERROR instead of DRIVER_ERROR
  xen-scsifront: compability status handling
  scsi: Drop the now obsolete driver_byte definitions
  NCR5380: Fold SCSI message ABORT onto DID_ABORT
  scsi: add get_{status,host}_byte() accessor function
  scsi: add scsi_msg_to_host_byte()
  dc395: use standard macros to set SCSI result
  dc395: translate message bytes
  qlogicfas408: make ql_pcmd() a void function
  qlogicfas408: whitespace cleanup
  qlogicfas408: translate message to host byte status
  nsp32: whitespace cleanup
  nsp32: do not set message byte
  wd33c93: translate message byte to host byte
  mesh: translate message to host byte status
  acornscsi: remove acornscsi_reportstatus()
  acornscsi: translate message byte to host byte
  aha152x: modify done() to use separate status bytes
  aha152x: do not set message byte when calling scsi_done()
  advansys: do not set message byte in SCSI status
  fas216: translate message to host byte status
  fas216: Use get_status_byte() to avoid using linux-specific status
    codes
  FlashPoint: Use standard SCSI definitions
  fdomain: drop last argument to fdomain_finish_cmd()
  fdomain: translate message to host byte status
  scsi: drop message byte helper
  scsi: kill message byte
  target: use standard SAM status types
  scsi: drop obsolete linux-specific SCSI status codes

 Documentation/scsi/scsi_mid_low_api.rst     |   7 +-
 block/bsg-lib.c                             |   2 +-
 block/bsg.c                                 |   4 +-
 block/scsi_ioctl.c                          |  13 +-
 drivers/ata/libata-scsi.c                   |  30 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |   2 +-
 drivers/s390/scsi/zfcp_scsi.c               |   5 +-
 drivers/scsi/3w-9xxx.c                      |   2 +-
 drivers/scsi/3w-xxxx.c                      |   6 +-
 drivers/scsi/53c700.c                       |   6 +-
 drivers/scsi/FlashPoint.c                   | 165 ++++----
 drivers/scsi/NCR5380.c                      |  10 +-
 drivers/scsi/advansys.c                     |   4 -
 drivers/scsi/aha152x.c                      |  33 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c          |  19 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |   1 -
 drivers/scsi/arcmsr/arcmsr_hba.c            |   5 +-
 drivers/scsi/arm/acornscsi.c                |  46 +--
 drivers/scsi/arm/fas216.c                   |  15 +-
 drivers/scsi/ch.c                           |   5 +-
 drivers/scsi/constants.c                    |  15 -
 drivers/scsi/cxlflash/superpipe.c           |   3 +-
 drivers/scsi/dc395x.c                       |  80 ++--
 drivers/scsi/device_handler/scsi_dh_alua.c  |   8 +-
 drivers/scsi/esas2r/esas2r_main.c           |   2 +-
 drivers/scsi/esp_scsi.c                     |   4 +-
 drivers/scsi/fdomain.c                      |  22 +-
 drivers/scsi/hptiop.c                       |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |   2 +-
 drivers/scsi/libiscsi.c                     |   5 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |  54 +--
 drivers/scsi/megaraid.c                     |  20 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  25 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   2 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   1 -
 drivers/scsi/mesh.c                         |   9 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  14 +-
 drivers/scsi/mvumi.c                        |  10 +-
 drivers/scsi/myrb.c                         |  64 +--
 drivers/scsi/myrs.c                         |   9 +-
 drivers/scsi/nsp32.c                        | 419 +++++++++++---------
 drivers/scsi/ps3rom.c                       |   7 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  15 +-
 drivers/scsi/qlogicfas408.c                 | 137 ++++---
 drivers/scsi/scsi.c                         |  11 +-
 drivers/scsi/scsi_debug.c                   |  15 +-
 drivers/scsi/scsi_error.c                   |  70 ++--
 drivers/scsi/scsi_ioctl.c                   |   7 +-
 drivers/scsi/scsi_lib.c                     | 119 +++---
 drivers/scsi/scsi_logging.c                 |  10 +-
 drivers/scsi/scsi_scan.c                    |   6 +-
 drivers/scsi/scsi_transport_sas.c           |   9 +-
 drivers/scsi/scsi_transport_spi.c           |   2 +-
 drivers/scsi/sd.c                           |  63 +--
 drivers/scsi/sd_zbc.c                       |   3 +-
 drivers/scsi/sg.c                           |   9 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |   3 +-
 drivers/scsi/sr.c                           |   4 +-
 drivers/scsi/sr_ioctl.c                     |   6 +-
 drivers/scsi/st.c                           |   8 +-
 drivers/scsi/stex.c                         |   9 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |   6 +-
 drivers/scsi/ufs/ufshcd.c                   |   2 +-
 drivers/scsi/virtio_scsi.c                  |   5 +-
 drivers/scsi/vmw_pvscsi.c                   |   6 -
 drivers/scsi/wd33c93.c                      |  43 +-
 drivers/scsi/xen-scsifront.c                |   8 +-
 drivers/target/loopback/tcm_loop.c          |   1 -
 drivers/target/target_core_alua.c           |   6 +-
 drivers/target/target_core_iblock.c         |   2 +-
 drivers/target/target_core_pr.c             |   8 +-
 drivers/target/target_core_pscsi.c          |   2 +-
 drivers/target/target_core_sbc.c            |  10 +-
 drivers/target/target_core_spc.c            |  14 +-
 drivers/target/target_core_xcopy.c          |   2 +-
 drivers/usb/storage/cypress_atacb.c         |   4 +-
 drivers/xen/xen-scsiback.c                  |  17 +-
 include/scsi/scsi.h                         |  38 +-
 include/scsi/scsi_cmnd.h                    |  38 +-
 include/scsi/scsi_proto.h                   |  22 +-
 include/scsi/sg.h                           |  33 ++
 include/trace/events/scsi.h                 |  48 +--
 82 files changed, 908 insertions(+), 1070 deletions(-)

-- 
2.29.2

