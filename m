From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 12/15] isci: allow more time for wide port targets
Date: Wed, 04 Jan 2012 01:33:26 -0800
Message-ID: <20120104093326.9147.63409.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab2ADJd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:28 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcin Tomczak <marcin.tomczak@intel.com>

From: Marcin Tomczak <marcin.tomczak@intel.com>

When hot insert the wide port device through the mini-sas port,
the first IOs (Report Luns or Inquiry) may fail due to the device
trying to open to a SCU phy that is still in suspended state. This
IO failure causes the wide port device stuck in UPDATING_PORT_WIDTH
state.

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 38a99d2..37d15d3 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -57,7 +57,7 @@
 
 #define SCIC_SDS_MPC_RECONFIGURATION_TIMEOUT    (10)
 #define SCIC_SDS_APC_RECONFIGURATION_TIMEOUT    (10)
-#define SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION  (100)
+#define SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION  (250)
 
 enum SCIC_SDS_APC_ACTIVITY {
 	SCIC_SDS_APC_SKIP_PHY,

