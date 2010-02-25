From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/9] hpsa: fix scsi status mis-shift
Date: Thu, 25 Feb 2010 14:03:01 -0600
Message-ID: <20100225200301.7508.64978.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9415 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0BYT7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:59:54 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix scsi status mis-shift.  The SCSI status does not need to be shifted.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3734f31..604b4c9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1006,7 +1006,7 @@ static void complete_scsi_command(struct CommandList *cp,
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus << 1);
+	cmd->result |= ei->ScsiStatus;
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,

