From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 26/28] libsas: check for 'gone' expanders in
 smp_execute_task()
Date: Thu, 22 Dec 2011 19:00:44 -0800
Message-ID: <20111223030044.21827.27431.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

No sense in issuing or retrying commands to an expander that has been
removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d9c2769..e2efc6c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -74,6 +74,9 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
+		if (dev->gone)
+			return -ECOMM;
+
 		task = sas_alloc_task(GFP_KERNEL);
 		if (!task) {
 			res = -ENOMEM;

