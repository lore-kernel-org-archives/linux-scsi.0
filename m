From: Anil Gurumurthy <agurumur@Brocade.com>
Subject: RE: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()
Date: Fri, 11 Jan 2013 01:33:39 -0700
Message-ID: <4D34E914CE7A004D8570F4381FDE55490B6D93F914@BRM-EXCH-3.corp.brocade.com>
References: <20130110090620.GE23063@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130110090620.GE23063@elgon.mountain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vijay Mohan Guvva <vmohan@Brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dan Carpenter
Sent: Thursday, January 10, 2013 2:36 PM
To: Anil Gurumurthy
Cc: Vijay Mohan Guvva; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()

The closing parenthesis is in the wrong place so it takes the sizeof a pointer instead of the sizeof the buffer minus one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index e6bf126..a5f7690 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1034,7 +1034,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 			sizeof(driver_info.host_os_patch) - 1);
 
 	strncpy(driver_info.os_device_name, bfad->pci_name,
-		sizeof(driver_info.os_device_name - 1));
+		sizeof(driver_info.os_device_name) - 1);
 
 	/* FCS driver info init */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
--


Looks good. Thanks for the patch, Dan.

Acked-by: Anil Gurumurthy<agurumur@brocade.com>


To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
