From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/5] isci: The port state should be set to stopping on the
 last phy.
Date: Wed, 28 Sep 2011 18:47:56 -0700
Message-ID: <20110929014756.23617.86904.stgit@localhost6.localdomain6>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7488 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab1I2Br5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:47:57 -0400
In-Reply-To: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Fixes a bug where any phy removed from the port set the port
state to "stopping" - do this only when the last phy removed
from the port.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 8f6f9b7..8e59c88 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -294,8 +294,8 @@ static void isci_port_link_down(struct isci_host *isci_host,
 					__func__, isci_device);
 				set_bit(IDEV_GONE, &isci_device->flags);
 			}
+			isci_port_change_state(isci_port, isci_stopping);
 		}
-		isci_port_change_state(isci_port, isci_stopping);
 	}
 
 	/* Notify libsas of the borken link, this will trigger calls to our

