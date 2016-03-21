From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 23/23] ncr5380: Call complete_cmd() for disconnected commands on bus reset
Date: Mon, 21 Mar 2016 13:32:12 +1100
Message-ID: <20160321023155.603958101@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-disconnected-autosense-fix
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

I'm told that some targets are liable to disconnect a REQUEST SENSE
command. Theoretically this would cause a command undergoing autosense to
be moved onto the disconnected list. The bus reset handler must call
complete_cmd() for these commands, otherwise the hostdata->sensing pointer
will not get cleared. That would cause autosense processing to stall and
a timeout or an incorrect scsi_eh_restore_cmnd() would eventually follow.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:47.000000000 +1100
@@ -2437,7 +2437,7 @@ static int NCR5380_bus_reset(struct scsi
 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
 
 		set_host_byte(cmd, DID_RESET);
-		cmd->scsi_done(cmd);
+		complete_cmd(instance, cmd);
 	}
 	INIT_LIST_HEAD(&hostdata->disconnected);
 
