From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: Re-merge cleanups
Date: Fri, 11 Mar 2005 14:15:44 +0000
Message-ID: <1110550543.17740.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from clock-tower.bc.nu ([81.2.110.250]:64919 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S263315AbVCKORc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 09:17:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org, linux-scsi@vger.kernel.org

This restores the Adrian Bunk and Al Viro cleanups that got trashed in
the driver update. It also fixes a few formatting glitches and adds
cpu_relax() calls to the polls spinning on the controller/bus.

Signed-off-by: Alan Cox <alan@redhat.com>

Alan

--- drivers/scsi/atp870u.c.old	2005-03-11 13:45:28.146766480 +0000
+++ drivers/scsi/atp870u.c	2005-03-11 14:12:28.346458688 +0000
@@ -39,9 +39,9 @@
 #include "atp870u.h"
 
 static struct scsi_host_template atp870u_template;
-void send_s870(struct atp_unit *dev,unsigned char c);
-void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c);
-void tscam_885(void);
+static void send_s870(struct atp_unit *dev,unsigned char c);
+static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c);
+static void tscam_885(void);
 
 static irqreturn_t atp870u_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
 {
@@ -364,7 +364,7 @@
 			}
 			outb(j, tmport);
 			while ((inb(tmport) & 0x01) != j) {
-			   outb(j,tmport);
+				outb(j,tmport);
 			}
 			if (dev->id[c][target_id].last_len == 0) {
 				tmport = workport + 0x18;
@@ -491,7 +491,7 @@
 			/*
 			 *	Clear it off the queue
 			 */
-			dev->id[c][target_id].curr_req = 0;
+			dev->id[c][target_id].curr_req = NULL;
 			dev->working[c]--;
 			spin_unlock_irqrestore(dev->host->host_lock, flags);
 			/*
@@ -614,7 +614,8 @@
  *
  *	Queue a command to the ATP queue. Called with the host lock held.
  */
-int atp870u_queuecommand(struct scsi_cmnd * req_p, void (*done) (struct scsi_cmnd *))
+static int atp870u_queuecommand(struct scsi_cmnd * req_p, 
+			 void (*done) (struct scsi_cmnd *))
 {
 	unsigned char c;
 	unsigned int tmport,m;	
@@ -711,7 +712,7 @@
  *
  *	Caller holds the host lock.
  */
-void send_s870(struct atp_unit *dev,unsigned char c)
+static void send_s870(struct atp_unit *dev,unsigned char c)
 {
 	unsigned int tmport;
 	struct scsi_cmnd *workreq;
@@ -821,9 +822,9 @@
 	}
 	outb(j, tmport);
 	while ((inb(tmport) & 0x01) != j) {
-	   outb(j,tmport);
+		outb(j,tmport);
 #ifdef ED_DBGP
-	   printk("send_s870 while loop 1\n");
+		printk("send_s870 while loop 1\n");
 #endif
 	}
 	/*
@@ -946,18 +947,18 @@
 #ifdef ED_DBGP		
 		printk("1. bttl %x, l %x\n",bttl, l);
 #endif			
-			while (l > 0x10000) {
-					(((u16 *) (prd))[i + 3]) = 0x0000;
-					(((u16 *) (prd))[i + 2]) = 0x0000;
-					(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
-					l -= 0x10000;
-					bttl += 0x10000;
-					i += 0x04;
-				}
+		while (l > 0x10000) {
+				(((u16 *) (prd))[i + 3]) = 0x0000;
+				(((u16 *) (prd))[i + 2]) = 0x0000;
 				(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
-				(((u16 *) (prd))[i + 2]) = cpu_to_le16(l);
-				(((u16 *) (prd))[i + 3]) = 0;
-				i += 0x04;			
+				l -= 0x10000;
+				bttl += 0x10000;
+				i += 0x04;
+			}
+			(((u32 *) (prd))[i >> 1]) = cpu_to_le32(bttl);
+			(((u16 *) (prd))[i + 2]) = cpu_to_le16(l);
+			(((u16 *) (prd))[i + 3]) = 0;
+			i += 0x04;			
 		}
 		(((u16 *) (prd))[i - 1]) = cpu_to_le16(0x8000);	
 #ifdef ED_DBGP		
@@ -1178,7 +1179,8 @@
 		outb(0x09, tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		k = inb(tmport);
 		if (k != 0x16) {
@@ -1249,7 +1251,8 @@
 		tmport += 0x03;
 		outb(0x09, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0);
+		while ((inb(tmport) & 0x80) == 0)
+			cpu_relax();
 		tmport -= 0x08;
 		inb(tmport);
 		return;
@@ -1345,7 +1348,7 @@
 
 }
 
-void is870(struct atp_unit *dev, unsigned int wkport)
+static void is870(struct atp_unit *dev, unsigned int wkport)
 {
 	unsigned int tmport;
 	unsigned char i, j, k, rmb, n;
@@ -1405,12 +1408,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+
 		dev->active_id[0] |= m;
 
 		tmport = wkport + 0x10;
@@ -1422,7 +1429,8 @@
 		tmport = wkport + 0x18;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -1448,16 +1456,21 @@
 		tmport += 0x03;
 		outb(inqd[8], tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 		tmport = wkport + 0x1b;
-		if (dev->chip_ver == 4) {
+		if (dev->chip_ver == 4)
 			outb(0x00, tmport);
-		}
+
 		tmport = wkport + 0x18;
 		outb(0x08, tmport);
 		tmport += 0x07;
@@ -1487,7 +1500,10 @@
 		tmport += 0x03;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
 		if (inb(tmport) != 0x16) {
 			goto sel_ok;
@@ -1527,12 +1543,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 try_wide:
 		j = 0;
 		tmport = wkport + 0x14;
@@ -1549,7 +1569,10 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -1622,7 +1645,10 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -1676,12 +1702,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 try_sync:
 		j = 0;
 		tmport = wkport + 0x14;
@@ -1706,7 +1736,10 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
@@ -1764,7 +1797,10 @@
 			goto phase_ins1;
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		j = inb(tmport);
 		if (j == 0x85) {
 			goto tar_dcons;
@@ -1789,7 +1825,10 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -1889,12 +1928,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 		dev->active_id[0] |= m;
 
 		tmport = wkport + 0x50;
@@ -1906,7 +1949,10 @@
 		tmport = wkport + 0x58;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -1932,12 +1978,17 @@
 		tmport += 0x03;
 		outb(inqd[8], tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 		tmport = wkport + 0x5b;
 		outb(0x00, tmport);
 		tmport = wkport + 0x58;
@@ -1969,11 +2020,13 @@
 		tmport += 0x03;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if (inb(tmport) != 0x16) {
+		if (inb(tmport) != 0x16)
 			goto sel_ok;
-		}
+
 inq_ok:
 		mbuf[36] = 0;
 		printk(KERN_INFO "         ID: %2d  %s\n", i, &mbuf[8]);
@@ -2014,12 +2067,17 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+
 try_u3:
 		j = 0;
 		tmport = wkport + 0x54;
@@ -2036,7 +2094,10 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
@@ -2109,7 +2170,10 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -2155,12 +2219,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
 			continue;
-		}
-		while (inb(tmport) != 0x8e);
+
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+			
 try_wide:
 		j = 0;
 		tmport = wkport + 0x54;
@@ -2177,7 +2245,9 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+			
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -2250,7 +2320,10 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -2317,12 +2390,16 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
+
 try_sync:
 		j = 0;
 		tmport = wkport + 0x54;
@@ -2351,7 +2428,10 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
@@ -2409,7 +2489,10 @@
 			goto phase_ins1;
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		j = inb(tmport);
 		if (j == 0x85) {
 			goto tar_dcons;
@@ -2434,7 +2517,10 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
+
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -2826,7 +2912,10 @@
 		tmport += 0x18;
 		outb(0, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0);
+
+		while ((inb(tmport) & 0x80) == 0)
+			cpu_relax();
+	
 		tmport -= 0x08;
 		inb(tmport);
 		tmport = base_io + 0x81;
@@ -2844,7 +2933,10 @@
 		tmport += 0x18;
 		outb(0, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0);
+
+		while ((inb(tmport) & 0x80) == 0)
+			cpu_relax();
+
 		tmport -= 0x08;
 		inb(tmport);
 		tmport = base_io + 0xc1;
@@ -3009,7 +3101,7 @@
    it is available to be used again.  Until this gets worked out, we will
    leave it commented out.  */
 
-int atp870u_abort(struct scsi_cmnd * SCpnt)
+static int atp870u_abort(struct scsi_cmnd * SCpnt)
 {
 	unsigned char  j, k, c;
 	struct scsi_cmnd *workrequ;
@@ -3048,7 +3140,7 @@
 	return SUCCESS;
 }
 
-const char *atp870u_info(struct Scsi_Host *notused)
+static const char *atp870u_info(struct Scsi_Host *notused)
 {
 	static char buffer[128];
 
@@ -3057,13 +3149,9 @@
 	return buffer;
 }
 
-int atp870u_set_info(char *buffer, int length, struct Scsi_Host *HBAptr)
-{
-	return -ENOSYS; 	/* Currently this is a no-op */
-}
-
 #define BLS buffer + len + size
-int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer, char **start, off_t offset, int length, int inout)
+int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer, 
+		      char **start, off_t offset, int length, int inout)
 {
 	static u8 buff[512];
 	int size = 0;
@@ -3072,10 +3160,9 @@
 	off_t pos = 0;
 	
 	if (inout) 	
-		return -ENOSYS;
-	if (offset == 0) {
+		return -EINVAL;
+	if (offset == 0)
 		memset(buff, 0, sizeof(buff));
-	}
 	size += sprintf(BLS, "ACARD AEC-671X Driver Version: 2.6+ac\n");
 	len += size;
 	pos = begin + len;
@@ -3192,7 +3279,7 @@
 	pci_unregister_driver(&atp870u_driver);
 }
 
