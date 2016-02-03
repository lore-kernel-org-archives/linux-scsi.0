From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [patch] bfa: use strncpy() instead of memcpy()
Date: Wed, 3 Feb 2016 06:50:21 +0000
Message-ID: <CY1PR11MB02187EB4971544D5B1336E4594D00@CY1PR11MB0218.namprd11.prod.outlook.com>
References: <20160130143603.GB3462@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160130143603.GB3462@mwanda>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: 30 January 2016 20:06
To: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>; James E.J. Bottomley <JBottomley@odin.com>; Martin K. Petersen <martin.petersen@oracle.com>; linux-scsi <linux-scsi@vger.kernel.org>; linux-kernel <linux-kernel@vger.kernel.org>; kernel-janitors@vger.kernel.org
Subject: [patch] bfa: use strncpy() instead of memcpy()

BFA_MFG_NAME is "QLogic" which is only 7 bytes, but we are copying 8 bytes.  It's harmless because the badding byte is likely zero but it makes static checkers complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Technically the memset() is not needed because strncpy() will pad the rest of the buffer with zeros but I was worried that people would be paranoid.

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c index 251e2ff..a1ada4a 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2803,7 +2803,7 @@ void
 bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)  {
 	memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
-	memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+	strncpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
 }
 
 void
