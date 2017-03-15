From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] check length passed to SG_NEXT_CMD_LEN
Date: Wed, 15 Mar 2017 19:38:17 -0400
Message-ID: <yq1zigmf6vq.fsf@oracle.com>
References: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30793 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdCOXi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 19:38:26 -0400
In-Reply-To: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
        (Peter Chang's message of "Thu, 2 Mar 2017 10:29:39 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Peter Chang <dpf@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>

Peter Chang <dpf@google.com> writes:

> now that i think i've got gmail not marking everything as spam...

Doug?

>From 93409c62db49d15105390315a685e54083029bee Mon Sep 17 00:00:00 2001
From: peter chang <dpf@google.com>
Date: Wed, 15 Feb 2017 14:11:54 -0800
Subject: [PATCH] [sg] check length passed to SG_NEXT_CMD_LEN

the user can control the size of the next command passed along, but
the value passed to the ioctl isn't checked against the usable
max command size.

Change-Id: I9ac2ae07c35cf5fda62d7afad32c8d9ab6a9ea1d
Tested: sanity checked w/ calling the ioctl w/ a bogus size
---
 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9c5c5f2b3962..b47a369cb71c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -976,6 +976,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		result = get_user(val, ip);
 		if (result)
 			return result;
+		if (val > SG_MAX_CDB_SIZE)
+			return -ENOMEM;
 		sfp->next_cmd_len = (val > 0) ? val : 0;
 		return 0;
 	case SG_GET_VERSION_NUM:
-- 
2.12.0.rc1.440.g5b76565f74-goog

-- 
Martin K. Petersen	Oracle Linux Engineering
