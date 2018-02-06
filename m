From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: isci: remove redundant initialization to 'bit'
Date: Tue,  6 Feb 2018 14:12:36 +0000
Message-ID: <20180206141236.31651-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable bit is initialized with a value that is never read and is
being updated immediately after the initialization, hence the
initialization is redundant and can be removed.

Cleans up clang warning:
drivers/scsi/isci/host.c:2769:8: warning: Value stored to 'bit' during
its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 13b37cdffa8e..1ee3868ade07 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -2766,7 +2766,7 @@ static int sci_write_gpio_tx_gp(struct isci_host *ihost, u8 reg_index, u8 reg_co
 		int i;
 
 		for (i = 0; i < 3; i++) {
-			int bit = (i << 2) + 2;
+			int bit;
 
 			bit = try_test_sas_gpio_gp_bit(to_sas_gpio_od(d, i),
 						       write_data, reg_index,
-- 
2.15.1

