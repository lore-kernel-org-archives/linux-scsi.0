From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: rescan bug on 2.5.70 ?
Date: Fri, 30 May 2003 17:45:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030530174542.A13763@beaverton.ibm.com>
References: <3ED7C847.3090203@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:55737 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264088AbTEaAgS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 20:36:18 -0400
Content-Disposition: inline
In-Reply-To: <3ED7C847.3090203@mvista.com>; from sdake@mvista.com on Fri, May 30, 2003 at 02:08:23PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 30, 2003 at 02:08:23PM -0700, Steven Dake wrote:
> Folks,
> 
> I attempted
> echo "1" > rescan within a device in the scsi sysfs tree on 2.5.70.
> 
> The kernel repeatadly printed out the SDA device information.  The 
> system was still usable, but it appeared the rescan code was stuck in a 
> loop which dumped printks continuously.  Only way out was a reset.
> 
> Anyone else seen this behavior ?

Yes, I tried it out, and hit the same thing. The user program (not sure
what C code) is retrying the write, since we return 0. You can kill the
program, though I couldn't ^C/intr the echo, I killed it from another
terminal.

Trivial patch against current scsi-misc-2.5:

===== drivers/scsi/scsi_sysfs.c 1.21 vs edited =====
--- 1.21/drivers/scsi/scsi_sysfs.c	Mon May 26 08:45:44 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Sat May 31 00:04:45 2003
@@ -204,7 +204,7 @@
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
 {
 	scsi_rescan_device(dev);
-	return 0;
+	return count;
 }
 
 static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_rescan_field)

-- Patrick Mansfield
