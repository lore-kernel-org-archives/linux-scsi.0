From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] [SCSI] sym53c8xx_2: iterator underflow in sym_getsync()
Date: Thu, 25 Jan 2018 17:13:40 +0300
Message-ID: <20180125141340.GA7299@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

We wanted to exit the loop with "div" set to zero, but instead, if we
don't hit the break then "div" is -1 when we finish the loop.  It leads
to an array underflow a few lines later.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index ca360daa6a25..378af306fda1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -536,7 +536,7 @@ sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fa
 	 *  Look for the greatest clock divisor that allows an 
 	 *  input speed faster than the period.
 	 */
-	while (div-- > 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
