From: "frage schnell" <frage.schnell1@gmx.de>
Subject: Re: sym53c8xx_2 make scsitap slow
Date: Thu, 20 Jan 2005 18:20:06 +0100 (MET)
Message-ID: <16298.1106241606@www31.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:4824 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262234AbVATRUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 12:20:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I thik i have fond the bug into the driver (see diff file bellow) 
 
 
 
--- linux-2.6.10/drivers/scsi/sym53c8xx_2/sym_hipd.c    2004-12-24 
22:33:48.000000000 +0100 
+++ linux-2.6.10.p/drivers/scsi/sym53c8xx_2/sym_hipd.c  2005-01-20 
17:31:19.364112800 +0100 
@@ -1538,7 +1538,7 @@ 
        /* 
         *  negotiate using PPR ? 
         */ 
-       if (scsi_device_dt(sdev)) { 
+        if (tp->tinfo.goal.options & PPR_OPT_MASK) { 
                nego = NS_PPR; 
        } else { 
                /* 
 
 
now the tape will be scand correct and the speed is ok 
 
Jan 20 18:16:34 server5 kernel: ACPI: PCI interrupt 0000:02:0c.0[A] -> GSI 
20 (level, low) -> IRQ 20 
Jan 20 18:16:34 server5 kernel: sym0: <895> rev 0x1 at pci 0000:02:0c.0 
irq 20 
Jan 20 18:16:34 server5 kernel: sym0: Tekram NVRAM, ID 15, Fast-40, LVD, 
paritychecking 
Jan 20 18:16:34 server5 kernel: sym0: SCSI BUS has been reset. 
Jan 20 18:16:34 server5 kernel: scsi7 : sym-2.1.18m 
Jan 20 18:16:38 server5 kernel:   Vendor: HP        Model: Ultrium 1-SCSI   

Rev: N27D 
Jan 20 18:16:38 server5 kernel:   Type:   Sequential-Access                 

ANSI SCSI revision: 03 
Jan 20 18:16:38 server5 kernel:  target7:0:5: Beginning Domain Validation 
Jan 20 18:16:39 server5 kernel: sym0:5: wide asynchronous. 
Jan 20 18:16:39 server5 kernel: sym0:5: FAST-40 WIDE SCSI 80.0 MB/s ST 
(25.0 ns, offset 15) 
Jan 20 18:16:39 server5 kernel:  target7:0:5: Ending Domain Validation 
Jan 20 18:16:40 server5 kernel: Attached scsi tape st0 at scsi7, channel 
0, id 5, lun 0 
Jan 20 18:16:40 server5 kernel: st0: try direct i/o: yes (alignment 512 
B), maxpage reachable by HBA 1048575 
Jan 20 18:16:40 server5 kernel: Attached scsi generic sg2 at scsi7, 
channel 0, id 5, lun 0,  type 1 
 
 

-- 
GMX im TV ... Die Gedanken sind frei ... Schon gesehen?
Jetzt Spot online ansehen: http://www.gmx.net/de/go/tv-spot
