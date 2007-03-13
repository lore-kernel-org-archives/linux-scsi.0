From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] return valid data with sense
Date: Tue, 13 Mar 2007 16:53:28 -0400
Message-ID: <20070313205328.GA29140@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:59516 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbXCMUx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2007 16:53:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Some targets can return both valid data and sense information.
Always update the request data_len from the SCSI command residual.
Callers should interpret sense data to determine what parts of the
data are valid in case of a CHECK CONDITION status.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f95570..be8e655 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -848,8 +848,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				memcpy(req->sense, cmd->sense_buffer,  len);
 				req->sense_len = len;
 			}
-		} else
-			req->data_len = cmd->resid;
+		}
+		req->data_len = cmd->resid;
 	}
 
 	/*
-- 
1.5.0.2

