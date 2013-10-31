From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/1] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Thu, 31 Oct 2013 14:01:02 +0530
Message-ID: <1383208262-3203-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35254 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab3JaIfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Oct 2013 04:35:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, torvalds@linux-foundation.org
Cc: aacraid@adaptec.com, aacraid@pmc-sierra.com, Achim.Leubner@pmcs.com, Tony.Ruiz@pmcs.com, Mahesh.Rajashekhara@pmcs.com

It appears that driver runs into a problem here if fibsize is too small because we allocate user_srbcmd with fibsize size only but later we access it until user_srbcmd->sg.count to copy it over to srbcmd. Seems to be not correct to test (fibsize < sizeof(*user_srbcmd)) because this structure already includes one sg element and this is not needed for commands without data. So, we would recommend to add the following (instead of test for fibsize == 0).

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/commctrl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d85ac1a..fbcd48d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -511,7 +511,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-- 
1.7.7.3

