From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi_lib: BUG: Can't RETRY scsi_cmnd if some bytes were completed
Date: Mon, 08 Nov 2010 18:18:58 +0200
Message-ID: <4CD822F2.6060101@panasas.com>
References: <4CD810FA.902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:59868 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753771Ab0KHQTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 11:19:25 -0500
In-Reply-To: <4CD810FA.902@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Re-inspecting the code after the last cleanup actually exposed
a BAD bug for me. See below. James this is based on the last
patchset I sent.

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi_lib: BUG: Can't RETRY scsi_cmnd if some bytes were completed

In scsi_io_completion() there are many cases where action is
set to ACTION_RETRY or ACTION_DELAYED_RETRY. But we are not
allowed to just RETRY a command if some bytes where already
completed by blk_end_request(). This is a bad memory overrun
of DMA writing/reading random memory. We must re-prepare the
command in this case.

It is possible that all the cases that set ACTION_RETRY* have
actually come with good_bytes=0 (.i.e resid = everything) But
both the error and resid value come from LLDs and/or targets
and should not be trusted with such a BAD crash. Better safe
than sorry.

It is possible that this fix is actually not good enough and
in the case of some of these RETRYs we need to not call
blk_end_request() in the first place. But this calls for
a structural reorganisation of scsi_io_completion(). James
this is your turf please have a look.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d76a69b..b78b34e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -827,6 +827,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	if (action >= ACTION_RETRY && good_bytes)
+		/* We cannot just retry if above blk_end_request advanced on
+		 * some good_bytes, so ACTION_REPREP
+		 */
+		action = ACTION_REPREP;
+
 	switch (action) {
 	case ACTION_NEXT_CMND:
 		scsi_release_buffers(cmd);
-- 
1.7.2.3