-void tscam_885(void)
+static void tscam_885(void)
 {
 	unsigned char i;
 
@@ -3204,7 +3291,7 @@
 
 
 
-void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
+static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
 {
 	unsigned int tmport;
 	unsigned char i, j, k, rmb, n, lvdmode;
@@ -3259,12 +3346,14 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
 		dev->active_id[c] |= m;
 
 		tmport = wkport + 0x10;
@@ -3276,7 +3365,8 @@
 		tmport = wkport + 0x18;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -3302,12 +3392,14 @@
 		tmport += 0x03;
 		outb(inqd[8], tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
 		tmport = wkport + 0x1b;
 		outb(0x00, tmport);
 		tmport = wkport + 0x18;
@@ -3339,7 +3431,8 @@
 		tmport += 0x03;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if (inb(tmport) != 0x16) {
 			goto sel_ok;
@@ -3383,12 +3476,14 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
 try_u3:
 		j = 0;
 		tmport = wkport + 0x14;
@@ -3403,9 +3498,11 @@
 				outb(u3[j++], tmport);
 				tmport += 0x06;
 			}
+			cpu_relax();
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
@@ -3427,6 +3524,7 @@
 				outb(0, tmport);
 				tmport += 0x06;
 			}
+			cpu_relax();
 		}
 		tmport -= 0x08;
 		j = inb(tmport) & 0x0f;
@@ -3497,14 +3595,14 @@
 			goto chg_wide;
 		}
 		if (mbuf[3] == 0x09) {
-		   m = 1;
-		   m = m << i;
-		   dev->wide_id[c] |= m;
-		   dev->id[c][i].devsp = 0xce;
+			m = 1;
+			m = m << i;
+			dev->wide_id[c] |= m;
+			dev->id[c][i].devsp = 0xce;
 #ifdef ED_DBGP		   
-		   printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
+			printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
 #endif
-		   continue;
+			continue;
 		}
 chg_wide:
 		tmport = wkport + 0x1b;
