From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: What is SCSI command 0xa0 ?
Date: Wed, 16 Feb 2005 11:42:18 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502161133350.6418-100000@ida.rowland.org>
References: <20050214230645.22eb3b3c@hebus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:10500 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262072AbVBPQmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 11:42:22 -0500
In-Reply-To: <20050214230645.22eb3b3c@hebus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 14 Feb 2005, Samuel Colin wrote:

> OK, I just made the following tests :
> - Plugged the disk and booted the openbrick
> - Did the echo above
> - Modprobed ehci-hcd and usb-storage
> - Mounted the disk
> - Made the copy of an iso image from /home (who is nfs mounted) to
> /mnt/lacie1...
> 
> Absolutely no error, no odd display on the command line. Thus I guess we can
> say the problem is solved so far.

Good.  The patch below ought to accomplish the same thing as that "echo" 
command.  You can try patching your kernel and make sure that it really 
works.  If it does, I'll submit the patch for official inclusion in the 
kernel.

> What puzzles me is that a 2.6.8 kernel didn't exhibit this behaviour for the
> same disk on another machine (and thus another usb2 chipset, but as that
> wasn't the cause of the problem...)

I don't know why.  Do you want to turn on usb-storage verbose debugging in
the 2.6.8 kernel, and run it on that other machine?

> In conclusion, I think that the patches from usb-devel I had applied solved
> usb2 problems that had really happened (but now are solved), but some code
> change introduced scsi errors (hence the working 2.6.8 kernel I tell about
> above)... I don't really know, after all you're the experts.

It's hard to say, since there are so many things being changed all the
time.  But if the REPORT_LUNS command worked under 2.6.8 and failed under
2.6.11, it would be worthwhile to know why.

Alan Stern


===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
+++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
@@ -201,6 +201,7 @@
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
+	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},

