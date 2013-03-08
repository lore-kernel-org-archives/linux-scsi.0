From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Date: Fri, 8 Mar 2013 15:02:15 +0300
Message-ID: <20130308120215.GB18712@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Static checkers complain that this allocation isn't checked.  We
should return zero if the allocation fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..a022997 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
 {
 	const int vpd_len = 32;
 	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
-	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
+	char *buffer;
 	int ret = 0;
 
+	buffer = kzalloc(vpd_len, GFP_KERNEL);
+	if (!buffer)
+		goto out;
 	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
 		goto out;
 
