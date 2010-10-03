From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] tcm: Add WRITE_SAME_16 support w/ UNMAP=1 emulation
Date: Sat,  2 Oct 2010 17:53:32 -0700
Message-ID: <1286067212-14449-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series adds initial support for WRITE_SAME_16 w/ UNMAP=1 emulation into
TCM/IBLOCK and TCM/FILEIO subsystem plugins using generic Block Discard logic.
This also includes proper TCM/pSCSI passthrough support to handle all possible
flavours of WRITE_SAME_16 for underlying HW that supports it.

The main items to note here for the IBLOCK+FILEIO emulated (eg: not passthrough)
case are:

	*) WRITE_SAME_16 w/ PBDATA and LBDATA will return INVALID_FIELD_IN_CDB
	*) WRITE_SAME_16 w/o UNMAP=1 will return INVALID_FIELD_IN_CDB
	*) WRITE_SAME_16 w/ UNMAP=1 will make IBLOCK+FILEIO call
	   transport_generic_write_same(), and not actually write the
	   received payload.

The first patch adds the main WRITE_SAME_16 pieces into TCM_Core, adds the new
emulate_tpws device attribute, and updates Block Limits VPD, Thin Provisioning
VPD and READ_CAPACITY_* to take emulate_tpws=1 into account to signal/handle
SBC-3 TPE=1 operation.

The second patch adds support into IBLOCK + FILEIO for using the TCM Core provided
transport_generic_write_same(), and will set both DEV_ATTRIB(dev)->emulate_tp[ws,u]=1
when blk_queue_discard()==1 signals underlying HW supports some flavour of TPE.

So far this series been tested with TCM_Loop -> (IBLOCK,FILEIO,pSCSI) -> scsi_debug
on v2.6.36-rc6 using explict 'sg_write_same -S' callers via SG_IO.

Once again, many thanks to mkp for sharing his knowledge of this area!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm: Add WRITE_SAME_16 emulation and passthrough support
  tcm/iblock,fileio: Add WRITE_SAME_16 w/ UNMAP=1 bit support

 drivers/target/target_core_configfs.c  |    4 +
 drivers/target/target_core_device.c    |   15 +++++-
 drivers/target/target_core_file.c      |   47 +++++++++++++++-
 drivers/target/target_core_iblock.c    |   21 +++++++-
 drivers/target/target_core_transport.c |   99 ++++++++++++++++++++++++++++++--
 include/target/target_core_base.h      |    5 +-
 include/target/target_core_device.h    |    1 +
 include/target/target_core_transport.h |    6 ++
 8 files changed, 189 insertions(+), 9 deletions(-)
