From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/20] fnic: Pad the unused bytes of CDB to 0s
Date: Wed, 21 Oct 2009 16:28:25 -0700
Message-ID: <20091021232825.12986.91773.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZJUX3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:29:24 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_res.h  |    4 +++-
 drivers/scsi/fnic/fnic_scsi.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_res.h b/drivers/scsi/fnic/fnic_res.h
index b6f3102..88c4471 100644
--- a/drivers/scsi/fnic/fnic_res.h
+++ b/drivers/scsi/fnic/fnic_res.h
@@ -58,6 +58,7 @@ static inline void fnic_queue_wq_copy_desc_icmnd_16(struct vnic_wq_copy *wq,
 						    u64 sgl_addr, u64 sns_addr,
 						    u8 crn, u8 pri_ta,
 						    u8 flags, u8 *scsi_cdb,
+						    u8 cdb_len,
 						    u32 data_len, u8 *lun,
 						    u32 d_id, u16 mss,
 						    u32 ratov, u32 edtov)
@@ -82,7 +83,8 @@ static inline void fnic_queue_wq_copy_desc_icmnd_16(struct vnic_wq_copy *wq,
 	desc->u.icmnd_16.pri_ta = pri_ta; 	/* SCSI Pri & Task attribute */
 	desc->u.icmnd_16._resvd1 = 0;           /* reserved: should be 0 */
 	desc->u.icmnd_16.flags = flags;         /* command flags */
-	memcpy(desc->u.icmnd_16.scsi_cdb, scsi_cdb, CDB_16);    /* SCSI CDB */
+	memset(desc->u.icmnd_16.scsi_cdb, 0, CDB_16);
+	memcpy(desc->u.icmnd_16.scsi_cdb, scsi_cdb, cdb_len);    /* SCSI CDB */
 	desc->u.icmnd_16.data_len = data_len;   /* length of data expected */
 	memcpy(desc->u.icmnd_16.lun, lun, LUN_ADDRESS);  /* LUN address */
 	desc->u.icmnd_16._resvd2 = 0;          	/* reserved */
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index bfc9969..b5d1738 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -319,7 +319,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					 0, /* scsi cmd ref, always 0 */
 					 pri_tag, /* scsi pri and tag */
 					 flags,	/* command flags */
-					 sc->cmnd, scsi_bufflen(sc),
+					 sc->cmnd, sc->cmd_len,
+					 scsi_bufflen(sc),
 					 fc_lun.scsi_lun, io_req->port_id,
 					 rport->maxframe_size, rp->r_a_tov,
 					 rp->e_d_tov);

