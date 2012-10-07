From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: standards revisions
Date: Sat, 06 Oct 2012 23:11:50 -0700
Message-ID: <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
References: <20121007014900.GA30316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20121007014900.GA30316@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2012-10-06 at 21:49 -0400, Christoph Hellwig wrote:
> Currenly all non-pscsi bakcneds report their standards version as
> SPC 2 via ->get_device_rev.

No, the proper on-the-wire bits to signal SPC-3 compliance are already
being returned by virtual backend drivers within standard INQUIRY
payload data.  

Notice the comment:

root@tifa:/usr/src/target-pending.git# grep SCSI_SPC_2 drivers/target/*.c
drivers/target/target_core_file.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
drivers/target/target_core_iblock.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
drivers/target/target_core_rd.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */

>  In addition to putting it into the
> inquirty data in spc_emulate_inquiry_std we also use it in two
> places to check on the version of the persistent reservation and
> alua support.  What is the benefit of supporting the old-style SCSI 2
> reservations and ALUA support when they can't be used at all with
> the virtual backends, and can only be used in the corner case emulated
> ALUA/PR support for pscsi?
> 

It's the include/scsi/scsi.h SCSI_3 + SCSI_SPC_* version definition
names that are incorrect:

#define SCSI_UNKNOWN    0
#define SCSI_1          1
#define SCSI_1_CCS      2
#define SCSI_2          3
#define SCSI_3          4        /* SPC */
#define SCSI_SPC_2      5
#define SCSI_SPC_3      6

from spc4r30 section 6.4.2 Standard INQUIRY data, Table 142 -- Version:

   00h     The device server does not claim conformance to any standard.
01h to 02h Obsolete
   03h     The device server complies to ANSI INCITS 301-1997 (a withdrawn standard).
   04h     The device server complies to ANSI INCITS 351-2001 (SPC-2).
   05h     The device server complies to ANSI INCITS 408-2005 (SPC-3).
   06h     The device server complies to this standard.

How about the following patch to fix the long-standing incorrect name
usage of these three scsi.h defines..?

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d947ffc..60ae194 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -834,7 +834,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
        sdev->lockable = sdev->removable;
        sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
 
-       if (sdev->scsi_level >= SCSI_3 ||
+       if (sdev->scsi_level >= SCSI_SPC_2 ||
                        (sdev->inquiry_len > 56 && inq_result[56] & 0x04))
                sdev->ppr = 1;
        if (inq_result[7] & 0x60)
@@ -1200,7 +1200,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
         * Do not scan SCSI-2 or lower device past LUN 7, unless
         * BLIST_LARGELUN.
         */
-       if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN))
+       if (scsi_level < SCSI_SPC_2 && !(bflags & BLIST_LARGELUN))
                max_dev_lun = min(8U, max_dev_lun);
 
        /*
@@ -1327,7 +1327,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
        if (starget->scsi_level < SCSI_2 &&
            starget->scsi_level != SCSI_UNKNOWN)
                return 1;
-       if (starget->scsi_level < SCSI_3 &&
+       if (starget->scsi_level < SCSI_SPC_2 &&
            (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8))
                return 1;
        if (bflags & BLIST_NOLUN)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..f7dd7ec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1901,7 +1901,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
                return 0;
        if (sdp->try_rc_10_first)
                return 0;
-       if (sdp->scsi_level > SCSI_SPC_2)
+       if (sdp->scsi_level > SCSI_SPC_3)
                return 1;
        if (scsi_device_protection(sdp))
                return 1;
@@ -2443,7 +2443,7 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
         * some USB ones crash on receiving them, and the pages
         * we currently ask for are for SPC-3 and beyond
         */
-       if (sdp->scsi_level > SCSI_SPC_2 && !sdp->skip_vpd_pages)
+       if (sdp->scsi_level > SCSI_SPC_3 && !sdp->skip_vpd_pages)
                return 1;
        return 0;
 }
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0360383..65941e5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -536,7 +536,7 @@ static ssize_t fd_show_configfs_dev_params(
  */
 static u32 fd_get_device_rev(struct se_device *dev)
 {
-       return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
+       return SCSI_SPC_3;
 }
 
 /*     fd_get_device_type(): (Part of se_subsystem_api_t template)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 29408d4..7ed94b0 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -713,7 +713,7 @@ fail:
 
 static u32 iblock_get_device_rev(struct se_device *dev)
 {
-       return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
+       return SCSI_SPC_3;
 }
 
 static u32 iblock_get_device_type(struct se_device *dev)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index d00bbe3..df5a811 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -445,7 +445,7 @@ static ssize_t rd_show_configfs_dev_params(
 
 static u32 rd_get_device_rev(struct se_device *dev)
 {
-       return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
+       return SCSI_SPC_3;
 }
 
 static u32 rd_get_device_type(struct se_device *dev)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..cad47eb 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -536,9 +536,9 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define SCSI_1          1
 #define SCSI_1_CCS      2
 #define SCSI_2          3
-#define SCSI_3          4        /* SPC */
-#define SCSI_SPC_2      5
-#define SCSI_SPC_3      6
+#define SCSI_SPC_2      4      /* ANSI INCITS 351-2001 (SPC-2) */
+#define SCSI_SPC_3      5      /* ANSI INCITS 408-2005 (SPC-3) */
+#define SCSI_SPC_4      6
 
 /*
  * INQ PERIPHERAL QUALIFIERS
