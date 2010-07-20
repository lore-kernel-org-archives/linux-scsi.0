From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] LPFC TM v9.4 forward port to upstream drivers/scsi/lpfc/
Date: Tue, 20 Jul 2010 16:09:32 -0700
Message-ID: <1279667372-12731-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings James and Co,

Attached is the first posting of the WIP code for a LPFC TM v4 API against
upstream lpfc v8.3.12 from the SF net lpfc TM driver.  For those following
along, these changes have been going into lio-core-2.6.git/tcm_lpfc in order
to use explict LPFC sliport and tgtport operation for the new tcm_lpfc module
using the fabric independent configfs control plane in TCM v4.0-rc.  The branch
for the drivers/scsi/lpfc and drivers/target/tcm_lpfc/ is available here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/tcm_lpfc

Please consider these as two seperate patches for upstream.  They are being posted
as is in order to get some early review and feedback on the main changes involved to
make this all go.  Also note for the moment the LPFC_TARGET_MODE stubs have been left
in place for reference until the latest TM v9.5 is merged.  Please ignore them for the
first round of review. 

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  lpfc: Add LPFC TM API v4 WIP
  lpfc: Add TM v9.4 target hooks into LPFC v8.3.12

 drivers/scsi/lpfc/Makefile               |    4 +-
 drivers/scsi/lpfc/lpfc.h                 |   18 +
 drivers/scsi/lpfc/lpfc_attr.c            |   78 ++-
 drivers/scsi/lpfc/lpfc_crtn.h            |   23 +
 drivers/scsi/lpfc/lpfc_ct.c              |   10 +
 drivers/scsi/lpfc/lpfc_debugfs.c         |    4 +
 drivers/scsi/lpfc/lpfc_disc.h            |   21 +
 drivers/scsi/lpfc/lpfc_els.c             |  134 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c         |   74 ++-
 drivers/scsi/lpfc/lpfc_hw.h              |  136 +++-
 drivers/scsi/lpfc/lpfc_init.c            |   18 +
 drivers/scsi/lpfc/lpfc_logmsg.h          |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c            |    9 +
 drivers/scsi/lpfc/lpfc_mem.c             |    8 +
 drivers/scsi/lpfc/lpfc_nportdisc.c       |  140 +++-
 drivers/scsi/lpfc/lpfc_scsi.c            |    4 +
 drivers/scsi/lpfc/lpfc_sli.c             |  223 +++++-
 drivers/scsi/lpfc/lpfc_sli.h             |   40 +
 drivers/scsi/lpfc/lpfc_target_api.c      | 1375 ++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_target_api.h      |  180 ++++
 drivers/scsi/lpfc/lpfc_target_api_base.h |   45 +
 drivers/scsi/lpfc/lpfc_target_mod.h      |  159 ++++
 drivers/scsi/lpfc/lpfc_target_protos.h   |   34 +
 drivers/scsi/lpfc/lpfc_vport.c           |   17 +
 24 files changed, 2732 insertions(+), 23 deletions(-)
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api.c
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_api_base.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_mod.h
 create mode 100755 drivers/scsi/lpfc/lpfc_target_protos.h
