From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 0/4] [FCoE] Remove sa_hash_xxx:series short description
Date: Wed, 13 Feb 2008 11:09:47 -0800
Message-ID: <20080213190608.23885.66646.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710AbYBMTYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:24:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

The following series remove use of all sa_hash_xxx in hash table operations
for fc_local_port, fc_remote_port, and fc_sess. sa_hash_kern.c and sa_hash.h
are removed. All abstraction using sa_hash_xxx are removed and replaced by
using hlist_head, hlist_node directly. Hash functions are in their own module
now for fc_remote_port and fc_sess.

For fc_local_port, the hash is completely removed since there is always going
to be just one fc_local_port per openfc/fcoe. For fc_remote_port, the hash by
wwpn is removed with hash by remote port FCID already there. Hash entry
counters are removed as they are used only in debugging/printting routines.
All debugging/testing functions, e.g. hash table iterate, print, are removed
as well.

Note that fc_virt_fab struct is still the place holder for the hash tables,
which eventually will be in fcs_state struct once fc_virt_fab is merged with
the fcs_state struct.

---

Yi Zou (4):
      [FCoE] 4. remove sa_hash_kern.c/sa_hash.h
      [FCoE] 3. remove hash table for fc_local_port
      [FCoE] 2. hash for fc_sess: do not use sa_hash_xxx
      [FCoE] 1. hash for fc_remote_port: do not use sa_hash_xxx


 drivers/scsi/ofc/include/fc_local_port.h    |    6 
 drivers/scsi/ofc/include/fc_remote_port.h   |    4 
 drivers/scsi/ofc/include/fc_sess.h          |    3 
 drivers/scsi/ofc/include/sa_hash.h          |   65 -----
 drivers/scsi/ofc/libfc/fc_exch.c            |    1 
 drivers/scsi/ofc/libfc/fc_local_port.c      |   85 -------
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |    4 
 drivers/scsi/ofc/libfc/fc_remote_port.c     |  325 ++++++++++++---------------
 drivers/scsi/ofc/libfc/fc_sess.c            |  214 +++++++++++-------
 drivers/scsi/ofc/libfc/fc_sess_impl.h       |    3 
 drivers/scsi/ofc/libfc/fc_virt_fab.c        |    5 
 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h   |   10 -
 drivers/scsi/ofc/libsa/Makefile             |    4 
 drivers/scsi/ofc/libsa/sa_hash_kern.c       |  141 ------------
 14 files changed, 298 insertions(+), 572 deletions(-)
 delete mode 100644 drivers/scsi/ofc/include/sa_hash.h
 delete mode 100644 drivers/scsi/ofc/libsa/sa_hash_kern.c

-- 
Yi Zou <yi.zou@intel.com>
