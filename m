From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: 2.5.74: aha1740.c doesn't compile
Date: Thu, 03 Jul 2003 17:16:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <wrpfzlniqsc.fsf@hina.wild-wind.fr.eu.org>
References: <Pine.LNX.4.44.0307021433520.2323-100000@home.osdl.org>
	<20030703101846.GH282@fs.tum.de>
	<wrpy8zfizqd.fsf@hina.wild-wind.fr.eu.org>
	<20030703142705.GL282@fs.tum.de>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030703142705.GL282@fs.tum.de> (Adrian Bunk's message of
 "Thu, 3 Jul 2003 16:27:06 +0200")
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Adrian" == Adrian Bunk <bunk@fs.tum.de> writes:

Adrian> On Thu, Jul 03, 2003 at 02:03:38PM +0200, Marc Zyngier wrote:
>> >>>>> "Adrian" == Adrian Bunk <bunk@fs.tum.de> writes:
>> 
Adrian> drivers/scsi/aha1740.c fails to build on 2.5.74 withthe
Adrian> following error:
>> 
>> Weird error.
>> 
>> Compiles just fine here... Please send your .config.

Adrian> It's attached.

Ok, paper bag, please. I should _really_ use DEBUG_SPINLOCK...

James, please apply.

       M.

--- linux-2.5/drivers/scsi/aha1740.c	2003-07-01 18:51:30.000000000 +0200
+++ linux-2.5.74/drivers/scsi/aha1740.c	2003-07-03 17:12:31.000000000 +0200
@@ -375,7 +375,7 @@
 #endif
 
 	/* locate an available ecb */
-	spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	ecbno = host->last_ecb_used + 1; /* An optimization */
 	if (ecbno >= AHA1740_ECBS)
 		ecbno = 0;
@@ -394,7 +394,7 @@
 						    doubles as reserved flag */
 
 	host->last_ecb_used = ecbno;    
-	spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 
 #ifdef DEBUG
 	printk("Sending command (%d %x)...", ecbno, done);
@@ -491,7 +491,7 @@
 		unsigned int base = SCpnt->device->host->io_port;
 		DEB(printk("aha1740[%d] critical section\n",ecbno));
 
-		spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
+		spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 		for (loopcnt = 0; ; loopcnt++) {
 			if (inb(G2STAT(base)) & G2STAT_MBXOUT) break;
 			if (loopcnt == LOOPCNT_WARN) {
@@ -511,7 +511,7 @@
 				panic("aha1740.c: attn wait failed!\n");
 		}
 		outb(ATTN_START | (target & 7), ATTN(base)); /* Start it up */
-		spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 		DEB(printk("aha1740[%d] request queued.\n",ecbno));
 	} else
 		printk(KERN_ALERT "aha1740_queuecommand: done can't be NULL\n");

-- 
Places change, faces change. Life is so very strange.
