From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 23/23] ncr5380: Call complete_cmd() for disconnected commands on bus reset
Date: Wed, 23 Mar 2016 21:10:32 +1100
Message-ID: <20160323101015.181778613@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43693 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbcCWKPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 06:15:24 -0400
Content-Disposition: inline; filename=ncr5380-disconnected-autosense-fix
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

I'm told that some targets are liable to disconnect a REQUEST SENSE
command. Theoretically this would cause a command undergoing autosense to
be moved onto the disconnected list. The bus reset handler must call
complete_cmd() for these commands, otherwise the hostdata->sensing pointer
will not get cleared. That would cause autosense processing to stall and
a timeout or an incorrect scsi_eh_restore_cmnd() would eventually follow.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reported-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-23 21:10:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-23 21:10:07.000000000 +1100
@@ -2437,7 +2437,7 @@ static int NCR5380_bus_reset(struct scsi
 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
 
 		set_host_byte(cmd, DID_RESET);
-		cmd->scsi_done(cmd);
+		complete_cmd(instance, cmd);
 	}
 	INIT_LIST_HEAD(&hostdata->disconnected);
 


