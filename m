From: "John Treubig" <jtreubig@hotmail.com>
Subject: Re: Error handling in LibATA
Date: Fri, 13 Jan 2006 09:41:10 -0600
Message-ID: <BAY101-F341851C04E8543045525FDDF260@phx.gbl>
References: <43C73E72.6090400@tw.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43C73E72.6090400@tw.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: albertcc@tw.ibm.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk, dougg@torque.net, dwm@maxeymade.com
List-Id: linux-scsi@vger.kernel.org

Thanks Albert for the quick reply.  The patch you sent fixed the problem.  
To recap, from a base of 2.6.15, I have had to apply your patch (to permit 
errors to be seen by my application) plus a patch to ide-io.c (to prevent 
the kernel from hanging).  Hope these can be incorporated in future 
releases.

Best wishes,
John Treubig
VT Miltope


From: Albert Lee <albertcc@tw.ibm.com>
To: John Treubig <jtreubig@hotmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,        
linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk, dougg@torque.net,      
   dwm@maxeymade.com
Subject: Re: Error handling in LibATA
Date: Fri, 13 Jan 2006 13:45:22 +0800


 >
 > I began to try your patch and noticed that the code was different than
 > my copy of 2.6.15 rc5, so I downloaded 2.6.15 (release) and still see
 > that the base copy of libata-core.c is different.  A good indicator was
 > that ata_qc_complete() requires 2 parameters in the code from 2.6.15.
 > Can you tell me where I can find the copy your working off and if I have
 > to have any other files to support it?

Hi John,

Attached please find the patch for the 2.6.15 tree.
Also please turn on the ATA_DEBUG and ATA_VERBOSE_DEBUG in libata.h
for detailed log during the test, thanks.

Albert

=================

--- linux-2.6.15/drivers/scsi/libata-core.c	2006-01-03 11:21:10.000000000 
+0800
+++ errmask/drivers/scsi/libata-core.c	2006-01-13 13:27:12.000000000 +0800
@@ -3312,6 +3312,7 @@ static void ata_qc_timeout(struct ata_qu
  	struct ata_host_set *host_set = ap->host_set;
  	u8 host_stat = 0, drv_stat;
  	unsigned long flags;
+	unsigned int err_mask = 0;

  	DPRINTK("ENTER\n");

@@ -3346,8 +3347,15 @@ static void ata_qc_timeout(struct ata_qu
  		printk(KERN_ERR "ata%u: command 0x%x timeout, stat 0x%x host_stat 
0x%x\n",
  		       ap->id, qc->tf.command, drv_stat, host_stat);

+		/* If drv_stat looks ok (0x50 normally), we treat this
+		 * as lost interrupt and complete the qc as normal.
+		 * If drv_stat looks bad (0x00, 0xff, etc), err_mask is set.
+		 */
+		if (!ata_ok(drv_stat))
+			err_mask |= __ac_err_mask(drv_stat);
+
  		/* complete taskfile transaction */
-		ata_qc_complete(qc, ac_err_mask(drv_stat));
+		ata_qc_complete(qc, err_mask);
  		break;
  	}


