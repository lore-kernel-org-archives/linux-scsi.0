From: Ayman El-Khashab <ayman@elkhashab.com>
Subject: Re: need help solving mpt2sas target unplug can hang worker thread
Date: Tue, 20 Mar 2012 15:14:23 -0500
Message-ID: <20120320201423.GA15563@crust.elkhashab.com>
References: <20120214131541.GA28005@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E49FF7F@inbmail02.lsi.com>
 <20120222001650.GA16640@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E672DE4@inbmail02.lsi.com>
 <20120309005440.GA28098@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E7324D5@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2CTUO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 16:14:26 -0400
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6067E7324D5@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Tue, Mar 20, 2012 at 05:24:20PM +0530, Nandigama, Nagalakshmi wrote:
> Can you try this patch and test?
> 
> On Tue, Feb 28, 2012 at 05:18:53PM +0530, Nandigama, Nagalakshmi wrote:
> > It seems like you are using older version of mpt2sas driver. Current version of mpt2sas driver is 12.100.00.00. Will it be possible to you to test with the latest or any stable driver? Also can you take update the latest firmware?
> > 
> 
> Ok, I've got now 12.0.0 that I pulled from git.  While it
> compiles clean, I can't get far with it b/c it hangs my
> system when I insmod the driver.  In the past, I have had to
> apply this patch that I submitted long ago and never got
> used.

No luck with that patch.  I applied it, but it did not hit
that condition.  It made it all the way to the code just
before the label "chain_done:".  I insert printks all over
the place to figure out where it goes.  It failed somewhere
in here because I got a printk just before it, but I did not
get the printk immediately at chain_done.  I applied it to
12.0.0.  The print just before the for loop was the last I
saw and then it hung.

    for (i = 0; i < ioc->chain_depth; i++) {
        ioc->chain_lookup[i].chain_buffer = pci_pool_alloc(
            ioc->chain_dma_pool , GFP_KERNEL,
            &ioc->chain_lookup[i].chain_buffer_dma);
        if (!ioc->chain_lookup[i].chain_buffer) {
            ioc->chain_depth = i;
            goto chain_done;
        }
        total_sz += ioc->request_sz;
    }
chain_done:

