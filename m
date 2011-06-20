From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 11/12] libfc: post reset event on lport reset
Date: Mon, 20 Jun 2011 16:59:46 -0700
Message-ID: <20110620235946.1777.78835.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15144 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab1FTX7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:46 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Post an FCH_EVT_LIPRESET event on lport reset as
as lport reset occurs on FIP cleat virtual link,
this could be due to change in fcoe vlan and this
event will allow user app fcoemon to switch to
new fcoe vlan.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 389ab80..e008b16 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1025,6 +1025,8 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 			fc_vport_set_state(lport->vport, FC_VPORT_LINKDOWN);
 	}
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
+	fc_host_post_event(lport->host, fc_get_event_number(),
+			   FCH_EVT_LIPRESET, 0);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
 	if (lport->link_up)

