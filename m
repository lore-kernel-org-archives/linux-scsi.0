From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: host_lock use in LLD
Date: 20 Jun 2004 08:49:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087739384.10858.9.camel@mulgrave>
References: <Pine.LNX.4.60.0406182225260.10481@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51853 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263975AbUFTNtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 09:49:47 -0400
In-Reply-To: <Pine.LNX.4.60.0406182225260.10481@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Fri, 2004-06-18 at 16:28, Guennadi Liakhovetski wrote:
> While reviewing tmscsim, I noticed something, I didn't quite like / 
> understand. The driver takes the host_lock (with irqsave) at the entry to 
> the ISR, and releases it at the exit. And inside the ISR there are 
> potentially long busy-waits... Like
> 
>  	int ctr = 6000000; /* only try for about a second */
>  	while( --ctr && !((dstate = DC390_read8 (DMA_Status)) &
>  				DMA_XFER_DONE) && pSRB->SGToBeXferLen );
> 
> The attached patch is attempting to fix those places. Not sure if this is 
> a proper fix though. In my understanding, after looking through the code, 
> the host_lock is used to protect host-specific data and host-registers. 
> The ->queuecommand is already called with it help, so, one just, 
> basically, have to protect other contexts - interrupt, timer,... So, looks 
> mostly right.

This patch is rejecting in this part:

static void __devexit dc390_remove_one(struct pci_dev *dev)
 {
        struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
-       DC390_IFLAGS;
+       unsigned long iflags;
        PACB pACB = (PACB) scsi_host->hostdata;
 
        scsi_remove_host(scsi_host);
 
-       DC390_LOCK_IO(scsi_host);
+       spin_lock_irqsave(scsi_host->host_lock, iflags);
 

As best as I can tell, DC390_IFLAGS has never been part of the tmscsim.c
file ... I think this must be against some modification of the driver
you have in your tree.

James


