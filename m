From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 17:20:21 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409291719170.1700-100000@ida.rowland.org>
References: <20040929210751.GC6179@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:39428 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269045AbUI2VUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 17:20:23 -0400
In-Reply-To: <20040929210751.GC6179@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 29 Sep 2004, Mike Anderson wrote:

> So now that this thread and the other thread related to similar
> shutdown issues has grown long is the next step to see if we can get the
> usb queuecommand to return DID_NO_CONNECT in this shutdown case.

Here's a patch.  Mohammed, please try it out and tell us how it works.  I 
just wrote it, so I haven't had a chance to test it myself yet.

Alan Stern


===== drivers/usb/storage/scsiglue.c 1.84 vs edited =====
--- 1.84/drivers/usb/storage/scsiglue.c	2004-09-13 08:11:34 -04:00
+++ edited/drivers/usb/storage/scsiglue.c	2004-09-29 16:08:47 -04:00
@@ -183,6 +183,14 @@
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	/* fail the command if we are disconnecting */
+	if (test_bit(US_FLIDX_DISCONNECTING, &us->flags)) {
+		US_DEBUGP("Command failed for disconnect\n");
+		srb->result = DID_NO_CONNECT << 16;
+		done(srb);
+		return 0;
+	}
+
 	srb->scsi_done = done;
 	us->srb = srb;
 