@@ -3527,12 +3625,14 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
 try_wide:
 		j = 0;
 		tmport = wkport + 0x14;
@@ -3547,9 +3647,11 @@
 				outb(wide[j++], tmport);
 				tmport += 0x06;
 			}
+			cpu_relax();
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -3571,6 +3673,7 @@
 				outb(0, tmport);
 				tmport += 0x06;
 			}
+			cpu_relax();
 		}
 		tmport -= 0x08;
 		j = inb(tmport) & 0x0f;
@@ -3622,7 +3725,8 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {
@@ -3690,12 +3794,14 @@
 		outb(satn[8], tmport);
 		tmport += 0x07;
 
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e);
+		while (inb(tmport) != 0x8e)
+			cpu_relax();
 try_sync:
 		j = 0;
 		tmport = wkport + 0x14;
@@ -3724,7 +3830,8 @@
 			}
 		}
 		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		j = inb(tmport) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
@@ -3746,6 +3853,7 @@
 				outb(0x00, tmport);
 				tmport += 0x06;
 			}
+			cpu_relax();
 		}
 		tmport -= 0x08;
 		j = inb(tmport);
@@ -3807,7 +3915,8 @@
 		tmport += 0x04;
 		outb(0x08, tmport);
 		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
+		while ((inb(tmport) & 0x80) == 0x00)
+			cpu_relax();
 		tmport -= 0x08;
 		j = inb(tmport);
 		if (j != 0x16) {

