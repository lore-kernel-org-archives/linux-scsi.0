From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH] tcm_fc: Fix fc_exch memory leak in
	ft_send_resp_status
Date: Sat, 10 Mar 2012 08:06:36 +0000
Message-ID: <1331366796-11775-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Open-FCoE devel <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch fixes a bug in tcm_fc where fc_exch memory from fc_exch_mgr->ep_pool
is currently being leaked by ft_send_resp_status() usage.  Following current
code in ft_queue_status() response path, using lport->tt.seq_send() needs to be
followed by a lport->tt.exch_done() in order to release fc_exch memory back into
libfc_em kmem_cache.

ft_send_resp_status() code is currently used in pre submit se_cmd ft_send_work()
error exceptions, TM request setup exceptions, and main TM response callback
path in ft_queue_tm_resp().  This bugfix addresses the leak in these cases.

Cc: Mark D Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kiran Patil <kiran.patil-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/target/tcm_fc/tfc_cmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 346e72d..dc772f9 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -315,10 +315,12 @@ static void ft_send_resp_status(struct fc_lport *lport,
 
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_DD_CMD_STATUS, 0);
 	sp = fr_seq(fp);
-	if (sp)
+	if (sp) {
 		lport->tt.seq_send(lport, sp, fp);
-	else
+		lport->tt.exch_done(sp);
+	} else {
 		lport->tt.frame_send(lport, fp);
+	}
 }
 
 /*
-- 
1.7.2.5
