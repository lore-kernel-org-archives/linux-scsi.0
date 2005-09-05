From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
 2.6.12.2)
Date: Mon, 5 Sep 2005 23:50:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0509052241020.11890@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <42E03506.7030707@drzeus.cx>
 <20050721235348.05eace11.rdunlap@xenotime.net> <20050722135055.6cb4597d.rdunlap@xenotime.net>
 <42E17451.6090706@drzeus.cx> <20050722153651.28d5db51.rdunlap@xenotime.net>
 <42E17772.3020903@drzeus.cx> <20050723100945.7d43d063.rdunlap@xenotime.net>
 <42E2933C.4050808@drzeus.cx> <20050723152714.4212ba52.rdunlap@xenotime.net>
 <42E2ECF1.8070501@drzeus.cx> <20050723184014.49629f9e.rdunlap@xenotime.net>
 <42E39462.3040007@drzeus.cx> <20050724100153.3e891484.rdunlap@xenotime.net>
 <42E565FE.4070708@drzeus.cx> <20050725203133.3cfa650d.rdunlap@xenotime.net>
 <42E6A5C3.6070501@drzeus.cx> <20050726202058.133382c1.rdunlap@xenotime.net>
 <42E964CC.5060600@drzeus.cx> <20050728201339.216ab3b8.rdunlap@xenotime.net>
 <42F37893.30006@drzeus.cx> <Pine.LNX.4.60.0508070003520.10832@poirot.grange>
 <42F5FCBF.7080902@drze
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:38298 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964844AbVIEWE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2005 18:04:28 -0400
In-Reply-To: <Pine.LNX.4.60.0508072214240.7539@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>

Hi all

I've been buggering the list with this ridiculous problem for quite some 
time now:-) I understand, it is too risky to apply an untested patch to 
mainline, but could we either

1) get it into -mm

or

2) try to find some beta-testers by applying something like the below:

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Index: linux-2_6/drivers/scsi/dc395x.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/dc395x.c,v
retrieving revision 1.1.1.8
diff -u -p -r1.1.1.8 dc395x.c
--- linux-2_6/drivers/scsi/dc395x.c	2 Sep 2005 19:16:29 -0000	1.1.1.8
+++ linux-2_6/drivers/scsi/dc395x.c	5 Sep 2005 20:38:23 -0000
@@ -976,6 +976,17 @@ static void send_srb(struct AdapterCtlBl
 	}
 }
 
+static inline void *__page_address(struct page *page)
+{
+	static int feedback_requested;
+
+	if (!feedback_requested) {
+		feedback_requested = 1;
+		printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
+		       "to help improve support for your system.\n", __FILE__);
+	}
+	return page_address(page);
+}
 
 /* Prepare SRB for being sent to Device DCB w/ command *cmd */
 static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
@@ -1021,7 +1032,7 @@ static void build_srb(struct scsi_cmnd *
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
+		srb->virt_addr = __page_address(sl->page);
 		for (i = 0; i < srb->sg_count; i++) {
 			u32 busaddr = (u32)sg_dma_address(&sl[i]);
 			u32 seglen = (u32)sl[i].length;
@@ -2018,7 +2029,7 @@ static void sg_update_list(struct ScsiRe
 		unsigned long mask =
 		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
 		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
-			srb->virt_addr = (page_address(sg->page)
+			srb->virt_addr = (__page_address(sg->page)
 					   + psge->address -
 					   (psge->address & PAGE_MASK));
 			return;
@@ -3322,7 +3333,7 @@ static void srb_done(struct AdapterCtlBl
 
 	if (cmd->use_sg) {
 		struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
-		ptr = (struct ScsiInqData *)(page_address(sg->page) + sg->offset);
+		ptr = (struct ScsiInqData *)(__page_address(sg->page) + sg->offset);
 	} else {
 		ptr = (struct ScsiInqData *)(cmd->request_buffer);
 	}
Index: linux-2_6/drivers/scsi/tmscsim.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/tmscsim.c,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 tmscsim.c
--- linux-2_6/drivers/scsi/tmscsim.c	2 Sep 2005 19:16:29 -0000	1.1.1.9
+++ linux-2_6/drivers/scsi/tmscsim.c	5 Sep 2005 20:38:31 -0000
@@ -989,6 +989,14 @@ din_1:
 	    if( residual )
 	    {
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
+		static int feedback_requested;
+
+		if (!feedback_requested) {
+			feedback_requested = 1;
+			printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
+			       "to help improve support for your system.\n", __FILE__);
+		}
+
 		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
 		*ptr = bval;
 		pSRB->SGBusAddr++; xferCnt++;
