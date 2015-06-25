From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 1/1] ipr: Fix invalid array indexing for HRRQ
Date: Thu, 25 Jun 2015 11:00:14 -0500
Message-ID: <558C258E.4000002@linux.vnet.ibm.com>
References: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com> <558C11F0.6020505@suse.cz> <558C23F4.8050709@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <558C23F4.8050709@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Updated version per comments from Jiri Slaby. Thanks!

8<

Fixes another signed / unsigned array indexing bug in the ipr driver.
Currently, when hrrq_index wraps, it becomes a negative number. We
do the modulo, but still have a negative number, so we end up indexing
backwards in the array. Given where the hrrq array is located in memory,
we probably won't actually reference memory we don't own, but nonetheless
ipr is still looking at data within struct ipr_ioa_cfg and interpreting it as
struct ipr_hrr_queue data, so bad things could certainly happen.

Each ipr adapter has anywhere from 1 to 16 HRRQs. By default, we use 2 on new adapters.
Let's take an example:

Assume ioa_cfg->hrrq_index=0x7fffffffe and ioa_cfg->hrrq_num=4:

The atomic_add_return will then return -1. We mod this with 3 and get -2, add one and
get -1 for an array index.

On adapters which support more than a single HRRQ, we dedicate HRRQ to adapter
initialization and error interrupts so that we can optimize the other queues for
fast path I/O. So all normal I/O uses HRRQ 1-15. So we want to spread the I/O
requests across those HRRQs.

With the default module parameter settings, this bug won't hit, only when someone
sets the ipr.number_of_msix parameter to a value larger than 3 is when bad things
start to happen.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
---

 drivers/scsi/ipr.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_hrrq_index_fix drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_hrrq_index_fix	2015-06-23 11:43:18.151741523 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-25 10:54:24.954615461 -0500
@@ -1052,10 +1052,15 @@ static void ipr_send_blocking_cmd(struct
 
 static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
 {
+	unsigned int hrrq;
+
 	if (ioa_cfg->hrrq_num == 1)
-		return 0;
-	else
-		return (atomic_add_return(1, &ioa_cfg->hrrq_index) % (ioa_cfg->hrrq_num - 1)) + 1;
+		hrrq = 0;
+	else {
+		hrrq = atomic_add_return(1, &ioa_cfg->hrrq_index);
+		hrrq = (hrrq % (ioa_cfg->hrrq_num - 1)) + 1;
+	}
+	return hrrq;
 }
 
 /**
_
