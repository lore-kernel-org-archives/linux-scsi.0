From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] qla2xxx: Drop pre 24xx target mode support
Date: Thu,  9 Feb 2012 02:45:32 +0000
Message-ID: <1328755534-8668-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Folks,

The following is the first series to remove pre qla24xx (eg: legacy PCI-X)
support for target mode operation in lio-core.git.  This was requested by
hch to help reduce complexity + total LOC for a future upstream merge.

These changes have been in lio-core.git/master recently, and can use
more testing to ensure we're not running into regressions.  Also, there
are still a number of cases where union isp2[x4] is used interchangeably
in HW structure definitions that has been left in place for now in
qla_target.[c,h] code.

It would be helpful for the Qlogic Linux Team to comment on what they
prefer here for follow existing qla2xxx LLD conventions.

Thanks!

--nab

Nicholas Bellinger (2):
  qla2xxx: Drop legacy pre 24xx target mode support
  qla2xxx: Drop legacy target mode MODIFY_LUN_TYPE usage

 drivers/scsi/qla2xxx/qla_init.c   |    9 -
 drivers/scsi/qla2xxx/qla_isr.c    |    6 -
 drivers/scsi/qla2xxx/qla_mbx.c    |    8 +-
 drivers/scsi/qla2xxx/qla_mid.c    |    4 -
 drivers/scsi/qla2xxx/qla_target.c | 1285 +++++++++----------------------------
 drivers/scsi/qla2xxx/qla_target.h |  163 -----
 6 files changed, 290 insertions(+), 1185 deletions(-)

-- 
1.7.2.5
