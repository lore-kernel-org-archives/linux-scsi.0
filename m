From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] scsi_debug: reset injection flags for every_nth > 0
Date: Mon,  5 Feb 2018 15:17:40 +0100
Message-ID: <20180205141740.32418-2-mwilck@suse.com>
References: <20180205141740.32418-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46558 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbeBEOSY (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 5 Feb 2018 09:18:24 -0500
In-Reply-To: <20180205141740.32418-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>

If every_nth > 0, the injection flags must be reset for commands
that aren't supposed to fail (i.e. that aren't "nth"). Otherwise,
commands will continue to fail, like in the every_nth < 0 case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_debug.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 86c48797381e..820b98853e69 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3988,8 +3988,13 @@ static void clear_queue_stats(void)
 static void setup_inject(struct sdebug_queue *sqp,
 			 struct sdebug_queued_cmd *sqcp)
 {
-	if ((atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) > 0)
+	if ((atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) > 0) {
+		if (sdebug_every_nth > 0)
+			sqcp->inj_recovered = sqcp->inj_transport
+				= sqcp->inj_dif
+				= sqcp->inj_dix = sqcp->inj_short = 0;
 		return;
+	}
 	sqcp->inj_recovered = !!(SDEBUG_OPT_RECOVERED_ERR & sdebug_opts);
 	sqcp->inj_transport = !!(SDEBUG_OPT_TRANSPORT_ERR & sdebug_opts);
 	sqcp->inj_dif = !!(SDEBUG_OPT_DIF_ERR & sdebug_opts);
-- 
2.16.1
