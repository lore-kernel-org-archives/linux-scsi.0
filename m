From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/11] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 01 Apr 2011 16:05:48 -0700
Message-ID: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1DAXFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:05:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements bug fixes for libfc,
libfcoe and fcoe.

Included in this series is the patch:

scsi: use list_move() instead of list_del()/list_add() combination

It touches other SCSI files outside of libfc, libfcoe
and fcoe. I just collected it because it touched fcoe. If I
should resend without it, please let me know.

Also, I was unable to re-test all of these patches with 39-rc1.
A driver bug is blocking me. All of the patches were reviewed
and tested before being applied to my tree, but usually I re-test
each patch just before sending to linux-scsi. I wanted to get
these patches out before LSF and don't have time to debug the
driver bug right now. I can test again after LSF if you'd like
to delay applying the patches until then. Even though I am
blocked in my re-test I have high confidence in these patches
otherwise I wouldn't send them out.

---

Kirill A. Shutemov (1):
      scsi: use list_move() instead of list_del()/list_add() combination

Robert Love (3):
      libfcoe: Remove mutex_trylock/restart_syscall checks
      fcoe: Remove mutex_trylock/restart_syscall checks
      libfc: Move host_lock usage into ramp_up/down routines

Vasu Dev (3):
      libfc: remove duplicate ema_list init
      libfc: rec tov value and REC_TOV_CONST units usages is incorrect
      fcoe: have fcoe log off and lport destroy before ndo_fcoe_disable

Yi Zou (4):
      fcoe: remove unnecessary module state check
      libfcoe: clean up netdev mapping properly when the transport goes away
      libfcoe: fix possible buffer overflow in fcoe_transport_show
      libfcoe: fix wrong comment in fcoe_transport_detach


 drivers/scsi/esp_scsi.c            |    6 -
 drivers/scsi/fcoe/fcoe.c           |  202 +++++++++++-------------------------
 drivers/scsi/fcoe/fcoe_ctlr.c      |    6 -
 drivers/scsi/fcoe/fcoe_transport.c |   56 +++++-----
 drivers/scsi/libfc/fc_fcp.c        |   57 ++++------
 drivers/scsi/libfc/fc_lport.c      |    1 
 drivers/scsi/scsi_tgt_lib.c        |    6 -
 7 files changed, 122 insertions(+), 212 deletions(-)

-- 
Thanks, //Rob
