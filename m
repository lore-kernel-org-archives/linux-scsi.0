From: Douglas Gilbert <dougg@torque.net>
Subject: Re: constants.c fix for 2.5.22 compile error
Date: Mon, 17 Jun 2002 09:29:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0DE42C.E2F8C328@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Jason Straight <jason@blazeconnect.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jason Straight wrote:
> line 997 in /drivers/scsi/constants.c tries to use 
> i without declaring it.
> add i to the int declaration in 910 seems to fix.

This occurs when CONFIG_SCSI_CONSTANTS is not set in
the .config file.

BTW Defining CONFIG_SCSI_CONSTANTS adds about 30KB to
the size of the kernel (not 12 KB as indicated during
configuration).

Doug Gilbert

--- linux/drivers/scsi/constants.c	Mon Jun 17 08:44:48 2002
+++ linux/drivers/scsi/constants.c2522fix	Mon Jun 17 09:20:48 2002
@@ -993,10 +993,14 @@
 	}
     
 #if !(CONSTANTS & CONST_SENSE)
-	printk("Raw sense data:");
-	for (i = 0; i < s; ++i) 
-		printk("0x%02x ", sense_buffer[i]);
-	printk("\n");
+	{
+		int i;
+
+		printk("Raw sense data:");
+		for (i = 0; i < s; ++i) 
+			printk("0x%02x ", sense_buffer[i]);
+		printk("\n");
+	}
 #endif
 }
 

