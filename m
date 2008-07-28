From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Build fallout from scsi merge...
Date: Mon, 28 Jul 2008 11:59:20 +0900
Message-ID: <20080728115954E.fujita.tomonori@lab.ntt.co.jp>
References: <20080727.170415.12257647.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:56230 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYG1C73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 22:59:29 -0400
In-Reply-To: <20080727.170415.12257647.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 17:04:15 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> From allmodconfig on sparc64:
> 
> drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
> drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
> make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
> make[3]: *** Waiting for unfinished jobs....

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] qla2xxx: fix msleep compile error

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
make[3]: *** Waiting for unfinished jobs....

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7a4409a..a319a20 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
-- 
1.5.5.GIT

