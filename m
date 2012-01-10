From: akpm@linux-foundation.org
Subject: [patch 3/6] drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()
Date: Tue, 10 Jan 2012 15:42:32 -0800
Message-ID: <20120110234233.17DB120012E@hpza10.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64968 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab2AJXme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 18:42:34 -0500
Received: by mail-ey0-f202.google.com with SMTP id k10so4933eaa.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 15:42:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jj@chaosbits.net

From: Jesper Juhl <jj@chaosbits.net>
Subject: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()

We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :

We allocate memory:
        ...
                        struct user_sgmap* usg;
                        usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
                          + sizeof(struct sgmap), GFP_KERNEL);
and then neglect to free it:
        ...
                        for (i = 0; i < usg->count; i++) {
                                u64 addr;
                                void* p;
                                if (usg->sg[i].count >
                                    ((dev->adapter_info.options &
                                     AAC_OPT_NEW_COMM) ?
                                      (dev->scsi_host_ptr->max_sectors << 9) :
                                      65536)) {
                                        rcode = -EINVAL;
                                        goto cleanup;
        ... this 'goto' makes 'usg' go out of scope and leak the memory we
            allocated.
            Other exits properly kfree(usg), it's just here it is neglected.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commctrl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -650,6 +650,7 @@ static int aac_send_raw_srb(struct aac_d
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
+					kfree(usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
_
