From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] fc-transport: Close state transition-window during rport
	deletion.
Date: Tue, 28 Apr 2009 07:01:52 -0700
Message-ID: <20090428140152.GA16413@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4731 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbZD1OBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 10:01:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Smart <james.smart@emulex.com>

After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
but, prior to making the upcall to 'block' the scsi-target
associated with an rport, queued commands can recycle and
ultimately run out of retries causing failures to propagate to
upper-level drivers.  Close this transition-window by returning
the non-'retries' modifying DID_IMM_RETRY status for submitted
I/Os.

Issue seen during continuous LIP-injection.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index c9184f7..d189e0e 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -687,6 +687,8 @@ fc_remote_port_chkready(struct fc_rport *rport)
 	case FC_PORTSTATE_BLOCKED:
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 			result = DID_TRANSPORT_FAILFAST << 16;
+		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
+			result = DID_IMM_RETRY << 16;
 		else
 			result = DID_TRANSPORT_DISRUPTED << 16;
 		break;
