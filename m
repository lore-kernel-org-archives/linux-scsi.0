From: Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 2/2] scsi: hyper-v storvsc -- host takes MAINTENANCE_IN commands badly -- elide them
Date: Fri, 16 May 2014 16:39:08 +0100
Message-ID: <1400254748-21573-3-git-send-email-abbotti@mev.co.uk>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.mev.co.uk ([62.49.15.74]:58763 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035AbaEPPjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2014 11:39:15 -0400
In-Reply-To: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org
Cc: Andy Whitcroft <apw@canonical.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Tim Gardner <tim.gardner@canonical.com>

From: Andy Whitcroft <apw@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/1234417
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
Original patch title was "UBUNTU: SAUCE: storvsc -- host takes
MAINTENANCE_IN commands badly elide them".  Changed by Ian Abbott
<abbotti@mev.co.uk>
---
 drivers/scsi/storvsc_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3903c8a..c1eddd1 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1539,6 +1539,8 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	 * this. So, don't send it.
 	 */
 	case SET_WINDOW:
+	/* the host does not handle MAINTENANCE_IN preventing boot.*/
+	case MAINTENANCE_IN:
 		scmnd->result = ILLEGAL_REQUEST << 16;
 		allowed = false;
 		break;
-- 
1.9.2

