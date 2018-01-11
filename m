From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] tcmu: fix error return code in tcmu_configure_device()
Date: Thu, 11 Jan 2018 11:12:25 +0000
Message-ID: <1515669145-125352-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix to return error code -ENOMEM from the kzalloc() error handling
case instead of 0, as done elsewhere in this function.

Fixes: fabe6a59cc5a ("tcmu: allow max block and global max blocks to be settable")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/target/target_core_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bac08bc..2edd242 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1705,8 +1705,10 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	udev->data_bitmap = kzalloc(BITS_TO_LONGS(udev->max_blocks) *
 				    sizeof(unsigned long), GFP_KERNEL);
-	if (!udev->data_bitmap)
+	if (!udev->data_bitmap) {
+		ret = -ENOMEM;
 		goto err_bitmap_alloc;
+	}
 
 	udev->mb_addr = vzalloc(CMDR_SIZE);
 	if (!udev->mb_addr) {

