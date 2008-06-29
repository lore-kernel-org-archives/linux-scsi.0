From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 02/13] libfc: remove libfc scan_host
Date: Sun, 29 Jun 2008 13:23:52 -0500
Message-ID: <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-2-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

We only want to call scsi_scan_host if we are hooked into the async
scanning correctly, because the fc class does a scan from the rport
workqueue. If we actually call scsi_scan_host from where scsi_scan
is being called some bad things can happen because it will sleep
while the scanning is being performed and we need to use those threads
for the IO traffic.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/libfc/fc_disc.c |    7 +------
 drivers/scsi/libfc/fc_scsi.c |   10 ----------
 include/scsi/libfc/libfc.h   |    5 -----
 3 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 67e8c24..45210c3 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -444,11 +444,8 @@ static int fcdt_new_target(struct fc_lport *lp,
 			if (rp->rp_disc_ver == 0 || rp->rp_sess_ready == 0) {
 				rp->rp_local_fcp_parm = lp->service_params;
 				lp->tt.rport_login(rp);
-			} else {
-				if (!lp->fs_disc_done)
-					lp->tt.scan_host(lp);
+			} else
 				lp->fs_disc_done = 1;
-			}
 		}
 	}
 	return error;
@@ -506,8 +503,6 @@ static void fcdt_done(struct fc_lport *lp)
 	}
 	WARN_ON(held);
 	fc_rp_list_unlock(lp);
-	if (!lp->fs_disc_done)
-		lp->tt.scan_host(lp);
 	lp->fs_disc_done = 1;
 	lp->fl_disc_in_prog = 0;
 	if (lp->fl_disc_req)
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index e881589..b877daa 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -2252,13 +2252,6 @@ void fc_put_dev(struct fc_lport *lp)
 }
 EXPORT_SYMBOL(fc_put_dev);
 
-void fc_scan_host(struct fc_lport *lp)
-{
-	if (lp->state != FC_INITIALIZATION)
-		scsi_scan_host(lp->host);
-}
-EXPORT_SYMBOL(fc_scan_host);
-
 int fc_scsi_init(struct fc_lport *lp,
 		 struct fc_transport_template *tmpl)
 {
@@ -2271,9 +2264,6 @@ int fc_scsi_init(struct fc_lport *lp,
 	if (!lp->tt.scsi_abort_io)
 		lp->tt.scsi_abort_io = fc_scsi_abort_io;
 	
-	if (!lp->tt.scan_host)
-		lp->tt.scan_host = fc_scan_host;
-
 	si = (struct fc_scsi_internal*)kzalloc(sizeof(struct fc_scsi_internal), GFP_ATOMIC);
 	lp->scsi_priv = (void*)si;
 
diff --git a/include/scsi/libfc/libfc.h b/include/scsi/libfc/libfc.h
index b87d404..68ea82f 100644
--- a/include/scsi/libfc/libfc.h
+++ b/include/scsi/libfc/libfc.h
@@ -437,11 +437,6 @@ struct fc_transport_template {
 	 */
 	void (*scsi_abort_io)(struct fc_lport *);
 
-	/*
-	 * Tell the SCSI block to let the SCSI-ml scan the host.
-	 */
-	void (*scan_host)(struct fc_lport *);
-
 	/**
 	 * Discovery interfaces
 	 */
-- 
1.5.4.1
