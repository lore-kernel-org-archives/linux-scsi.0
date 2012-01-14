From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 6/7] libsas: kill spurious sas_put_device
Date: Sat, 14 Jan 2012 10:10:43 -0800
Message-ID: <20120114181039.25887.30987.stgit@localhost6.localdomain6>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Maciej Trela <maciej.trela@intel.com>

Holdover from a patch rework, prior to the addition of SAS_DEV_DESTROY
we were holding a reference while the destruct was pending in case the
domain was torn down before the desctruct event ran.  That case is
covered by SAS_DEV_DESTROY, and the sas_put_device() just corrupts freed
memory, or worse frees the memory while another agent holds a reference.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 9367101..c6681b4 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -281,8 +281,6 @@ static void sas_destruct_devices(struct work_struct *work)
 		sas_rphy_delete(dev->rphy);
 		dev->rphy = NULL;
 		sas_unregister_common_dev(port, dev);
-
-		sas_put_device(dev);
 	}
 }
 

