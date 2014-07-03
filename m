From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 3 Jul 2014 10:18:07 -0700
Message-ID: <20140703171807.GA20300@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <20140626150208.GA14887@infradead.org>
 <1403808734.6440.12.camel@dabdike>
 <20140627075553.GB21799@infradead.org>
 <CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
 <CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
 <20140701081510.GA14857@infradead.org>
 <CAPK7rjdVM-Anw-uFc6RGCrwZko885vBGgbB+LehmuKF4r6nu5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGCRSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 13:18:07 -0400
Content-Disposition: inline
In-Reply-To: <CAPK7rjdVM-Anw-uFc6RGCrwZko885vBGgbB+LehmuKF4r6nu5A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Haber <steven@qumulo.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Thu, Jul 03, 2014 at 09:57:32AM -0700, Steven Haber wrote:
> Both patches work fine -- zero uncommitted writes over several hundred
> power cycles.

Thanks for the testing.

Below is James' patch with a trivial comment fix and a proper changelog.
James, can I get your signoff for this one?  I'll throw it into the
core-for-3.16 tree then.

---
>From 92510736caa3b14a964af981ba288950042e79e3 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 3 Jul 2014 19:17:34 +0200
Subject: scsi: handle flush errors properly

Flush commands don't transfer data and thus need to be special cased
in the I/O completion handler so that we can propagate errors to
the block layer and filesystem.

Reported-by: Steven Haber <steven@qumulo.com>
Tested-by: Steven Haber <steven@qumulo.com>
---
 drivers/scsi/scsi_lib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..143d0e2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,6 +733,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_next_command(cmd);
 			return;
 		}
+	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
+		/*
+		 * Certain non BLOCK_PC requests are commands that don't
+		 * actually transfer anything (FLUSH), so cannot use
+		 * good_bytes == 0 as the signal for an error.  This sets the
+		 * error explicitly for the problem case.
+		 */
+		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */
-- 
1.7.10.4

