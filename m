From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: Silence an uninitialized variable warning
Date: Thu, 14 Apr 2016 12:33:03 +0300
Message-ID: <20160414093303.GC16549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm getting a static checker warning:

    drivers/target/target_core_sbc.c:1150 sbc_parse_cdb()
    error: uninitialized variable 'size'.

It looks like a possible bug but wouldn't it have shown up in testing?
Anyway let's just silence it by setting size to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a9057aa..0c6e55f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -828,7 +828,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
-	unsigned int size;
+	unsigned int size = 0;
 	u32 sectors = 0;
 	sense_reason_t ret;
 
