From: Matthew Wilcox <willy@debian.org>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: Thu, 16 Sep 2004 21:14:32 +0100
Sender: <willy@www.linux.org.uk>
Message-ID: <20040916201432.GN642@parcelfarce.linux.theplanet.co.uk>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de> <20040916141323.GL642@parcelfarce.linux.theplanet.co.uk> <hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de> <20040916153142.GM642@parcelfarce.linux.theplanet.co.uk> <hhllfat64h.fsf@theorie.physik.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Content-Disposition: inline
In-Reply-To: <hhllfat64h.fsf@theorie.physik.uni-muenchen.de>
Resent-Message-ID: <IpJ5f.A.RkD.rQfSBB@murphy>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-kernel/>
To: Jens Schmalzing <jens.schmalzing@physik.uni-muenchen.de>
Cc: Matthew Wilcox <willy@debian.org>, debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2004 at 08:34:38PM +0200, Jens Schmalzing wrote:
> Sorry.  I got the message completely wrong.  I really was:
> 
> | PCI: Enabling device 0000:00:0c.0 (0000 -> 0003)
> | sym.0.12.0: MMIO base address disabled.

OK, so that's entirely different.  That happens if we read 0 directly
from the PCI BAR.  Mmmm.  I don't know how that would happen.  Actually,
I don't see why we consider 0 to be an invalid PCI address ... we should
probably be checking the length instead.

> > lspci -v of that device would be interesting to see.
> 
> | 0000:00:0c.0 SCSI storage controller: LSI Logic / Symbios Logic 53c810 (rev 02)
> |         Flags: bus master, medium devsel, latency 128, IRQ 13
> |         I/O ports at 1000 [size=256]
> |         [virtual] Memory at c0000000 (32-bit, non-prefetchable) [size=256]

I just picked up one of those from a friend:

0000:00:0b.0 SCSI storage controller: LSI Logic / Symbios Logic 53c810 (rev 02)
        Flags: bus master, medium devsel, latency 64, IRQ 10
        I/O ports at b400 [size=256]
        Memory at e3000000 (32-bit, non-prefetchable) [size=256]

> So I used them for a test kernel, built from kernel-source-2.6.8 and
> your little debugging patch applied.  What happened is this:
> 
> | map 0xc4000000 length 128 returned 0xf4000000
> 
> and the kernel initialized the SCSI controller correctly - as I could
> verify, this is due to the backported patch from 2.6.9-rc2 that Hollis
> Blanchard sent here earlier in Bug#271852.  So that problem will be
> solved in the next revision.

Urm.  I don't understand.  You said that you encountered the problem
in a Thinkpad 860, but bug 271852 refers to a powerpc-specific problem.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
