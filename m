From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	GB chunk?!?
Date: Fri, 13 Feb 2004 16:20:35 -0500
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF915E@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3F277.385D3B50"
Return-path: <linux-ia64-owner@vger.kernel.org>
To: Alex Williamson <alex.williamson@hp.com>, jeremy@sgi.com
Cc: linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3F277.385D3B50
Content-Type: text/plain;
	charset="iso-8859-1"

The reply and request FIFO's have to be within
the same 4GB boundary, as the upper 32 bits
are provided in the IOC Init HostMfaHighAddr field. I
see it crossed boundaries in your post.

I added pci_set_consistent_dma_mask() per request from
Jeremy Higdon<jeremy@sgi.com> back on 12/03/03. He
was having problems on a Altix (IA64) system. See
attached email.  What is your recommendation? I have a mpt 
patch in the queue which doesn't address this.


Eric Moore


On Friday, February 13, 2004 9:12 AM, Alex Williamson wrote:
> 
> 
> Eric,
> 
>    I think I found a bug in the version 3.00.02 mpt driver that's
> currently in Linus' 2.6 tree (latest linux-2.5).  Here's the code
> snippet:
> 
> message/fusion/mptbase.c: PrimeIocFifos()
> ...
>     if (sizeof(dma_addr_t) == sizeof(u64)) {
>         /* Check: upper 32-bits of the request and reply frame
>          * physical addresses must be the same.
>          */
>         if (((u64)ioc->req_frames_dma >> 32) != 
> ((u64)ioc->reply_frames_dma >> 32)){
>             goto out_fail;
>     }
> 
> req_frames_dma and reply_frames_dma are aligned version of 
> dma addresses
> retrieved via two separate pci_alloc_consistent() calls.  The 
> mpt driver
> sets a 64bit consistent dma mask.  How is it reasonable to assume two
> separate mappings will fall within the same 4GB chunk of memory?  I
> recently added support for consistent mapping bypass in the sba_iommu
> driver for the ia64 zx1 chipset.  Randomly on bootup, the MPT driver
> fails.  Checking the mappings, I get a things like this:
> 
> mptbase: Initiating ioc0 bringup
> ioc0: 53C1030: Capabilities={Initiator}
> sba_alloc_coherent() bypassing, dma_handle: 0x1fffb8000, 
> addr: 0xe0000001fffb8000
> sba_alloc_coherent() bypassing, dma_handle: 0x40ffcd8000, 
> addr: 0xe0000040ffcd8000
> PrimeIocFifos() req_frames_dma: 0x40ffcd8000, 
> reply_frames_dma: 0x1fffb8000
> mptbase: WARNING - ioc0 did not initialize properly! (-3)
> 
> These are two perfectly valid consistent mappings as far as 
> the platform
> code is concerned.  I think mpt really needs to either set a 32bit
> consistent map of do a single allocation when it requires this type of
> thing.  Thanks,
> 
> 	Alex
> 
> -- 
> Alex Williamson                             HP Linux & Open Source Lab
> 


------_=_NextPart_000_01C3F277.385D3B50
Content-Type: message/rfc822
Content-Description: Re: [PATCH] 2.6.0-test9 - MPT Fusion driver 2.05.00.05 update

Message-ID: <20031203074959.GA178136@sgi.com>
From: Jeremy Higdon <jeremy@sgi.com>
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: audy@sgi.com, wnunn@sgi.com, gwh@sgi.com
Subject: Re: [PATCH] 2.6.0-test9 - MPT Fusion driver 2.05.00.05 update
Date: Wed, 3 Dec 2003 02:49:59 -0500 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
Content-Type: text/plain;
	charset="iso-8859-1"

On Mon, Nov 17, 2003 at 11:33:49AM -0500, Moore, Eric Dean wrote:
> James: Please apply the patch below to the 2.6 tree.
> 
> If you find this inline patch malformed,
> please kindly download this patch from this URL:
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/
> 
> 
> 2.05.00.05 changes
> * error handling fixes, e.g. use of host_lock


Hi Eric,

I applied your patch to my LSI driver.  If the card sees all the devices,
it seems to work.  However, often times the card won't see the devices until
I manually reset it using lsiutil.

Here are the vital statistics:

Firmware image's version is LSIFC929X-1.00.00 (2003.02.28)
BIOS image's version is FC MPTBIOS-2.01.02.00 (2003.03.24)
FCode image's version is MPT FC FCode Version 1.00.29 (2002.10.21)


I'm testing on an Altix (IA64) system.  By the way, here is a patch that
is necessary for it to work.  This applies on top of your 2.05.00.05 patch.

Also, once I've run lsiutil to reset and probe for devices, how do you
get the SCSI subsystem to probe the driver?
I thought we could
	
	echo 1 > /sys/class/scsi_host/host17/scan

but that doesn't seem to work.

thanks

jeremy


===== drivers/message/fusion/mptbase.c 1.14 vs edited =====
--- 1.14/drivers/message/fusion/mptbase.c	Wed Aug 13 23:10:03 2003
+++ edited/drivers/message/fusion/mptbase.c	Tue Dec  2 22:54:31 2003
@@ -1292,6 +1292,11 @@
 		return r;
 	}
 
+	if (pci_set_consistent_dma_mask(pdev, mask))
+		printk(KERN_INFO "Not using 64 bit consistent mask\n");
+	else
+		printk(KERN_INFO "LSI: Using 64 bit consistent mask\n");
+
 	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add
adapter!\n");

------_=_NextPart_000_01C3F277.385D3B50--
