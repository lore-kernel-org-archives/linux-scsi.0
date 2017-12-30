From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 0/9] scsi: Use zeroing allocators than allocator/memset
Date: Sat, 30 Dec 2017 20:58:23 +0530
Message-ID: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

There are many instances where a region of memory is allocated using
allocator functions and immediately the region of memory is zeroed using
memset function.

We already have zeroing memory allocator function for that purpose and
replacing the currently used allocator functions with zeroing allocators
will make code cleaner, easier to read, and also reduce the code size.

For eg:

Before:
himanshu@himanshu-Vostro-3559:~/linux-next$ size drivers/scsi/bnx2fc/bnx2fc_hwi.o
   text    data     bss     dec     hex filename
  40783    5940      64   46787    b6c3 drivers/scsi/bnx2fc/bnx2fc_hwi.o

After: 
himanshu@himanshu-Vostro-3559:~/linux-next$ size drivers/scsi/bnx2fc/bnx2fc_hwi.o
   text    data     bss     dec     hex filename
  40619    5940      64   46623    b61f drivers/scsi/bnx2fc/bnx2fc_hwi.o

Also, all these patches have been tested using 0-day test service with
zero build failures.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
Link: https://lkml.org/lkml/2017/12/26/205

Himanshu Jha (9):
  scsi: qla4xxx: Use zeroing allocator rather than allocator/memset
  scsi: qla2xxx: Use zeroing allocator rather than allocator/memset
  scsi: qedi: Use zeroing allocator instead of allocator/memset
  scsi: mvsas: Use zeroing allocator rather than allocator/memset
  scsi: fnic: Use zeroing allocator rather than allocator/memset
  scsi: dpt_i2o: Use zeroing allocator rather than allocator/memset
  scsi: bnx2fc: Use zeroing allocator rather than allocator/memset
  scsi: bfa: Use zeroing allocator rather than allocator/memset
  scsi: bnx2i: Use zeroing allocator rather than allocator/memset

 drivers/scsi/bfa/bfad.c            |  3 +-
 drivers/scsi/bfa/bfad_debugfs.c    |  8 ++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   | 60 ++++++++++++++++----------------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c   | 51 ++++++++++++++------------------
 drivers/scsi/bnx2i/bnx2i_hwi.c     | 14 ++++-----
 drivers/scsi/dpt_i2o.c             | 19 +++++-------
 drivers/scsi/fnic/fnic_debugfs.c   | 10 ++-----
 drivers/scsi/fnic/fnic_trace.c     |  9 ++----
 drivers/scsi/mvsas/mv_init.c       | 27 +++++++----------
 drivers/scsi/qedi/qedi_main.c      | 42 ++++++++++----------------
 drivers/scsi/qla2xxx/qla_attr.c    |  5 ++--
 drivers/scsi/qla2xxx/qla_bsg.c     |  9 ++----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  5 +---
 drivers/scsi/qla4xxx/ql4_init.c    |  5 ++--
 drivers/scsi/qla4xxx/ql4_mbx.c     | 21 ++++++-------
 drivers/scsi/qla4xxx/ql4_nx.c      |  5 ++--
 drivers/scsi/qla4xxx/ql4_os.c      | 12 ++++----
 17 files changed, 118 insertions(+), 187 deletions(-)

-- 
2.7.4
