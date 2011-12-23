From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 25/28] libsas: don't mark expanders as gone when a child
 device is removed
Date: Thu, 22 Dec 2011 19:00:38 -0800
Message-ID: <20111223030038.21827.61137.stgit@localhost6.localdomain6>
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

Commit 56dd2c06 "[SCSI] libsas: Don't issue commands to devices that
have been hot-removed" marked the parent device of an end-device as gone
when all the phys to the end device have been deleted.

The expander device is still present until its parent is removed.  This
is a benign change until the smp_execute_task() path is taught to check
->gone.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5e1eec9..d9c2769 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1820,7 +1820,6 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				break;
 			}
 		}
-		parent->gone = 1;
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);

