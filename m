From: Matthew Wilcox <willy@debian.org>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: Thu, 16 Sep 2004 16:31:42 +0100
Sender: <willy@www.linux.org.uk>
Message-ID: <20040916153142.GM642@parcelfarce.linux.theplanet.co.uk>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de> <20040916141323.GL642@parcelfarce.linux.theplanet.co.uk> <hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Content-Disposition: inline
In-Reply-To: <hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de>
Resent-Message-ID: <6X-F_.A.3CC.hHbSBB@murphy>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-kernel/>
To: Jens Schmalzing <j.s@lmu.de>
Cc: Matthew Wilcox <willy@debian.org>, debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2004 at 04:22:54PM +0200, Jens Schmalzing wrote:
> > As upstream maintainer, I'd like more information about it please ...
> 
> >  - How does it "not work properly"?  Does it hang on first access to
> >    the chip, or does it suffer data corruption?
> 
> It outputs a "can't map PCI MMIO region" and does nothing at all.

Interesting.  This can only happen if ioremap() returns NULL.  That can
happen for a number of reasons ...

 - Requesting a size of 0.  This isn't happening because the driver
   requests either 128 or 256.
 - Wrap-around.  If the address is right at the top of io space, this
   could happen, but is very unlikely.
 - If the page involved is normal RAM.  Seems unlikely, but if the system
   is misconfigured, it's possible.
 - If we can't get_vm_area().  Possible, but unlikely.
 - If remap_area_pages() fails.  Again, possible but unlikely.

> >  - Are the io memory resources on this Thinkpad properly programmed?
> 
> Most likely they aren't.  Any idea how I could find out?

lspci -v of that device would be interesting to see.

> >  - What kernel were you trying, 2.4 or 2.6?
> 
> I was using the official Debian kernel, version 2.6.8, from the
> installation CD, built with:
> 
> CONFIG_SCSI_SYM53C8XX_2=m
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> # CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

Those are good config options.

I think we need to do a little debugging... could you add the following
patch and let me know the outcome?

--- drivers/scsi/sym53c8xx_2/sym_glue.c 16 Sep 2004 01:54:44 -0000      1.60
+++ drivers/scsi/sym53c8xx_2/sym_glue.c 16 Sep 2004 15:30:38 -0000
@@ -1674,6 +1674,8 @@ static struct Scsi_Host * __devinit sym_
 
 #ifndef SYM_CONF_IOMAPPED
        np->s.mmio_va = ioremap(dev->s.base_c, np->s.io_ws);
+       printk(KERN_DEBUG "map 0x%lx length %d returned 0x%p\n", dev->s.base_c,
+                       np->s.io_ws, np->s.mmio_va);
        if (!np->s.mmio_va) {
                printf_err("%s: can't map PCI MMIO region\n", sym_name(np));
                goto attach_failed;


-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
