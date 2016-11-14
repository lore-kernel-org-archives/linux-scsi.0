From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: correct logical resets
Date: Mon, 14 Nov 2016 18:44:10 -0500
Message-ID: <yq160npfwz9.fsf@sermon.lab.mkp.net>
References: <147881417483.804.10756927186886954941.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44909 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938935AbcKNXow (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:44:52 -0500
In-Reply-To: <147881417483.804.10756927186886954941.stgit@brunhilda> (Don
        Brace's message of "Thu, 10 Nov 2016 15:42:54 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0b6eb5a..a296537 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -300,6 +300,10 @@ static bool hpsa_cmd_dev_match(struct ctlr_info *h, struct CommandList *c,
 			       struct hpsa_scsi_dev_t *dev,
 			       unsigned char *scsi3addr);
 
+static int wait_for_device_to_become_ready(struct ctlr_info *h,
+					   unsigned char lunaddr[],
+					   int reply_queue);
+
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
 	unsigned long *priv = shost_priv(sdev->host);

Wouldn't it be nicer to put this with the rest of the function
prototypes at the beginning of the file?

-- 
Martin K. Petersen	Oracle Linux Engineering
