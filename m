From: "Love, Robert W" <robert.w.love@intel.com>
Subject: fcoe pull request for 3.12(+)
Date: Thu, 5 Sep 2013 19:12:44 +0000
Message-ID: <5228D7AC.9050904@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12202 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab3IETMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 15:12:46 -0400
Content-Language: en-US
Content-ID: <0BDDC19EE3FBE44C8823B42156D04FAE@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

   Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git tags/show

for you to fetch changes up to 1c2c1b4fbd413fd814807768d2aba9023722ed76:

   fcoe: Reduce fcoe_sysfs_fcf_add() stack usage (2013-09-04 14:14:21 -0700)

----------------------------------------------------------------
Pull request tag for 3.12 merge window.

----------------------------------------------------------------
Bart Van Assche (13):
       libfc: Source code comment spelling fixes
       libfc: Debug code fixes
       libfc: Micro-optimize fc_setup_exch_mgr()
       libfc: Clarify fc_exch_find()
       libfc: Fix a race in fc_exch_timer_set_locked()
       libfc: Protect ep->esb_stat changes via ex_lock
       libfc: Avoid that sending after an abort triggers a kernel warning
       libfc: Reduce exchange lock contention in fc_exch_recv_abts()
       libfc: Do not invoke the response handler after fc_exch_done()
       fcp: Do not interpret check condition as underrun
       fcoe: Declare fcoe_ctlr_mode_set() static
       fcoe: Add missing newlines in debug messages
       fcoe: Reduce fcoe_sysfs_fcf_add() stack usage

Neil Horman (3):
       fcoe: ensure that skb placed on the fip_recv_list are unshared
       fcoe: make sure fcoe frames are unshared prior to manipulating them
       fcoe: cleanup return codes from fcoe_rcv

  drivers/scsi/fcoe/fcoe.c       |   22 ++--
  drivers/scsi/fcoe/fcoe_ctlr.c  |   47 +++++---
  drivers/scsi/fcoe/fcoe_sysfs.c |   12 +-
  drivers/scsi/libfc/fc_exch.c   |  251 
++++++++++++++++++++++++++--------------
  drivers/scsi/libfc/fc_fcp.c    |   10 +-
  drivers/scsi/libfc/fc_lport.c  |    4 +-
  drivers/scsi/libfc/fc_rport.c  |    6 +-
  include/scsi/fc/fc_fc2.h       |    2 +-
  include/scsi/libfc.h           |    9 ++
  9 files changed, 229 insertions(+), 134 deletions(-)