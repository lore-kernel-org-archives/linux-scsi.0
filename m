From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 28 May 2014 03:54:29 -0700
Message-ID: <20140528105429.GA20549@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140520100343.31490551@canb.auug.org.au>
 <20140520053928.GA1751@infradead.org>
 <20140521094636.515289e8@canb.auug.org.au>
 <1400639101.2481.19.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400639101.2481.19.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I've pushed the following changes to the drivers-for-3.16 tree.  I've
there's anyting matching the rules that I did forget please resend
and/or ping me.


----------------------------------------------------------------
Benoit Taine (2):
      qla4xxx: Use kmemdup instead of kmalloc + memcpy
      qla2xxx: Use kmemdup instead of kmalloc + memcpy

Dan Carpenter (1):
      qla2xxx: fix incorrect debug printk

Dolev Raviv (4):
      scsi: ufs: query descriptor API
      scsi: ufs: device query status and size check
      scsi: ufs: Logical Unit (LU) command queue depth
      scsi: ufs: Fix queue depth handling for best effort cases

Finn Thain (12):
      scsi/NCR5380: remove unused BOARD_NORMAL and BOARD_NCR53C400
      scsi/NCR5380: remove redundant HOSTS_C macro tests
      scsi/NCR5380: remove old CVS keywords
      scsi/NCR5380: use NCR5380_dprint() instead of NCR5380_print()
      scsi/NCR5380: fix build failures when debugging is enabled
      scsi/NCR5380: fix dprintk macro usage and definition
      scsi/NCR5380: adopt NCR5380_dprint() and NCR5380_dprint_phase()
      scsi/NCR5380: adopt dprintk()
      scsi/NCR5380: fix and standardize NDEBUG macros
      scsi/NCR5380: remove unused macro definitions
      scsi/NCR5380: reduce depth of sun3_scsi nested includes
      scsi/NCR5380: merge sun3_scsi_vme.c into sun3_scsi.c

Jayamohan Kallickal (8):
      be2iscsi: Fix retrieving MCCQ_WRB in non-embedded Mbox path
      be2iscsi: Fix exposing Host in sysfs after adapter initialization is complete
      be2iscsi: Fix interrupt Coalescing mechanism.
      be2iscsi: Fix TCP parameters while connection offloading.
      be2iscsi: Fix memory corruption in MBX path
      be2iscsi: Fix destroy MCC-CQ before MCC-EQ is destroyed
      be2iscsi: Fix processing cqe for cxn whose endpoint is freed
      be2iscsi: Bump the driver version

Joe Handzik (1):
      hpsa: fix bad comparison of signed with unsigned in hpsa_update_scsi_devices

Matthew Wilcox (7):
      mpt3sas: Remove uses of serial_number
      mpt3sas: Remove use of DEF_SCSI_QCMD
      mpt2sas: Remove uses of serial_number
      mpt2sas: Remove use of DEF_SCSI_QCMD
      mpt2sas: Add free smids to the head, not tail of list
      fusion: Add free msg frames to the head, not tail of list
      fusion: Remove use of DEF_SCSI_QCMD

Sujit Reddy Thumma (6):
      scsi: ufs: fix endianness sparse warnings
      scsi: ufs: make undeclared functions static
      scsi: ufs: Fix broken task management command implementation
      scsi: ufs: Fix hardware race conditions while aborting a command
      scsi: ufs: Fix device and host reset methods
      scsi: ufs: Improve UFS fatal error handling

 drivers/message/fusion/mptbase.c     |    2 +-
 drivers/message/fusion/mptfc.c       |   12 +-
 drivers/message/fusion/mptsas.c      |   10 +-
 drivers/message/fusion/mptscsih.c    |    8 +-
 drivers/message/fusion/mptscsih.h    |    2 +-
 drivers/message/fusion/mptspi.c      |   12 +-
 drivers/scsi/NCR5380.c               |  137 +++--
 drivers/scsi/NCR5380.h               |   32 +-
 drivers/scsi/arm/cumana_1.c          |    3 -
 drivers/scsi/arm/oak.c               |    3 -
 drivers/scsi/atari_NCR5380.c         |  162 +++---
 drivers/scsi/atari_scsi.c            |   22 +-
 drivers/scsi/atari_scsi.h            |   93 ---
 drivers/scsi/be2iscsi/be.h           |   11 +
 drivers/scsi/be2iscsi/be_cmds.h      |   31 +-
 drivers/scsi/be2iscsi/be_iscsi.c     |   12 +-
 drivers/scsi/be2iscsi/be_main.c      |   93 ++-
 drivers/scsi/be2iscsi/be_main.h      |    7 +-
 drivers/scsi/be2iscsi/be_mgmt.c      |   64 ++-
 drivers/scsi/be2iscsi/be_mgmt.h      |    2 +
 drivers/scsi/dtc.c                   |    2 -
 drivers/scsi/g_NCR5380.c             |    4 -
 drivers/scsi/g_NCR5380.h             |    7 -
 drivers/scsi/hpsa.c                  |    2 +-
 drivers/scsi/mac_scsi.c              |   10 -
 drivers/scsi/mac_scsi.h              |   10 -
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   24 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   24 +-
 drivers/scsi/pas16.h                 |    3 -
 drivers/scsi/qla2xxx/qla_mbx.c       |    3 +-
 drivers/scsi/qla2xxx/qla_os.c        |    3 +-
 drivers/scsi/qla4xxx/ql4_os.c        |    7 +-
 drivers/scsi/sun3_NCR5380.c          |  156 +++--
 drivers/scsi/sun3_scsi.c             |  238 +++++---
 drivers/scsi/sun3_scsi.h             |  199 +------
 drivers/scsi/sun3_scsi_vme.c         |  588 +------------------
 drivers/scsi/t128.c                  |    4 -
 drivers/scsi/t128.h                  |    7 -
 drivers/scsi/ufs/ufs.h               |   74 ++-
 drivers/scsi/ufs/ufshcd.c            | 1032 +++++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h            |   22 +-
 drivers/scsi/ufs/ufshci.h            |   32 +-
 47 files changed, 1462 insertions(+), 1723 deletions(-)
