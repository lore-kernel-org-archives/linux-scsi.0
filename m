From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/10] hpsa: do not discard scsi status on aborted commands
Date: Mon, 23 Sep 2013 13:33:41 -0500
Message-ID: <20130923183341.19995.70558.stgit@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5284 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3IWSdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 14:33:42 -0400
In-Reply-To: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We inadvertantly discarded the scsi status for aborted commands.
For some commands (e.g. reads from tape drives) these can't be retried,
and if we discarded the scsi status, the scsi mid layer couldn't notice
anything was wrong and the error was not reported.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b63af55..3e45090 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1289,7 +1289,7 @@ static void complete_scsi_command(struct CommandList *cp)
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */

