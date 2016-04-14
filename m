From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] hpsa: set the enclosure identifier to zero
Date: Thu, 14 Apr 2016 12:37:44 +0300
Message-ID: <20160414093744.GJ16549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This has only called from show_sas_rphy_enclosure_identifier().  The
caller expects that we set an identifier, otherwise it uses an
unintialized variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5be944c..25aa219 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9602,6 +9602,7 @@ hpsa_sas_get_linkerrors(struct sas_phy *phy)
 static int
 hpsa_sas_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 {
+	*identifier = 0;
 	return 0;
 }
 
