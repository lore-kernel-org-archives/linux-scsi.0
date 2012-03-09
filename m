From: Ayman El-Khashab <ayman@elkhashab.com>
Subject: Re: need help solving mpt2sas target unplug can hang worker thread
Date: Thu, 8 Mar 2012 18:54:40 -0600
Message-ID: <20120309005440.GA28098@crust.elkhashab.com>
References: <20120214131541.GA28005@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E49FF7F@inbmail02.lsi.com>
 <20120222001650.GA16640@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E672DE4@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2CIAyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2012 19:54:43 -0500
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6067E672DE4@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, linux-scsi@vger.kernel.org

On Tue, Feb 28, 2012 at 05:18:53PM +0530, Nandigama, Nagalakshmi wrote:
> It seems like you are using older version of mpt2sas driver. Current version of mpt2sas driver is 12.100.00.00. Will it be possible to you to test with the latest or any stable driver? Also can you take update the latest firmware?
> 

Ok, I've got now 12.0.0 that I pulled from git.  While it
compiles clean, I can't get far with it b/c it hangs my
system when I insmod the driver.  In the past, I have had to
apply this patch that I submitted long ago and never got
used.

* http://lkml.indiana.edu/hypermail/linux/kernel/1107.1/02101.html

* Changed the type of chip_phys from a u64 to a phys_addr_t.
* Changed ifdef from BITS_PER_LONG to CONFIG_ARCH_DMA_ADDR_T_64BIT so that
* it works on 32 bit systems that have pci address spaces larger than 32
* bits.

I am doing this on a powerpc 460SX with a sas 2008 part, 
firmware v 9.0

In any case, it doesn't appear that the I need the #ifdef
anymore, but replacing the u64 with phys_addr_t might still
be required.  

After trying to load the code against 2.6.37, the code
spins infinately in the loop around line 2613 in the
mpt2sas_base.c -- this code specifically.  I added prints in
the loop, so I observed it never got out of this for loop.
It spun until I got this message: ttyS0: 1 input overrun(s)
Without any printks it just sits here for ever with this
being the last printk reached.

    printk("chain_depth = %d\n", ioc->chain_depth);
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

Not really sure why it is stuck in this loop and don't know
the best way to debug this.

Thanks
Ayman
