From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] add stats info for FCP packets
Date: Tue, 7 Dec 2010 21:41:03 +0800
Message-ID: <AANLkTinjzErP33bWtmkTJh9BftJJtjjNiH4f2sHV-6j_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Stats info is added, in the define of fcp internal, to monitor the
usage of fcp pkts.

Then it is simple to answer not only whether but also how many pkts
leaked in the life cycle of fc local port.

This work is motivated to capture mm leak of fcp pkts with outstanding
REC, and thanks for dropping a reply to this message if captured.

Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-12-07 20:44:36.000000000 +0800
@@ -82,6 +82,8 @@ struct fc_fcp_internal {
 	unsigned long		last_can_queue_ramp_down_time;
 	unsigned long		last_can_queue_ramp_up_time;
 	int			max_can_queue;
+	/* stats info of the usage of fcp pkts */
+	unsigned long		pkts;
 };

 #define fc_get_scsi_internal(x)	((struct fc_fcp_internal *)(x)->scsi_priv)
@@ -151,6 +153,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_all

 	fsp = mempool_alloc(si->scsi_pkt_pool, gfp);
 	if (fsp) {
+		si->pkts++;
 		memset(fsp, 0, sizeof(*fsp));
 		fsp->lp = lport;
 		atomic_set(&fsp->ref_cnt, 1);
@@ -172,7 +175,7 @@ static void fc_fcp_pkt_release(struct fc
 {
 	if (atomic_dec_and_test(&fsp->ref_cnt)) {
 		struct fc_fcp_internal *si = fc_get_scsi_internal(fsp->lp);
-
+		si->pkts--;
 		mempool_free(fsp, si->scsi_pkt_pool);
 	}
 }
@@ -2187,7 +2190,10 @@ void fc_fcp_destroy(struct fc_lport *lpo
 	if (!list_empty(&si->scsi_pkt_queue))
 		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
 		       "port (%6.6x)\n", lport->port_id);
-
+	if (si->pkts != 0)
+		printk(KERN_WARNING "libfc: %lu leaked SCSI packets when "
+			"destroying local port (%6.6x)\n",
+			si->pkts, lport->port_id);
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
 	lport->scsi_priv = NULL;
