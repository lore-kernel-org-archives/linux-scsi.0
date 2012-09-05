From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] target: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 5 Sep 2012 14:42:48 +0800
Message-ID: <CAPgLHd9tGyUzBdbNzorncaa57RFD-YO06tz3UCffuXXxgLDdyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: bootc@bootc.net, nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/sbp/sbp_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 39ddba5..e57971f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -660,8 +660,7 @@ static void session_reconnect_expired(struct sbp_session *sess)
 	spin_lock_bh(&sess->lock);
 	list_for_each_entry_safe(login, temp, &sess->login_list, link) {
 		login->sess = NULL;
-		list_del(&login->link);
-		list_add_tail(&login->link, &login_list);
+		list_move_tail(&login->link, &login_list);
 	}
 	spin_unlock_bh(&sess->lock);
 
