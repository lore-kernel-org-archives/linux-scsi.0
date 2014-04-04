From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] target/tcm_fc: Rename ft_tport_create to
	ft_tport_get
Date: Fri,  4 Apr 2014 16:54:15 -0700
Message-ID: <1396655655-31060-6-git-send-email-agrover@redhat.com>
References: <1396655655-31060-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1396655655-31060-1-git-send-email-agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Because it doesn't always create, if there's an existing one it just
returns it.

Signed-off-by: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/tcm_fc/tfc_sess.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 0475142..746adb8 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -51,7 +51,7 @@ static void ft_sess_delete_all(struct ft_tport *);
  * Lookup or allocate target local port.
  * Caller holds ft_lport_lock.
  */
-static struct ft_tport *ft_tport_create(struct fc_lport *lport)
+static struct ft_tport *ft_tport_get(struct fc_lport *lport)
 {
 	struct ft_tpg *tpg;
 	struct ft_tport *tport;
@@ -114,7 +114,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 void ft_lport_add(struct fc_lport *lport, void *arg)
 {
 	mutex_lock(&ft_lport_lock);
-	ft_tport_create(lport);
+	ft_tport_get(lport);
 	mutex_unlock(&ft_lport_lock);
 }
 
@@ -351,7 +351,7 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 	struct ft_node_acl *acl;
 	u32 fcp_parm;
 
-	tport = ft_tport_create(rdata->local_port);
+	tport = ft_tport_get(rdata->local_port);
 	if (!tport)
 		goto not_target;	/* not a target for this local port */
 
-- 
1.9.0
