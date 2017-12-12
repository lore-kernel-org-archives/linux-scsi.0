From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/8] target/iscsi: Delete an unnecessary variable
 initialisation in iscsit_allocate_ooo_cmdsn()
Date: Tue, 12 Dec 2017 22:46:42 +0100
Message-ID: <3db75482-2817-46b1-95e5-ace7342e2a90@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 21:13:49 +0100

The local variable "ooo_cmdsn" will be reassigned by a following statement.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index ff3e08b6d4e1..c4c550128161 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -782,7 +782,7 @@ int iscsit_recover_dataout_sequence(
 
 static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 {
-	struct iscsi_ooo_cmdsn *ooo_cmdsn = NULL;
+	struct iscsi_ooo_cmdsn *ooo_cmdsn;
 
 	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
 	if (!ooo_cmdsn)
-- 
2.15.1
