From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sat, 8 Dec 2007 22:19:39 -0600 (CST)
Message-ID: <20071209041939.7DE6FDBA2@gherkin.frus.com>
References: <475B3C23.6010304@orcon.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753098AbXLIET5@vger.kernel.org>
In-Reply-To: <475B3C23.6010304@orcon.net.nz> "from Michael Cree at Dec 9, 2007
 01:51:47 pm"
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Cree <mcree@orcon.net.nz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
List-Id: linux-scsi@vger.kernel.org

Michael Cree wrote:
> Kay Sievers wrote:
> > On Fri, 2007-12-07 at 23:05 -0600, Bob Tracy wrote:
> >> Kay Sievers wrote:
> >>> Is the udev daemon (still) running while it fails?
> >> Yes, and there's something else I forgot to mention that may be
> >> significant...  For the bad case, in addition to udevd, "ps -ef"
> >> shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
> >> process doesn't exit until I reboot.  If this is normal under the
> >> circumstances, please disregard.
> > 
> > Does SysRq-T show where it hangs?
> 
> Ummm... No.  I didn't have the CONFIG_MAGIC_SYSRQ flag set, so I set it, 
> and recompiled the kernel.  Guess what - now the system comes up 
> normally without any problem.  The block devices appear in /dev.  To 
> recap: without CONFIG_MAGIC_SYSRQ on the 2.6.24-rc3 kernel the missing 
> block devices error in /dev occurs and the init scripts fall over on 
> startup, and with CONFIG_MAGIC_SYSRQ the system comes up normally.

I *do* have CONFIG_MAGIC_SYSRQ set.  Anyone care to bet whether my
machine starts working again if I disable it?  Sheesh...  The "kernel
alignment issue" theory is making sense...  We change the size of an
initialized variable with the patch, and the problem shows up.  We
shift starting addresses a different way by tweaking kernel options,
and two wrongs make a right?  I've seen it happen, and tracking this
down isn't going to be easy.  Anyone want to wade through the different
System.map files and hazard a guess where we're leaving the rails?

Here's a very brief diff excerpt between the System.map files corresponding
to "sysctl_check patch reverted" (the -dirty version) and "with sysctl_check patch".
At least they agree up to line 10870 :-) ...

--- /boot/System.map-2.6.24-rc2-g6f37ac79-dirty 2007-12-07 08:03:50.000000000 -0
600
+++ System.map  2007-12-07 13:43:37.000000000 -0600
@@ -10868,9414 +10868,9414 @@
 fffffc0000684b00 R kallsyms_markers
 fffffc0000684d00 R kallsyms_token_table
 fffffc0000685100 R kallsyms_token_index
-fffffc00006f61e0 r __pci_fixup_PCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_CSB5IDEquirk_svwks_csb5ide
-fffffc00006f61e0 R __start_pci_fixups_early
-fffffc00006f61f0 r __pci_fixup_PCI_VENDOR_ID_INTELPCI_DEVICE_ID_INTEL_82801CA_10quirk_ide_samemode
(...)
-fffffc0000716120 r __param_bic_scale
-fffffc0000716148 r __param_tcp_friendliness
-fffffc0000716170 R __end_rodata
-fffffc0000716170 R __stop___param
+fffffc00006f61f0 r __pci_fixup_PCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_CSB5IDEquirk_svwks_csb5ide
+fffffc00006f61f0 R __start_pci_fixups_early
+fffffc00006f6200 r __pci_fixup_PCI_VENDOR_ID_INTELPCI_DEVICE_ID_INTEL_82801CA_10quirk_ide_samemode
(...)
+fffffc0000716130 r __param_bic_scale
+fffffc0000716158 r __param_tcp_friendliness
+fffffc0000716180 R __end_rodata
+fffffc0000716180 R __stop___param
 fffffc0000718000 A __init_begin
 fffffc0000718000 T _sinittext
 fffffc0000718000 t set_reset_devices

> When running the broken kernel udev is running (according to 'ps') and 
> executing /sbin/udevtrigger manually generates a number of errors of the 
> form:
> 
> scsi_id[<pid>]: scsi_id: unable to access '/block'
> 
> The missing /dev/* entries do not appear.

I don't get the errors that Michael is seeing, and udevtrigger seems to
be exiting without errors (return code 0).  The last part is the same:
the missing /dev/* entries do not appear.

--Bob T.
