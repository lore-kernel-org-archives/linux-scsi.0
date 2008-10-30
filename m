From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 08/17] drivers/scsi/megaraid: Use DIV_ROUND_UP
Date: Thu, 30 Oct 2008 07:19:20 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D3C546B@cosmail02.lsi.com>
References: <200810292124.m9TLOf9J021235@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61275 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYJ3NUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 09:20:18 -0400
In-Reply-To: <200810292124.m9TLOf9J021235@imap1.linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "julia@diku.dk" <julia@diku.dk>, "Austria, Winston" <Winston.Austria@lsi.com>

NACK.

As I mentioned before, frame_count is the parameter which used by both megaraid_sas driver and fw.  For the driver code constancy and more readable, please don't change the way we compute the frame_count.

Thanks,

Bo Yang

-----Original Message-----
From: akpm@linux-foundation.org [mailto:akpm@linux-foundation.org]
Sent: Wednesday, October 29, 2008 5:25 PM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; julia@diku.dk; Yang, Bo
Subject: [patch 08/17] drivers/scsi/megaraid: Use DIV_ROUND_UP

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -1718,7 +1718,7 @@ static int megasas_create_frame_pool(str
         * Calculated the number of 64byte frames required for SGL
         */
        sgl_sz = sge_sz * instance->max_num_sge;
-       frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+       frame_count = DIV_ROUND_UP(sgl_sz, MEGAMFI_FRAME_SIZE);

        /*
         * We need one extra frame for the MFI command
_
