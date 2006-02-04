From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8]  fusion - mtctl -  change to wait_event_timeout
Date: Sat, 4 Feb 2006 11:03:02 +0000
Message-ID: <20060204110301.GB27621@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F243697@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7905 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1946155AbWBDLDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 06:03:03 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F243697@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2006 at 05:19:37PM -0700, Moore, Eric wrote:
> Change from using wait_event_interruptible_timeout to
> wait_event_timeout.  Also delete white space and duplicate
> line of code.

ok.  long-term this should switch to wait_for_completion_timeout, replacing
the waitqueue and wait_done variable with just a struct completion.


diff -uarN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-02-02 14:59:03.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2006-02-02 15:44:44.000000000 -0700
@@ -385,18 +385,18 @@
 	}
 
 	/* Now wait for the command to complete */
-	ii = wait_event_interruptible_timeout(mptctl_wait,
+	ii = wait_event_timeout(mptctl_wait,
 	     ioctl->wait_done == 1,
 	     HZ*5 /* 5 second timeout */);
 
 	if(ii <=0 && (ioctl->wait_done != 1 ))  {
+		mpt_free_msg_frame(hd->ioc, mf);
 		ioctl->wait_done = 0;
 		retval = -1; /* return failure */
 	}
 
 mptctl_bus_reset_done:
 
-	mpt_free_msg_frame(hd->ioc, mf);
 	mptctl_free_tm_flags(ioctl->ioc);
 	return retval;
 }
@@ -807,7 +807,7 @@
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
 
 	/* Now wait for the command to complete */
-	ret = wait_event_interruptible_timeout(mptctl_wait,
+	ret = wait_event_timeout(mptctl_wait,
 	     iocp->ioctl->wait_done == 1,
 	     HZ*60);
 
@@ -1172,12 +1172,11 @@
 		karg->pciInfo.u.bits.deviceNumber = PCI_SLOT( pdev->devfn );
 		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
 	} else if (cim_rev == 2) {
-		/* Get the PCI bus, device, function and segment ID numbers 
+		/* Get the PCI bus, device, function and segment ID numbers
 		   for the IOC */
 		karg->pciInfo.u.bits.busNumber = pdev->bus->number;
 		karg->pciInfo.u.bits.deviceNumber = PCI_SLOT( pdev->devfn );
 		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
-		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
 		karg->pciInfo.segmentID = pci_domain_nr(pdev->bus);
 	}
 
@@ -2153,7 +2152,7 @@
 
 	/* Now wait for the command to complete */
 	timeout = (karg.timeout > 0) ? karg.timeout : MPT_IOCTL_DEFAULT_TIMEOUT;
-	timeout = wait_event_interruptible_timeout(mptctl_wait,
+	timeout = wait_event_timeout(mptctl_wait,
 	     ioc->ioctl->wait_done == 1,
 	     HZ*timeout);
 
