From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/24] libfc and fcoe fixes for 2.6.29-rc
Date: Fri, 27 Feb 2009 10:54:30 -0800
Message-ID: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbZB0Syc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:54:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

The following series implements fixes for Open-FCoE (libfc and fcoe).
All of these patches had been sent to linux-scsi previously, with the
exception of the last 6 patches, which are new.

Of the last 6 patches one is a patch mailed to linux-scsi, not from
Open-FCoE.org, that has not been applied yet. That patch is-

   Roel Kluin -  fcoe: fix kfree(skb)

Also, the very last patch converts the FCoE Rx threads to a nice value
of -20. I sought advice on linux-scsi to determine a good value for
these threads, but didn't get feedback. Since other FC driver threads
use -20, this is the value I chose. If this is not a good starting
value, then please do not apply the patch, but I would appreciate
feedback as to a better value.

This patch set is based on Linus' 2.6.29-rc6 tree. I chose this tree
becuase it is more current than rc-fixes. If a rebase and resend is
let me know.

---

Abhijeet Joglekar (2):
      libfc: when rport goes away (re-plogi), clean up exchanges to/from rport
      libfc: Pass lport in exch_mgr_reset

Chris Leech (2):
      fcoe: fix handling of pending queue, prevent out of order frames (v3)
      libfc: rport retry on LS_RJT from certain ELS

Robert Love (11):
      fcoe: Change fcoe receive thread nice value from 19 (lowest priority) to -20
      fcoe: Correct fcoe_transports initialization vs. registration
      fcoe: Use setup_timer() and mod_timer()
      libfc, fcoe: Remove unnecessary cast by removing inline wrapper
      libfc, fcoe: Cleanup function formatting and minor typos
      libfc, fcoe: Fix kerneldoc comments
      libfc: Cleanup libfc_function_template comments
      libfc: check for err when recv and state is incorrect
      libfc: rename rp to rdata in fc_disc_new_target()
      libfc: correct RPORT_TO_PRIV usage
      libfc: Don't violate transport template for rogue port creation

Roel Kluin (1):
      fcoe: fix kfree(skb)

Steve Ma (1):
      libfc: exch mgr is freed while lport still retrying sequences

Vasu Dev (5):
      fcoe: Out of order tx frames was causing several check condition SCSI status
      libfc: fixed a read IO data integrity issue when a IO data frame lost
      libfc, fcoe: fixed locking issues with lport->lp_mutex around lport->link_status
      libfc: fixed a soft lockup issue in fc_exch_recv_abts
      libfc: handle RRQ exch timeout

Yi Zou (2):
      fcoe: ETH_P_8021Q is already in if_ether and fcoe is not using it anyway
      libfc: do not change the fh_rx_id of a recevied frame


 drivers/scsi/fcoe/fc_transport_fcoe.c |   91 +++++----
 drivers/scsi/fcoe/fcoe_sw.c           |   56 +++---
 drivers/scsi/fcoe/libfcoe.c           |  318 ++++++++++++++-------------------
 drivers/scsi/libfc/fc_disc.c          |   63 +++----
 drivers/scsi/libfc/fc_exch.c          |   32 +--
 drivers/scsi/libfc/fc_fcp.c           |   56 +++---
 drivers/scsi/libfc/fc_lport.c         |  173 ++++++++----------
 drivers/scsi/libfc/fc_rport.c         |  197 ++++++++++++--------
 include/scsi/fc/fc_fcoe.h             |    4 
 include/scsi/fc/fc_fs.h               |    5 +
 include/scsi/libfc.h                  |  138 ++++++++------
 include/scsi/libfcoe.h                |    9 -
 12 files changed, 551 insertions(+), 591 deletions(-)

-- 
//Rob
