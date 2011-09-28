From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 3/6] libfc: cache align struct fc_exch fields
Date: Tue, 27 Sep 2011 21:38:02 -0700
Message-ID: <20110928043802.13004.31463.stgit@localhost6.localdomain6>
References: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1I1ErO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:47:14 -0400
In-Reply-To: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

cache aligned xid and ex_lock beside
removing holes.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 include/scsi/libfc.h |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 05e2583..5d1a758 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -406,35 +406,32 @@ struct fc_seq {
  *	sequence allocation
  */
 struct fc_exch {
+	spinlock_t	    ex_lock;
+	atomic_t	    ex_refcnt;
+	enum fc_class	    class;
 	struct fc_exch_mgr  *em;
 	struct fc_exch_pool *pool;
-	u32		    state;
-	u16		    xid;
 	struct list_head    ex_list;
-	spinlock_t	    ex_lock;
-	atomic_t	    ex_refcnt;
-	struct delayed_work timeout_work;
 	struct fc_lport	    *lp;
+	u32		    esb_stat;
+	u8		    state;
+	u8		    fh_type;
+	u8		    seq_id;
+	u8		    encaps;
+	u16		    xid;
 	u16		    oxid;
 	u16		    rxid;
 	u32		    oid;
 	u32		    sid;
 	u32		    did;
-	u32		    esb_stat;
 	u32		    r_a_tov;
-	u8		    seq_id;
-	u8		    encaps;
 	u32		    f_ctl;
-	u8		    fh_type;
-	enum fc_class	    class;
-	struct fc_seq	    seq;
-
+	struct fc_seq       seq;
 	void		    (*resp)(struct fc_seq *, struct fc_frame *, void *);
 	void		    *arg;
-
 	void		    (*destructor)(struct fc_seq *, void *);
-
-};
+	struct delayed_work timeout_work;
+} ____cacheline_aligned_in_smp;
 #define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
 
 

