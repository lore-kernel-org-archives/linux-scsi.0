From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
Date: Sat, 28 Jul 2007 23:45:43 +0900
Message-ID: <200707281446.l6SEkGOD003581@mbox.iij4u.or.jp>
References: <46AB3C6A.2070209@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40902 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbXG1Oq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jul 2007 10:46:27 -0400
In-Reply-To: <46AB3C6A.2070209@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, nix.or.die@googlemail.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org

From: Gabriel C <nix.or.die@googlemail.com>
Subject: BSG: BLK_DEV_BSG=y , BLOCK=n compile error
Date: Sat, 28 Jul 2007 14:54:02 +0200

> Hi,
> 
> BSG does not compile without BLOCK set :

Thanks, this has already been addressed.

http://marc.info/?l=linux-kernel&m=118534836402440&w=2


James, could you add the patch to scsi-rc-fixes? Thanks.

---
From: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] bsg: Fix build for CONFIG_BLOCK=n

BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to
be enabled when CONFIG_BLOCK=n. This leads to many screenlengths of
errors, starting with a parse error on the request_queue_t definition.
Obviously this wasn't intended for CONFIG_BLOCK=n usage, so just move the
option back in to the block.

Caught with a randconfig on sh.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index ca2ef4e..2484e0e 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -49,8 +49,6 @@ config LSF
 
 	  If unsure, say Y.
 
-endif # BLOCK
-
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -64,4 +62,6 @@ config BLK_DEV_BSG
 	protocols (e.g. Task Management Functions and SMP in Serial
 	Attached SCSI).
 
+endif # BLOCK
+
 source block/Kconfig.iosched
-- 
1.5.2.4

