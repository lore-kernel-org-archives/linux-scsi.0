From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 8/9] isci: fix event-get pointer increment
Date: Fri, 29 Jul 2011 17:17:16 -0700
Message-ID: <20110730001716.28430.33602.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3ARQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:17:16 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Kapil Karkra <kapil.karkra@intel.com>, linux-scsi@vger.kernel.org

Hardware only increments the put pointer on event types >= 4.  Do not
increment the get pointer for event type 3.

Reported-by: Kapil Karkra <kapil.karkra@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 2328f98..6981b77 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -531,6 +531,9 @@ static void sci_controller_process_completions(struct isci_host *ihost)
 			break;
 
 		case SCU_COMPLETION_TYPE_EVENT:
+			sci_controller_event_completion(ihost, ent);
+			break;
+
 		case SCU_COMPLETION_TYPE_NOTIFY: {
 			event_cycle ^= ((event_get+1) & SCU_MAX_EVENTS) <<
 				       (SMU_COMPLETION_QUEUE_GET_EVENT_CYCLE_BIT_SHIFT - SCU_MAX_EVENTS_SHIFT);

