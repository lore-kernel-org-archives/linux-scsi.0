From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP
Date: Mon, 4 Aug 2008 06:40:27 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
References: <Pine.LNX.4.64.0808021715270.20095@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755340AbYHDMkz@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808021715270.20095@ask.diku.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.k>
Cc: "Austria, Winston" <Winston.Austria@lsi.com>, "Yuen, Eric" <Eric.Yuen@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Julia,

Frame_count is the major parameter used by our megaraid sas FW.  It may cause some issues after this change.  Please keep the original implementation.

Thanks.

Bo Yang

-----Original Message-----
From: Julia Lawall [mailto:julia@diku.dk]
Sent: Saturday, August 02, 2008 11:16 AM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP

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

---
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1615,7 +1615,7 @@ static int megasas_create_frame_pool(str
         * Calculated the number of 64byte frames required for SGL
         */
        sgl_sz = sge_sz * instance->max_num_sge;
-       frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+       frame_count = DIV_ROUND_UP(sgl_sz, MEGAMFI_FRAME_SIZE);

        /*
         * We need one extra frame for the MFI command
