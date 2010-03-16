From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/3] SCSI: be2iscsi, fix lock imbalance
Date: Tue, 16 Mar 2010 13:48:10 -0700
Message-ID: <20100316204810.47e381d0@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:27888 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0CPUsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 16:48:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com

Acked-By:  Jayamohan Kallickal <jayamohank@serverengines.com>

--
  _____  
From: Jiri Slaby [mailto:jslaby@suse.cz]
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com, Jayamohan Kallickal [mailto:jayamohank@serverengines.com]
Sent: Tue, 16 Mar 2010 08:23:57 -0700
Subject: [PATCH 1/3] SCSI: be2iscsi, fix lock imbalance

Stanse found that one error path in mgmt_invalidate_icds omits to unlock
ctrl->mbox_lock. Fix that.

Added in 756d29c8c7ed8887ed7d752371ce2f (Enable async mode for mcc rings)
where the spinlock was moved.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 72617b6..e641922 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -169,6 +169,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for"
 			 "mgmt_invalidate_icds \n");
+		spin_unlock(&ctrl->mbox_lock);
 		return -1;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
-- 
1.7.0.1


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

