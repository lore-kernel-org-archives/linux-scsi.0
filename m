From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 04/10] libsas: don't mark expanders as gone when a child
 device is removed
Date: Mon, 16 Jan 2012 21:11:22 -0800
Message-ID: <20120117051122.22344.79906.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2AQFLX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 00:11:23 -0500
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

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
index 32e417e..7701ab5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1820,7 +1820,6 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				break;
 			}
 		}
-		set_bit(SAS_DEV_GONE, &parent->state);
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);

