From: SF Markus Elfring via linux1394-devel
 <linux1394-devel@lists.sourceforge.net>
Subject: [PATCH] sbp-target: Delete an error message for a failed memory
 allocation in three functions
Date: Sun, 10 Dec 2017 20:10:17 +0100
Message-ID: <06164454-67a9-d206-647c-b70f4a1c3812@users.sourceforge.net>
Reply-To: SF Markus Elfring <elfring@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Language: en-GB
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 10 Dec 2017 19:54:11 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/sbp/sbp_target.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e5c3e5f827d0..fb1003921d85 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -201,10 +201,9 @@ static struct sbp_session *sbp_session_create(
 	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
 
 	sess = kmalloc(sizeof(*sess), GFP_KERNEL);
-	if (!sess) {
-		pr_err("failed to allocate session descriptor\n");
+	if (!sess)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	spin_lock_init(&sess->lock);
 	INIT_LIST_HEAD(&sess->login_list);
 	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
@@ -2029,10 +2028,8 @@ static struct se_portal_group *sbp_make_tpg(
 	}
 
 	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
-	if (!tpg) {
-		pr_err("Unable to allocate struct sbp_tpg\n");
+	if (!tpg)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
@@ -2088,10 +2085,8 @@ static struct se_wwn *sbp_make_tport(
 		return ERR_PTR(-EINVAL);
 
 	tport = kzalloc(sizeof(*tport), GFP_KERNEL);
-	if (!tport) {
-		pr_err("Unable to allocate struct sbp_tport\n");
+	if (!tport)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	tport->guid = guid;
 	sbp_format_wwn(tport->tport_name, SBP_NAMELEN, guid);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
