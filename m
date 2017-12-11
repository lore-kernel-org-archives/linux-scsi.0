From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/6] target: tcm_loop: Improve a size determination in two
 functions
Date: Mon, 11 Dec 2017 11:43:24 +0100
Message-ID: <c159ede6-193a-cb5a-8e63-b53cdf54db19@users.sourceforge.net>
References: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 10 Dec 2017 21:23:43 +0100

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6bd58a064924..60e4185e7508 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -769,7 +769,7 @@ static int tcm_loop_make_nexus(
 		return -EEXIST;
 	}
 
-	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
+	tl_nexus = kzalloc(sizeof(*tl_nexus), GFP_KERNEL);
 	if (!tl_nexus)
 		return -ENOMEM;
 
@@ -1076,7 +1076,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	char *ptr;
 	int ret, off = 0;
 
-	tl_hba = kzalloc(sizeof(struct tcm_loop_hba), GFP_KERNEL);
+	tl_hba = kzalloc(sizeof(*tl_hba), GFP_KERNEL);
 	if (!tl_hba)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.15.1
