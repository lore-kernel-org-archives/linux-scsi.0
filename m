From: Douglas Gilbert <dougg@torque.net>
Subject: Re: scsi_debug issues
Date: Sat, 16 Oct 2004 16:51:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4170C505.3000805@torque.net>
References: <20041015190154.GA3073@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070800040303080208020404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub1.uq.edu.au ([130.102.148.128]:26129 "EHLO
	mailhub1.uq.edu.au") by vger.kernel.org with ESMTP id S268670AbUJPGwr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 02:52:47 -0400
In-Reply-To: <20041015190154.GA3073@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800040303080208020404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Nishanth Aravamudan wrote:
> Hi,
> 
> At the recommendation of Pat Mansfield, I'm posting this issue to
> linux-scsi. I have run into a big problem with the scsi_debug driver
> which is causing my machine to hang.
> 
> I was finally able to get a large number (10000) of scsi_debug disks via
> modprobe (no partitioning, no mounting, no fs), so I decided to go ahead
> and try to continue the experiment. I found that I was not able to ls in
> a mounted directory from one of the scsi_debug disks. In the chance that
> it was somehow due to the high number of disks present, I tried just
> 
>   modprobe scsi_debug
> 
> so that I would only get one disk. I then ran these commands [0]. I did
> not set the SCSI logging on until the last moment, after I synced the
> existent SCSI disks in the machine (there are two actual SCSI disks)
> [1]. I found that the ls command never fails to hang (although sometimes
> it will not hang immediately, I have to
> 
>   cd lost+found
> 
> first. Interestingly, if the machine does not have highmem (i.e. less
> than 896 MB of RAM) or the kernel is booted with mem=800 (or some other
> number less than 896), the problem dissappears. I had to put the check
> in my patch in for the NULL dereference, as it would cause a
> segmentation fault otherwise. I'm guessing that is where the problem may
> be, as the NULL-check was not there before (an assumption that it
> (scatg2virt) would always work?).

Nishanth,
So this problem seems related to highmem.

The attachment is against the current scsi_debug driver
(at least in lk 2.6.9-rc4). It uses dma_map_sg() and friends
together with phys_to_virt() which comes highly recommended:
"in almost all conceivable cases a device driver should not be
using this function" :-) Could you try the patch.

Perhaps others my be able to answer this: is setting
scsi_host_template::dma_boundary (to some figure other
than 0xffffffff) going to help in this case?

Doug Gilbert


--------------070800040303080208020404
Content-Type: text/x-patch;
 name="sdebug2681dma1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug2681dma1.diff"

--- linux/drivers/scsi/scsi_debug.c	2004-08-14 21:12:43.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c2681dma1	2004-10-16 16:22:34.330229976 +1000
@@ -262,16 +262,6 @@
 static struct device pseudo_primary;
 static struct bus_type pseudo_lld_bus;
 
-static unsigned char * scatg2virt(const struct scatterlist * sclp)
-{
-	if (NULL == sclp)
-		return NULL;
-	else if (sclp->page)
-		return (unsigned char *)page_address(sclp->page) +
-		       sclp->offset;
-	else
-		return NULL;
-}
 
 static
 int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
@@ -286,6 +276,7 @@
 	struct sdebug_dev_info * devip = NULL;
 	unsigned char * sbuff;
 	int inj_recovered = 0;
+        int num_elems = 0;
 
 	if (done == NULL)
 		return 0;	/* assume mid level reprocessing command */
@@ -294,8 +285,12 @@
 		struct scatterlist *sgpnt = (struct scatterlist *)
 						SCpnt->request_buffer;
 
-		buff = scatg2virt(&sgpnt[0]);
-		bufflen = sgpnt[0].length;
+		num_elems = dma_map_sg(NULL, sgpnt, SCpnt->use_sg,
+				       SCpnt->sc_data_direction);
+		buff = phys_to_virt(sg_dma_address(&sgpnt[0]));
+		bufflen = sg_dma_len(&sgpnt[0]);
+		dma_unmap_sg(NULL, sgpnt, SCpnt->use_sg,
+			     SCpnt->sc_data_direction);
 		/* READ and WRITE process scatterlist themselves */
 	}
 	else
@@ -778,6 +773,7 @@
         struct scatterlist *sgpnt = NULL;
         int bufflen = SCpnt->request_bufflen;
 	unsigned long iflags;
+        int num_elems = 0;
 
 	if (upper_blk || (block + num > sdebug_capacity)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE,
@@ -799,9 +795,11 @@
 	       block, bufflen); */
 	if (SCpnt->use_sg) {
 		sgcount = 0;
-		sgpnt = (struct scatterlist *) buff;
-		buff = scatg2virt(&sgpnt[sgcount]);
-		bufflen = sgpnt[sgcount].length;
+		sgpnt = (struct scatterlist *)buff;
+		num_elems = dma_map_sg(NULL, sgpnt, SCpnt->use_sg,
+				       SCpnt->sc_data_direction);
+		buff = phys_to_virt(sg_dma_address(&sgpnt[0]));
+		bufflen = sg_dma_len(&sgpnt[0]);
 	}
 	do {
 		memcpy(buff, fake_storep + (block * SECT_SIZE), bufflen);
@@ -809,14 +807,18 @@
 		if (SCpnt->use_sg) {
 			block += bufflen >> POW2_SECT_SIZE;
 			sgcount++;
-			if (nbytes) {
-				buff = scatg2virt(&sgpnt[sgcount]);
-				bufflen = sgpnt[sgcount].length;
+			if (nbytes > 0) {
+				buff = phys_to_virt(
+					sg_dma_address(&sgpnt[sgcount]));
+				bufflen = sg_dma_len(&sgpnt[sgcount]);
 			}
 		} else if (nbytes > 0)
 			printk(KERN_WARNING "scsi_debug:resp_read: unexpected "
 			       "nbytes=%d\n", nbytes);
-	} while (nbytes);
+	} while (nbytes > 0);
+	if (SCpnt->use_sg)
+		dma_unmap_sg(NULL, sgpnt, SCpnt->use_sg,
+			     SCpnt->sc_data_direction);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	return 0;
 }
