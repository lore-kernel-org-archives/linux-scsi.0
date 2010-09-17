From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: Add native 32-byte CDB support
Date: Thu, 16 Sep 2010 22:34:34 -0700
Message-ID: <1284701674-18323-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mi
Cc: Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings jejb, mkp and Co,

This patch series adds support for native 32-byte CDB processing into TCM Core,
TCM subsystem plugins, and TCM_Loop virtual SCSI LLD.

The first patch adds the new TCM_MAX_COMMAND_SIZE=32 defintion and adds the necessary
LBA + transfer length extraction and generation methods for 32-byte CDBs following
SBC-4.  This includes converting FILEIO, IBLOCK, PSCSI, RAMDISK and STGT subsystem
plugins to use the new TCM_MAX_COMMAND_SIZE value for their own per struct se_task
context descriptor internal inline CDB size defines.

The second patch adds proper VARIABLE_LENGTH_CMD support together with XDWRITE_READ_32
emulation following the recent patch adding support for XDWRITE_READ_10.

And the third and final patch updates the TCM_Loop fabric module to signal the
Linux/SCSI midlayer that we are now capable of processing up to 32-byte CDBs.

Also, I ended up adding support for XDWRITE_READ_32 into Tomo's sgv4-utils.git in
order to test this series.  Please have look and let me know what you think Tomo!

http://linux-iscsi.org/builds/user/nab/0001-sgv4_xdwriteread-Add-support-for-XDWRITEREAD_32.patch

Many thanks to jejb and mkp for answering my questions about > 16 byte CDB support!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add native 32-byte CDB support
  tcm: Add VARIABLE_LENGTH_CMD support w/ XDWRITE_READ_32 emulation
  tcm_loop: Enable 32-byte CDB support in virtual SCSI LLD

 drivers/target/target_core_file.h       |    2 +-
 drivers/target/target_core_iblock.h     |    2 +-
 drivers/target/target_core_pscsi.c      |    2 +-
 drivers/target/target_core_pscsi.h      |    2 +-
 drivers/target/target_core_rd.h         |    2 +-
 drivers/target/target_core_scdb.c       |   38 ++++++++++++
 drivers/target/target_core_scdb.h       |    2 +
 drivers/target/target_core_stgt.h       |    2 +-
 drivers/target/target_core_transport.c  |   94 +++++++++++++++++++++++++++----
 drivers/target/tcm_loop/tcm_loop_core.h |    2 +-
 include/target/target_core_base.h       |   13 ++++
 11 files changed, 142 insertions(+), 19 deletions(-)
