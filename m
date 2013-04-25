From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] sd: workaround invalid OPTIMAL TRANSFER LENGTH
Date: Wed, 24 Apr 2013 21:19:47 -0400
Message-ID: <yq1bo93v230.fsf@sermon.lab.mkp.net>
References: <20130403202124.GB2197@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50687 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab3DYBTa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:19:30 -0400
In-Reply-To: <20130403202124.GB2197@redhat.com> (Mike Snitzer's message of
	"Wed, 3 Apr 2013 16:21:24 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Following up on our discussion at LSF/MM last week...

Mike> Workaround disk firmware that improperly sets OPTIMAL TRANSFER
Mike> LENGTH to 0xFFFFFFFF (aka UINT_MAX or 4294967295U) by assuming
Mike> this _optional_ BLOCK LIMITS VPD field was not specified (0).

My only real objection is that UINT_MAX appears to be completely
coincidental. What if the next drive specifies UINT_MAX-1 or $RANDOM?

Lacking a decent heuristic I'd rather just blacklist the offending drive
using the skip_vpd_pages knob we already have in place.

-- 
Martin K. Petersen	Oracle Linux Engineering


[SCSI] Workaround for disks that report bad optimal transfer length

Not all disks fill out the VPD pages correctly. Add a blacklist flag
that allows us ignore the SBC-3 VPD pages for a given device. The
BLIST_SKIP_VPD_PAGES flag triggers our existing skip_vpd_pages
scsi_device parameter to bypass VPD scanning.

Also blacklist the offending Seagate drive model.

Reported-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>


diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 43fca91..f969aca 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -228,6 +228,7 @@ static struct {
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
 	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
+	{"SEAGATE", "ST900MM0006", NULL, BLIST_SKIP_VPD_PAGES},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..b9e39e0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -924,6 +924,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_SKIP_VPD_PAGES)
+		sdev->skip_vpd_pages = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index cc1f3e7..447d2d7 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -31,4 +31,5 @@
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
+#define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
 #endif
