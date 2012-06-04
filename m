From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Different WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a):
 Section mismatch in reference from the function init_module() to the
 function .exit.text:fcoe_transport_exit()
Date: Mon, 4 Jun 2012 21:08:57 +0200
Message-ID: <20120604190857.GB16584@smp.if.uj.edu.pl>
References: <20120602161502.GW16584@smp.if.uj.edu.pl>
 <20120604143643.GJ32472@redhat.com>
 <20120604163556.GA12303@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120604163556.GA12303@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Robert Love <robert.w.love@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06-04 18:35, Sam Ravnborg wrote:
> On Mon, Jun 04, 2012 at 10:36:43AM -0400, Don Zickus wrote:
> > On Sat, Jun 02, 2012 at 06:15:02PM +0200, Witold Baryluk wrote:
> > > Hello everybody,
> > > 
> > > x86 32-bit Build just got 2 WARNINGS when building kernel on Linus' tree.
> > 
> > Hi Witold,
> > 
> > Thanks for the warnings.
> > 
> > > 
> > > 
> > >  VDSOSYM arch/x86/vdso/vdso32-syms.lds
> > >   LD      arch/x86/vdso/built-in.o
> > >   LD      arch/x86/built-in.o
> > > WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
> > > The variable test_nmi_ipi_callback_na.10451 references
> > > the function __init test_nmi_ipi_callback()
> > > If the reference is valid then annotate the
> > > variable with __init* or __refdata (see linux/init.h) or name the variable:
> > > *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> > > 
> > > WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
> > > The variable nmi_unk_cb_na.10399 references
> > > the function __init nmi_unk_cb()
> > > If the reference is valid then annotate the
> > > variable with __init* or __refdata (see linux/init.h) or name the variable:
> > > *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> > 
> > These are intermediate variables test_nmi_ipi_callback_na.10451 and
> > nmi_unk_cb_na.10399.  I do not know how to fix them.
> > 
> > Basically the test registers two nmi_handlers, run some tests, and
> > then unregisters them.  Those handlers are what the compiler seems to be
> > complaining about.  I do not know what magic to pass the compiler to let
> > it know that both of the handlers will be unregistered before the init
> > section is destroyed.
> > 
> > Perhaps I should tag those callbacks with __ref? I am not sure the right
> > thing to do here.
> 
> Drop the __init from nmi_unk_cb() and test_nmi_ipi_callback().
> Then the warnings are gone.
> 
> Trying to let register_nmi_handler() accept a function annotated __init is
> wrong as we do not want this.
> I someone try this in 'real' code we would be screwed.
> 
> 	Sam


By the way when we are on topic, here is one more


  MKPIGGY arch/x86/boot/compressed/piggy.S
  AS      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  ZOFFSET arch/x86/boot/zoffset.h
  AS      arch/x86/boot/header.o
  CC      arch/x86/boot/version.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  BUILD   arch/x86/boot/bzImage
Setup is 16288 bytes (padded to 16384 bytes).
System is 4418 kB
CRC 46186b65
Kernel: arch/x86/boot/bzImage is ready  (#12)
  Building modules, stage 2.
  MODPOST 591 modules
WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit()
The function __init init_module() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit section.

  CC      arch/x86/crypto/crc32c-intel.mod.o
  LD [M]  arch/x86/crypto/crc32c-intel.ko
  CC      arch/x86/crypto/salsa20-i586.mod.o
  LD [M]  arch/x86/crypto/salsa20-i586.ko
  CC      arch/x86/crypto/serpent-sse2-i586.mod.o
  LD [M]  arch/x86/crypto/serpent-sse2-i586.ko



(I'm dropping previous CC list, as this warning is easier to solve,
probably just following this instructions - dropping __exit from
fcoe_transport_exit() should be fine, especially if indeed it is needed
from init_module in error path).


Regards,
Witek

-- 
Witold Baryluk