@@ -829,6 +831,7 @@
         struct scatterlist *sgpnt = NULL;
         int bufflen = SCpnt->request_bufflen;
 	unsigned long iflags;
+        int num_elems = 0;
 
 	if (upper_blk || (block + num > sdebug_capacity)) {
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE,
@@ -842,8 +845,10 @@
 	if (SCpnt->use_sg) {
 		sgcount = 0;
 		sgpnt = (struct scatterlist *) buff;
-		buff = scatg2virt(&sgpnt[sgcount]);
-		bufflen = sgpnt[sgcount].length;
+		num_elems = dma_map_sg(NULL, sgpnt, SCpnt->use_sg,
+				       SCpnt->sc_data_direction);
+		buff = phys_to_virt(sg_dma_address(&sgpnt[0]));
+		bufflen = sg_dma_len(&sgpnt[0]);
 	}
 	do {
 		memcpy(fake_storep + (block * SECT_SIZE), buff, bufflen);
@@ -852,14 +857,18 @@
 		if (SCpnt->use_sg) {
 			block += bufflen >> POW2_SECT_SIZE;
 			sgcount++;
-			if (nbytes) {
-				buff = scatg2virt(&sgpnt[sgcount]);
-				bufflen = sgpnt[sgcount].length;
+			if (nbytes > 0) {
+				buff = phys_to_virt(
+					sg_dma_address(&sgpnt[sgcount]));
+				bufflen = sg_dma_len(&sgpnt[sgcount]);
 			}
 		} else if (nbytes > 0)
 			printk(KERN_WARNING "scsi_debug:resp_write: "
 			       "unexpected nbytes=%d\n", nbytes);
-	} while (nbytes);
+	} while (nbytes > 0);
+	if (SCpnt->use_sg)
+		dma_unmap_sg(NULL, sgpnt, SCpnt->use_sg,
+			     SCpnt->sc_data_direction);
 	write_unlock_irqrestore(&atomic_rw, iflags);
 	return 0;
 }

--------------070800040303080208020404--
