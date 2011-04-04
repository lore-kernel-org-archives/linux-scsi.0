From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/4] mpt2sas: do not check serial_number in the abort
 handler
Date: Mon, 4 Apr 2011 08:20:11 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F804234D0@cosmail03.lsi.com>
References: <20110404134203.GA29525@infradead.org>,<20110404134230.GC32522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52454 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1DDOTF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2011 10:19:05 -0400
In-Reply-To: <20110404134230.GC32522@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

sounds good

ACK
________________________________________
From: Christoph Hellwig [hch@infradead.org]
Sent: Monday, April 04, 2011 7:42 AM
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: [PATCH 3/4] mpt2sas: do not check serial_number in the abort handler

The SCSI midlayer stops all command processing when in error handling, which
means there is no chance for command reuse when the abort handler is called.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c 2011-04-04 06:25:05.892763786 -0700
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c      2011-04-04 06:25:24.592763544 -0700
@@ -2133,8 +2133,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_AD
        switch (type) {
        case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
                scmd_lookup = _scsih_scsi_lookup_get(ioc, smid_task);
-               if (scmd_lookup && (scmd_lookup->serial_number ==
-                   scmd->serial_number))
+               if (scmd_lookup)
                        rc = FAILED;
                else
                        rc = SUCCESS;
