From: <kgudipat@brocade.com>
Subject: [PATCH 03/23] bfa: Replace bfa_assert() with bfa_sm_fault()
Date: Fri, 5 Mar 2010 19:35:02 -0800
Message-ID: <1267846502-21898-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:18074 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0CFDfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:35:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Replace bfa_assert() with bfa_sm_fault() to get unhandled events for debugging.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |   10 ++++----
 drivers/scsi/bfa/bfa_ioim.c      |   22 +++++++++---------
 drivers/scsi/bfa/bfa_itnim.c     |   30 +++++++++++++-------------
 drivers/scsi/bfa/bfa_lps.c       |   12 +++++-----
 drivers/scsi/bfa/bfa_rport.c     |   26 +++++++++++-----------
 drivers/scsi/bfa/bfa_tskim.c     |   14 ++++++------
 drivers/scsi/bfa/fcpim.c         |   16 +++++++-------
 drivers/scsi/bfa/fdmi.c          |   22 +++++++++---------
 drivers/scsi/bfa/ms.c            |   22 +++++++++---------
 drivers/scsi/bfa/ns.c            |   34 ++++++++++++++--------------
 drivers/scsi/bfa/rport.c         |   44 +++++++++++++++++++-------------------
 drivers/scsi/bfa/rport_ftrs.c    |   12 +++++-----
 drivers/scsi/bfa/scn.c           |   10 ++++----
 drivers/scsi/bfa/vport.c         |   18 +++++++-------
 14 files changed, 146 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 3d62e45..960ae1a 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -114,7 +114,7 @@ bfa_fcs_port_sm_uninit(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -136,7 +136,7 @@ bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port, enum bfa_fcs_port_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -176,7 +176,7 @@ bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -214,7 +214,7 @@ bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -234,7 +234,7 @@ bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index f81d359..5b107ab 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -149,7 +149,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -194,7 +194,7 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -259,7 +259,7 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -317,7 +317,7 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -377,7 +377,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -419,7 +419,7 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -467,7 +467,7 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -516,7 +516,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -544,7 +544,7 @@ bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -577,7 +577,7 @@ bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
@@ -605,7 +605,7 @@ bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ioim->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_itnim.c b/drivers/scsi/bfa/bfa_itnim.c
index eabf7d3..a914ff2 100644
--- a/drivers/scsi/bfa/bfa_itnim.c
+++ b/drivers/scsi/bfa/bfa_itnim.c
@@ -144,7 +144,7 @@ bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -175,7 +175,7 @@ bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -212,7 +212,7 @@ bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -247,7 +247,7 @@ bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -275,7 +275,7 @@ bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -317,7 +317,7 @@ bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -348,7 +348,7 @@ bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -385,7 +385,7 @@ bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -413,7 +413,7 @@ bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -442,7 +442,7 @@ bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -470,7 +470,7 @@ bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -502,7 +502,7 @@ bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -538,7 +538,7 @@ bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -559,7 +559,7 @@ bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
@@ -583,7 +583,7 @@ bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index 66b9b15..4c98bda 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -121,7 +121,7 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -148,7 +148,7 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -180,7 +180,7 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -219,7 +219,7 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -243,7 +243,7 @@ bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
@@ -268,7 +268,7 @@ bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(lps->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_rport.c b/drivers/scsi/bfa/bfa_rport.c
index 3e1990a..7c509fa 100644
--- a/drivers/scsi/bfa/bfa_rport.c
+++ b/drivers/scsi/bfa/bfa_rport.c
@@ -114,7 +114,7 @@ bfa_rport_sm_uninit(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_un_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -146,7 +146,7 @@ bfa_rport_sm_created(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_cr_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -183,7 +183,7 @@ bfa_rport_sm_fwcreate(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwc_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -224,7 +224,7 @@ bfa_rport_sm_fwcreate_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwc_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -296,7 +296,7 @@ bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_on_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -329,7 +329,7 @@ bfa_rport_sm_fwdelete(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -359,7 +359,7 @@ bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_fwd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -394,7 +394,7 @@ bfa_rport_sm_offline(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_off_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -421,7 +421,7 @@ bfa_rport_sm_deleting(struct bfa_rport_s *rp, enum bfa_rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -446,7 +446,7 @@ bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -477,7 +477,7 @@ bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
 
 	default:
 		bfa_stats(rp, sm_delp_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -512,7 +512,7 @@ bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
 
 	default:
 		bfa_stats(rp, sm_offp_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
@@ -550,7 +550,7 @@ bfa_rport_sm_iocdisable(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 	default:
 		bfa_stats(rp, sm_iocd_unexp);
-		bfa_assert(0);
+		bfa_sm_fault(rp->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfa_tskim.c b/drivers/scsi/bfa/bfa_tskim.c
index ff7a4dc..ad9aaae 100644
--- a/drivers/scsi/bfa/bfa_tskim.c
+++ b/drivers/scsi/bfa/bfa_tskim.c
@@ -110,7 +110,7 @@ bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -146,7 +146,7 @@ bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -178,7 +178,7 @@ bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -207,7 +207,7 @@ bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -242,7 +242,7 @@ bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -277,7 +277,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
@@ -303,7 +303,7 @@ bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(tskim->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 06f8a46..71d23d1 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -126,7 +126,7 @@ bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 
 }
@@ -161,7 +161,7 @@ bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -205,7 +205,7 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -240,7 +240,7 @@ bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -270,7 +270,7 @@ bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -298,7 +298,7 @@ bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -321,7 +321,7 @@ bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -354,7 +354,7 @@ bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index d76d922..e812086 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -158,7 +158,7 @@ bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -183,7 +183,7 @@ bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -230,7 +230,7 @@ bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -258,7 +258,7 @@ bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -286,7 +286,7 @@ bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -331,7 +331,7 @@ bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -359,7 +359,7 @@ bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -387,7 +387,7 @@ bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -431,7 +431,7 @@ bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -459,7 +459,7 @@ bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -478,7 +478,7 @@ bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index c96b3ca..f0275a4 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -118,7 +118,7 @@ bfa_fcs_port_ms_sm_offline(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -141,7 +141,7 @@ bfa_fcs_port_ms_sm_plogi_sending(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -190,7 +190,7 @@ bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -216,7 +216,7 @@ bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -243,7 +243,7 @@ bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -266,7 +266,7 @@ bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -304,7 +304,7 @@ bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -330,7 +330,7 @@ bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -466,7 +466,7 @@ bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -502,7 +502,7 @@ bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
@@ -528,7 +528,7 @@ bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/ns.c b/drivers/scsi/bfa/ns.c
index 2f8b880..6de06a5 100644
--- a/drivers/scsi/bfa/ns.c
+++ b/drivers/scsi/bfa/ns.c
@@ -164,7 +164,7 @@ bfa_fcs_port_ns_sm_offline(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -187,7 +187,7 @@ bfa_fcs_port_ns_sm_plogi_sending(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -221,7 +221,7 @@ bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -247,7 +247,7 @@ bfa_fcs_port_ns_sm_plogi_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -270,7 +270,7 @@ bfa_fcs_port_ns_sm_sending_rspn_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -304,7 +304,7 @@ bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -330,7 +330,7 @@ bfa_fcs_port_ns_sm_rspn_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -353,7 +353,7 @@ bfa_fcs_port_ns_sm_sending_rft_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -390,7 +390,7 @@ bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -413,7 +413,7 @@ bfa_fcs_port_ns_sm_rft_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -436,7 +436,7 @@ bfa_fcs_port_ns_sm_sending_rff_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -494,7 +494,7 @@ bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -517,7 +517,7 @@ bfa_fcs_port_ns_sm_rff_id_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 static void
@@ -539,7 +539,7 @@ bfa_fcs_port_ns_sm_sending_gid_ft(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -575,7 +575,7 @@ bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -598,7 +598,7 @@ bfa_fcs_port_ns_sm_gid_ft_retry(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
@@ -626,7 +626,7 @@ bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(ns->port->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index df714dc..32cf180 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -224,7 +224,7 @@ bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -276,7 +276,7 @@ bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -332,7 +332,7 @@ bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -406,7 +406,7 @@ bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -481,7 +481,7 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -534,7 +534,7 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -589,7 +589,7 @@ bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -646,7 +646,7 @@ bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -704,7 +704,7 @@ bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -754,7 +754,7 @@ bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -816,7 +816,7 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -846,7 +846,7 @@ bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -869,7 +869,7 @@ bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -905,7 +905,7 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -951,7 +951,7 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1011,7 +1011,7 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1038,7 +1038,7 @@ bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1073,7 +1073,7 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1132,7 +1132,7 @@ bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1188,7 +1188,7 @@ bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1249,7 +1249,7 @@ bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -1334,7 +1334,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/rport_ftrs.c b/drivers/scsi/bfa/rport_ftrs.c
index e1932c8..ae7bba6 100644
--- a/drivers/scsi/bfa/rport_ftrs.c
+++ b/drivers/scsi/bfa/rport_ftrs.c
@@ -91,7 +91,7 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -114,7 +114,7 @@ bfa_fcs_rpf_sm_rpsc_sending(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -160,7 +160,7 @@ bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -186,7 +186,7 @@ bfa_fcs_rpf_sm_rpsc_retry(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -206,7 +206,7 @@ bfa_fcs_rpf_sm_online(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 
@@ -229,7 +229,7 @@ bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(rport->fcs, event);
 	}
 }
 /**
diff --git a/drivers/scsi/bfa/scn.c b/drivers/scsi/bfa/scn.c
index bd4771f..8fe09ba 100644
--- a/drivers/scsi/bfa/scn.c
+++ b/drivers/scsi/bfa/scn.c
@@ -90,7 +90,7 @@ bfa_fcs_port_scn_sm_offline(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -109,7 +109,7 @@ bfa_fcs_port_scn_sm_sending_scr(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -137,7 +137,7 @@ bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -157,7 +157,7 @@ bfa_fcs_port_scn_sm_scr_retry(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
@@ -171,7 +171,7 @@ bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(scn->port->fcs, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 13f7371..14fb7ac 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -122,7 +122,7 @@ bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -165,7 +165,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -202,7 +202,7 @@ bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -249,7 +249,7 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -283,7 +283,7 @@ bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -310,7 +310,7 @@ bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -339,7 +339,7 @@ bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -387,7 +387,7 @@ bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
@@ -419,7 +419,7 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(__vport_fcs(vport), event);
 	}
 }
 
-- 
1.6.5.3

