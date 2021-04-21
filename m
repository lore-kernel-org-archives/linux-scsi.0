Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF04CC43462
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A758E61405
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245023AbhDURtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:51690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244977AbhDURsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FD98AF8C;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 00/42] SCSI result cleanup, part 2
Date:   Wed, 21 Apr 2021 19:47:07 +0200
Message-Id: <20210421174749.11221-1-hare@suse.de>
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
in the SCSI result.

So with this approach we can stop using the driver_byte and the
message_byte values in the SCSI result, which means we only
have two values (host byte and status byte) left to deal with.

My plan here is move every driver to use accessors for the
remaining bytes in the SCSI result, and with that move the
SCSI result over into two separate values.

A patchset implementing this can be found at:

git://git.kernel.org/pub/scm/linux/kernel/hare/scsi-devel.git
scsi-result-rework

This patchset is the first part of that, and is intentionally posted
as an RFC as it directly competes with Barts patchset.

As usual, comments and reviews are welcome.

Hannes Reinecke (42):
  st: return error code in st_scsi_execute()
  scsi_ioctl: return error code when blk_rq_map_kern() fails
  scsi_dh_alua: do not interpret DRIVER_ERROR
  scsi: Fixup calling convention for scsi_mode_sense()
  scsi: stop using DRIVER_ERROR
  scsi: introduce scsi_build_sense()
  scsi: Kill DRIVER_SENSE
  scsi: do not use DRIVER_INVALID
  scsi_error: use DID_TIME_OUT instead of DRIVER_TIMEOUT
  xen-scsiback: use DID_ERROR instead of DRIVER_ERROR
  xen-scsifront: compability status handling
  scsi: Drop the now obsolete driver_byte definitions
  scsi: add get_{status,host}_byte() accessor function
  scsi: add scsi_result_is_good()
  NCR5380: use SCSI result accessors
  NCR5380: Fold SCSI message ABORT onto DID_ABORT
  scsi: add translate_msg_byte()
  dc395: use standard macros to set SCSI result
  dc395: translate message bytes
  qlogicfas408: make ql_pcmd() a void function
  qlogicfas408: whitespace cleanup
  qlogicfas408: translate message to host byte status
  nsp32: use standard macros to set SCSI result
  nsp32: whitespace cleanup
  nsp32: do not set message byte
  wd33c93: use standard macros to set SCSI result
  wd33c93: translate message byte to host byte
  mesh: use standard macros to set SCSI result
  mesh: translate message to host byte status
  acornscsi: use standard macros to set SCSI result
  acornscsi: remove acornscsi_reportstatus()
  acornscsi: translate message byte to host byte
  aha152x: modify done() to use separate status bytes
  aha152x: do not set message byte when calling scsi_done()
  advansys: do not set message byte in SCSI status
  advansys: use SCSI result accessors
  fas216: translate message to host byte status
  fas216: convert to SCSI Accessors
  fdomain: drop last argument to fdomain_finish_cmd()
  fdomain: translate message to host byte status
  scsi: drop message byte helper
  scsi: kill message byte

 Documentation/scsi/scsi_mid_low_api.rst     |   7 +-
 block/bsg-lib.c                             |   2 +-
 block/bsg.c                                 |   2 +-
 block/scsi_ioctl.c                          |  11 +-
 drivers/ata/libata-scsi.c                   |  28 +-
 drivers/s390/scsi/zfcp_scsi.c               |   5 +-
 drivers/scsi/3w-xxxx.c                      |   2 +-
 drivers/scsi/NCR5380.c                      |  31 +-
 drivers/scsi/advansys.c                     |  11 +-
 drivers/scsi/aha152x.c                      |  33 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c          |  19 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |   1 -
 drivers/scsi/arcmsr/arcmsr_hba.c            |   1 -
 drivers/scsi/arm/acornscsi.c                |  41 +-
 drivers/scsi/arm/fas216.c                   |  24 +-
 drivers/scsi/ch.c                           |   5 +-
 drivers/scsi/constants.c                    |  15 -
 drivers/scsi/cxlflash/superpipe.c           |   3 +-
 drivers/scsi/dc395x.c                       |  76 ++--
 drivers/scsi/device_handler/scsi_dh_alua.c  |   4 -
 drivers/scsi/esp_scsi.c                     |   4 +-
 drivers/scsi/fdomain.c                      |  22 +-
 drivers/scsi/hptiop.c                       |   2 +-
 drivers/scsi/libiscsi.c                     |   5 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |  54 +--
 drivers/scsi/megaraid.c                     |  18 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  22 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   2 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   1 -
 drivers/scsi/mesh.c                         |  14 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  14 +-
 drivers/scsi/mvumi.c                        |  10 +-
 drivers/scsi/myrb.c                         |  64 +---
 drivers/scsi/myrs.c                         |   9 +-
 drivers/scsi/nsp32.c                        | 397 +++++++++++---------
 drivers/scsi/ps3rom.c                       |   7 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  15 +-
 drivers/scsi/qlogicfas408.c                 | 137 ++++---
 drivers/scsi/scsi.c                         |   9 +-
 drivers/scsi/scsi_debug.c                   |  15 +-
 drivers/scsi/scsi_error.c                   |  22 +-
 drivers/scsi/scsi_ioctl.c                   |   7 +-
 drivers/scsi/scsi_lib.c                     |  48 ++-
 drivers/scsi/scsi_logging.c                 |  10 +-
 drivers/scsi/scsi_scan.c                    |   6 +-
 drivers/scsi/scsi_transport_sas.c           |   9 +-
 drivers/scsi/scsi_transport_spi.c           |   2 +-
 drivers/scsi/sd.c                           |  64 ++--
 drivers/scsi/sd_zbc.c                       |   3 +-
 drivers/scsi/sg.c                           |  11 +-
 drivers/scsi/smartpqi/smartpqi_init.c       |   3 +-
 drivers/scsi/sr.c                           |   4 +-
 drivers/scsi/sr_ioctl.c                     |   6 +-
 drivers/scsi/st.c                           |   8 +-
 drivers/scsi/stex.c                         |   9 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |   6 +-
 drivers/scsi/ufs/ufshcd.c                   |   2 +-
 drivers/scsi/virtio_scsi.c                  |   5 +-
 drivers/scsi/vmw_pvscsi.c                   |   6 -
 drivers/scsi/wd33c93.c                      |  48 +--
 drivers/scsi/xen-scsifront.c                |   9 +-
 drivers/target/loopback/tcm_loop.c          |   1 -
 drivers/usb/storage/cypress_atacb.c         |   4 +-
 drivers/xen/xen-scsiback.c                  |  16 +-
 include/scsi/scsi.h                         |  22 +-
 include/scsi/scsi_cmnd.h                    |  33 +-
 include/scsi/sg.h                           |   4 +
 include/trace/events/scsi.h                 |  48 +--
 68 files changed, 706 insertions(+), 852 deletions(-)

-- 
2.29.2

