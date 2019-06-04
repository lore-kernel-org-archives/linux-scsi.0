From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 36/60] scsi: myrs: Fix uninitialized variable
Date: Tue,  4 Jun 2019 19:21:46 -0400
Message-ID: <20190604232212.6753-36-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YueHaibing <yuehaibing@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 41552199b5518fe26bee0829a28dd1880441b430 ]

drivers/scsi/myrs.c: In function 'myrs_log_event':
drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
  struct scsi_sense_hdr sshdr;

If ev->ev_code is not 0x1C, sshdr.sense_key may be used uninitialized. Fix
this by initializing variable 'sshdr' to 0.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index b8d54ef8cf6d..eb0dd566330a 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -818,7 +818,7 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 	unsigned char ev_type, *ev_msg;
 	struct Scsi_Host *shost = cs->host;
 	struct scsi_device *sdev;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr sshdr = {0};
 	unsigned char sense_info[4];
 	unsigned char cmd_specific[4];
 
-- 
2.20.1
