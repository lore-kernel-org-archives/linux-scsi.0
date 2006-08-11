From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] Add SATA support to aic94xx
Date: Thu, 10 Aug 2006 19:19:49 -0700
Message-ID: <44DBE945.7070206@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030693AbWHKCUR@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Make aic94xx call the functions that were added to libsas.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3ec2e46..3a673fe 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -76,6 +77,9 @@ static struct scsi_host_template aic94xx
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.slave_alloc		= sas_slave_alloc,
+	.target_destroy		= sas_target_destroy,
+	.ioctl			= sas_ioctl,
 };
