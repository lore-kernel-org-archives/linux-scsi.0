From: Max Kellermann <mk@cm4all.com>
Subject: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Mon, 15 Jan 2018 18:26:01 +0100
Message-ID: <151603716189.28707.13105191089826357709.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nibbler.cm4all.net ([82.165.145.151]:52363 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbeAORe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 12:34:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 85322C0121
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 18:26:02 +0100 (CET)
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id zgYK3iNH1hpY for <linux-scsi@vger.kernel.org>;
        Mon, 15 Jan 2018 18:26:02 +0100 (CET)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 2BB0CC0106
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 18:26:02 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com
Cc: max.kellermann@gmail.com, linux-kernel@vger.kernel.org

When the qla2xxx firmware is unavailable, eventually
qla2x00_sp_timeout() is reached, which calls the timeout function and
frees the srb_t instance.

The timeout function always resolves to qla2x00_async_iocb_timeout(),
which invokes another callback function called "done".  All of these
qla2x00_*_sp_done() callbacks also free the srb_t instance; after
returning to qla2x00_sp_timeout(), it is freed again.

The fix is to remove the "sp->free(sp)" call from qla2x00_sp_timeout()
and add it to those code paths in qla2x00_async_iocb_timeout() which
do not already free the object.

This is how it looks like with KASAN:

 BUG: KASAN: use-after-free in qla2x00_sp_timeout+0x228/0x250
 Read of size 8 at addr ffff88278147a590 by task swapper/2/0

 Allocated by task 1502:
  save_stack+0x33/0xa0
  kasan_kmalloc+0xa0/0xd0
  kmem_cache_alloc+0xb8/0x1c0
  mempool_alloc+0xd6/0x260
  qla24xx_async_gnl+0x3c5/0x1100

 Freed by task 0:
  save_stack+0x33/0xa0
  kasan_slab_free+0x72/0xc0
  kmem_cache_free+0x75/0x200
  qla24xx_async_gnl_sp_done+0x556/0x9e0
  qla2x00_async_iocb_timeout+0x1c7/0x420
  qla2x00_sp_timeout+0x16d/0x250
  call_timer_fn+0x36/0x200

 The buggy address belongs to the object at ffff88278147a440
  which belongs to the cache qla2xxx_srbs of size 344
 The buggy address is located 336 bytes inside of
  344-byte region [ffff88278147a440, ffff88278147a598)

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b5b48ddca962..801890564e00 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -58,7 +58,6 @@ qla2x00_sp_timeout(unsigned long __data)
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	sp->free(sp);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 }
 
@@ -121,9 +120,11 @@ qla2x00_async_iocb_timeout(void *data)
 		ea.data[1] = lio->u.logio.data[1];
 		ea.sp = sp;
 		qla24xx_handle_plogi_done_event(fcport->vha, &ea);
+		sp->free(sp);
 		break;
 	case SRB_LOGOUT_CMD:
 		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
+		sp->free(sp);
 		break;
 	case SRB_CT_PTHRU_CMD:
 	case SRB_MB_IOCB:
