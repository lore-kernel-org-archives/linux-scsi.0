From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_scsi.c: Deinline
 fnic_queue_abort_io_req, save 1792 bytes
Date: Fri, 8 Apr 2016 15:08:46 -0400 (EDT)
Message-ID: <1514889616.28091362.1460142525998.JavaMail.zimbra@redhat.com>
References: <1460141926-13069-1-git-send-email-dvlasenk@redhat.com> <1460141926-13069-2-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:49485 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbcDHTIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 15:08:49 -0400
In-Reply-To: <1460141926-13069-2-git-send-email-dvlasenk@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Simple change, looks fine to me.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Denys Vlasenko" <dvlasenk@redhat.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: "Denys Vlasenko" <dvlasenk@redhat.com>, "Hiral Patel" <hiralpat@cisco.com>, "Suma Ramars" <sramars@cisco.com>, "Brian Uchino" <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Sent: Friday, April 8, 2016 2:58:43 PM
Subject: [PATCH] drivers/scsi/fnic/fnic_scsi.c: Deinline fnic_queue_abort_io_req, save 1792 bytes

This function compiles to 511 bytes of machine code.

Abort commands are not time-critical at all.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Hiral Patel <hiralpat@cisco.com>
CC: Suma Ramars <sramars@cisco.com>
CC: Brian Uchino <buchino@cisco.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 266b909..0a3edee 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1435,7 +1435,7 @@ wq_copy_cleanup_scsi_cmd:
 	}
 }
 
-static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
+static int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 					  u32 task_req, u8 *fc_lun,
 					  struct fnic_io_req *io_req)
 {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
