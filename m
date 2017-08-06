From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: mpt3sas: Fix memory allocation failure test in 'mpt3sas_base_attach()'
Date: Mon,  7 Aug 2017 00:51:29 +0200
Message-ID: <20170806225134.27079-1-christophe.jaillet@wanadoo.fr>
References: <cover.1502058761.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1502058761.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

In the lines above this test, 8 'kzalloc' are performed, but only 7 results
are tested.

Add the missing one (i.e. '!ioc->port_enable_cmds.reply').

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1a5b6e40fb5c..8a44636ab0b5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5494,10 +5494,10 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
 	mutex_init(&ioc->ctl_cmds.mutex);
 
-	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
-	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
-	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply ||
-	    !ioc->ctl_cmds.sense) {
+	if (!ioc->base_cmds.reply || !ioc->port_enable_cmds.reply ||
+	    !ioc->transport_cmds.reply || !ioc->scsih_cmds.reply ||
+	    !ioc->tm_cmds.reply || !ioc->config_cmds.reply ||
+	    !ioc->ctl_cmds.reply || !ioc->ctl_cmds.sense) {
 		r = -ENOMEM;
 		goto out_free_resources;
 	}
-- 
2.11.0
