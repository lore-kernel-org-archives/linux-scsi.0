From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ipr boot failure caused by MSI (2.6.30-rc1+)
Date: Fri, 22 May 2009 16:23:15 +0000
Message-ID: <1243009395.2873.18.camel@localhost.localdomain>
References: <1242926159.3007.5.camel@localhost.localdomain>
	<4A15A1B2.8060609@linux.vnet.ibm.com>
	<1242935515.3007.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org>
In-Reply-To: <1242935515.3007.10.camel@localhost.localdomain>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, Wayne Boyer <wayneb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-05-21 at 14:51 -0500, James Bottomley wrote:
> On Thu, 2009-05-21 at 13:47 -0500, Brian King wrote:
> > cc'ing linuxppc-dev...
> > 
> > -Brian
> > 
> > 
> > James Bottomley wrote:
> > > Kernels after 2.6.30-rc1 stopped booting on my powerstation.  The ipr
> > > just times out and refuses to probe devices.  If I let it drop into the
> > > initramfs system, this is what the interrupts shows:
> > > 
> > > (initramfs) cat /proc/interrupts 
> > >            CPU0       CPU1       CPU2       CPU3       
> > >  16:         20         10         13         11   MPIC      Level     pata_amd
> > >  20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
> > >  21:          0          0          0          0  MPIC-U3MSI Edge      ipr
> > >  68:         37         37         48         37   MPIC      Edge      serial
> > > 251:         10         71         69         72   MPIC      Edge      ipi call function
> > > 252:       1555       1779       1372       1155   MPIC      Edge      ipi reschedule
> > > 253:          0          0          0          0   MPIC      Edge      ipi call function single
> > > 254:          0          0          0          0   MPIC      Edge      ipi debugger
> > > BAD:        416
> > > 
> > > So you see the IPR is the only device not receiving them.
> > > 
> > > I can fix the boot hang by reverting
> > > 
> > > commit 5a9ef25b14d39b8413364df12cb8d9bb7a673a32
> > > Author: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> > > Date:   Fri Jan 23 09:17:35 2009 -0800
> > > 
> > >     [SCSI] ipr: add MSI support
> > > 
> > > The system in question is:
> > > 
> > > SYSTEM INFORMATION
> > >  Processor  = PowerPC,970MP @ 2500 MHz
> > >  I/O Bridge = U4 (4.4)
> > >  SMP Size   = 4 (#0 #1 #2 #3)
> > >  Boot-Date  = 2009-04-21 17:13:36
> > >  Memory     = 2 GB of RAM @ 666 MHz
> > >  Board Type = Bimini (7047191/0000000/1)
> > >  MFG Date   = 1608
> > >  Part No.   = 10N8748     
> > >  FRU No.    = 10N7182     
> > >  FRU Serial = YL30W8106038
> > >  UUID       = 00000000000000000000000000000000
> > >  Flashside  = 1 (temporary)
> > >  Version    = HEAD
> > >  Build Date = 12-04-2008 16:13
> 
> OK, so as an update, I booted to the initrd and inserted the network
> modules, which are also MSI enabled and this is what I get:
> 
> (initramfs) cat /proc/interrupts 
>            CPU0       CPU1       CPU2       CPU3       
>  16:         14         11         11         18   MPIC      Level     pata_amd
>  20:          0          0          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
>  21:          0          0          0          0  MPIC-U3MSI Edge      ipr
>  22:          1          0          1          0  MPIC-U3MSI Edge      eth0
>  23:          0          2          1          0  MPIC-U3MSI Edge      eth1
>  68:        193        166        113        177   MPIC      Edge      serial
> 251:         16         65         71         70   MPIC      Edge      ipi call function
> 252:       1574       1804       1346       1289   MPIC      Edge      ipi reschedule
> 253:          0          0          0          0   MPIC      Edge      ipi call function single
> 254:          0          0          0          0   MPIC      Edge      ipi debugger
> BAD:       1866
> 
> So clearly the MSI interrupts to the network cards are working and it
> looks like just a local problem with the ipr rather than a platform
> problem with MSI.

I saw the quirk fix for this go by:

http://ozlabs.org/pipermail/linuxppc-dev/2009-May/072436.html

Is there an easy way to trigger an interrupt on this device?  Preferably
in ipr_probe_ioa() so we can at least print out if the interrupts are
misrouted and fall back from MSI to normal using the PCI infrastructure?

James
