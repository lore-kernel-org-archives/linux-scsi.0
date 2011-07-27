From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/10] libfc: fix warn on in lport retry
Date: Wed, 27 Jul 2011 15:11:00 -0700
Message-ID: <20110727221100.23675.26287.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab1G0WLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:11:02 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

The lport retry timer hits warn on in case
it has become ready in response from fip
login from fcoe_ctlr_flogi_send(), this is
possible but safe code path, therefore
removing this warn on.

Jun 22 03:16:30 10.0.16.6 [488198.316517] host3: Assigned Port ID 180f02
Jun 22 03:16:32 10.0.16.6 [488200.091561] ------------[ cut here ]------------
Jun 22 03:16:32 10.0.16.6 [488200.091586] WARNING: at
drivers/scsi/libfc/fc_lport.c:1355 fc_lport_timeout+0xd9/0xe0 [libfc]()

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e008b16..e55ed9c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1352,7 +1352,6 @@ static void fc_lport_timeout(struct work_struct *work)
 		WARN_ON(1);
 		break;
 	case LPORT_ST_READY:
-		WARN_ON(1);
 		break;
 	case LPORT_ST_RESET:
 		break;

