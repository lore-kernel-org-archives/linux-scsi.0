From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [PATCH 2.5] megaraid driver updates 3/4
Date: Wed, 30 Oct 2002 16:15:20 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301614490.29157-100000@humbolt.us.dell.com>
References: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.808.33.1, 2002-10-28 23:40:01-06:00, Matt_Domsch@dell.com
  Merge dell.com:/home/mdomsch/bk/linux-2.5
  into dell.com:/home/mdomsch/bk/linux-2.5-megaraid


 megaraid.c |   29 ++++++++++++++---------------
 megaraid.h |    2 --
 2 files changed, 14 insertions, 17 deletions


diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Wed Oct 30 15:56:13 2002
+++ b/drivers/scsi/megaraid.c	Wed Oct 30 15:56:13 2002
@@ -522,8 +522,6 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-
-#include "sd.h"
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsicam.h>
@@ -4054,25 +4052,26 @@
  *     geom[1] = sectors
  *     geom[2] = cylinders
  *-------------------------------------------------------------*/
-int megaraid_biosparam (Disk * disk, struct block_device *bdev, int *geom)
+int megaraid_biosparam (struct scsi_device *sdev, struct block_device *bdev,
+				sector_t capacity, int *geom)
 {
 	int heads, sectors, cylinders;
 	mega_host_config *megaCfg;
 
 	/* Get pointer to host config structure */
-	megaCfg = (mega_host_config *) disk->device->host->hostdata;
+	megaCfg = (mega_host_config *) sdev->host->hostdata;
 
-	if( IS_RAID_CH(disk->device->channel)) {
+	if( IS_RAID_CH(sdev->channel)) {
 			/* Default heads (64) & sectors (32) */
 			heads = 64;
 			sectors = 32;
-			cylinders = (unsigned long)disk->capacity / (heads * sectors);
+			cylinders = (unsigned long)capacity / (heads * sectors);
 
 			/* Handle extended translation size for logical drives > 1Gb */
-			if (disk->capacity >= 0x200000) {
+			if (capacity >= 0x200000) {
 				heads = 255;
 				sectors = 63;
-				cylinders = (unsigned long)disk->capacity / (heads * sectors);
+				cylinders = (unsigned long)capacity / (heads * sectors);
 			}
 
 			/* return result */
@@ -4081,22 +4080,22 @@
 			geom[2] = cylinders;
 	}
 	else {
-		if( mega_partsize(disk, bdev, geom) == 0 ) return 0;
+		if( mega_partsize(bdev, capacity, geom) == 0 ) return 0;
 
 		printk(KERN_WARNING
 				"megaraid: invalid partition on this disk on channel %d\n",
-				disk->device->channel);
+				sdev->channel);
 
 		/* Default heads (64) & sectors (32) */
 		heads = 64;
 		sectors = 32;
-		cylinders = disk->capacity >> 11;
+		cylinders = capacity >> 11;
 
 		/* Handle extended translation size for logical drives > 1Gb */
-		if (disk->capacity >= 0x200000) {
+		if (capacity >= 0x200000) {
 			heads = 255;
 			sectors = 63;
-			cylinders = (unsigned long)disk->capacity / (heads * sectors);
+			cylinders = (unsigned long)capacity / (heads * sectors);
 		}
 
 		/* return result */
@@ -4119,12 +4118,12 @@
  * Returns : -1 on failure, 0 on success.
  */
 static int
-mega_partsize(Disk * disk, struct block_device *bdev, int *geom)
+mega_partsize(struct block_device *bdev, sector_t capacity, int *geom)
 {
 	struct partition *p, *largest = NULL;
 	int i, largest_cyl;
 	int heads, cyls, sectors;
-	int capacity = disk->capacity;
+	int capacity = capacity;
 	unsigned char *buf;
 
 	if (!(buf = scsi_bios_ptable(bdev)))
diff -Nru a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h	Wed Oct 30 15:56:13 2002
+++ b/drivers/scsi/megaraid.h	Wed Oct 30 15:56:13 2002
@@ -989,8 +989,6 @@
 			      int lock, int intr);
 
 static int mega_is_bios_enabled (mega_host_config *);
-static void mega_reorder_hosts (void);
-static void mega_swap_hosts (struct Scsi_Host *, struct Scsi_Host *);
 
 static void mega_create_proc_entry (int index, struct proc_dir_entry *);
 static int mega_support_ext_cdb(mega_host_config *);

===================================================================


This BitKeeper patch contains the following changesets:
1.808.33.1
## Wrapped with gzip_uu ##


begin 664 bkpatch29052
M'XL(`'U5P#T``]6644_;,!#'G^M/88G'J<G=V4Z<2)U@,&W25H&8>)Y<Q^"*
MIIF2P#;)'WYI4*$#2DNV/2S)DW7GW/WO][=\P"\:5^>CJ6G;KR=5V5C/#OC'
MJFGS4>$6B\A69;=P7E7=0NRKTL5ET8?%L^MX,5_>_!A3I,:ENS*UF1>L"SXS
MK?7\UM5-/L)(W*^T/[^Y?'3^_L/%YZ-SQB83?NS-\LI]<2V?3%A;U;=F432'
MIO6+:AFUM5DVI6O-JH9P'QH(@+I782I`)0$3D&FP6"`:B:X`DCJ1S%M_N&C:
MJ'"/4A$H`U)204`2BM@)QTB#CH2(D`/%"#%I3B*7D`..(<D!^(8^AVM=^!OB
M8V#O^-^M_)A9/G7UE>/K'^7;A>]BY\NVVB?T84;S9]MYJA-A(@!D()ET.NV;
MI3%!"6F?E;)/'*5(B4T'99\](,+&KWP8`P/L[8[I%/5\16K<V&8>KQ6*[,:L
M)$`6`$4J@X;LTLRL('N9B122YWMZ:<N>/B4R)8.2E.J!]?DG]1%*':3%3)-4
MVD@A+HE>4Y]_7!]H$+JWZ9:&=IOVC\1E0\2]PX>"2C*A>FN3^LW4(LN5?-'4
M\*],?733&;5<.7MEP8T#:D=/"J442H1$:"DZ0]V!,QV\PRD?U]_[KS/)V;;I
M#O#;=E;\4%;V!/TUK/B-XXTZ2@(HHCM6$/]35OSC2:-&I(Z5WL-[H+)E@[U0
=\4-065\*K'?VNKDI)V9&(DVS@OT"LBY:6I,(````
`
end

