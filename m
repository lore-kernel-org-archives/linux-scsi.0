From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 06/07] scsi: add cmd->result clearing
Date: Tue, 12 Apr 2005 21:52:51 +0900 (KST)
Message-ID: <20050412125219.DF27C115@htj.dyndns.org>
References: <20050412125219.88E5C1F6@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.202]:21786 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262441AbVDLMxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 08:53:00 -0400
Received: by rproxy.gmail.com with SMTP id j1so1380405rnf
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 05:52:56 -0700 (PDT)
In-Reply-To: <20050412125219.88E5C1F6@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

06_scsi_requeue_reset_result.patch

	cmd->result wasn't cleared on requeue or reprep.  Clear it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi.c     |    9 +++++----
 scsi_lib.c |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi.c	2005-04-12 21:50:11.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi.c	2005-04-12 21:50:12.000000000 +0900
@@ -681,11 +681,12 @@ void scsi_retry_command(struct scsi_cmnd
 	 */
 	scsi_setup_cmd_retry(cmd);
 
-        /*
-         * Zero the sense information from the last time we tried
-         * this command.
-         */
+	/*
+	 * Zero the sense information and result code from the last
+	 * time we tried this command.
+	 */
 	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+	cmd->result = 0;
 
 	scsi_requeue_command(cmd);
 }
Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-12 21:50:12.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-12 21:50:12.000000000 +0900
@@ -222,6 +222,7 @@ static int scsi_init_cmd_errh(struct scs
 	cmd->abort_reason = 0;
 
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
+	cmd->result = 0;
 
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);

