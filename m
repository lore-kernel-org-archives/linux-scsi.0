From: James.Smart@Emulex.Com
Subject: RE: still BUG's for smp_processor_id() on interrupt
Date: Wed, 9 Feb 2005 13:13:44 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EB58@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:12995 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261877AbVBISOY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 13:14:24 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, akpm@osdl.org

This looks suspiciously like the oops trace that I saw when
loading/unloading driver a couple of times. Make sure you have the
following patches.

http://marc.theaimsgroup.com/?l=linux-scsi&m=110729104720492&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=110737816906830&w=2


-- James S



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Patrick 
> Mansfield
> Sent: Wednesday, February 09, 2005 12:22 PM
> To: Andrew Vasquez; linux-scsi@vger.kernel.org; Andrew Morton
> Subject: Re: still BUG's for smp_processor_id() on interrupt
> 
> 
> On Tue, Feb 08, 2005 at 10:44:35PM -0800, Andrew Vasquez wrote:
> > On Tue, 08 Feb 2005, Patrick Mansfield wrote:
> > 
> > > I'm still getting lots of BUG's for the smp_processor_id, 
> but via the
> > > interrupt function.
> > > 
> > 
> > It's during the driver's init-time polling for interrupts...
> 
> > Argg -- that was careless...  Again, the smp_processor_id() is used
> > only as a heuristic.  The attached patch should quash the noise.
> 
> OK, that gets rid of the BUG stuff, but now I am hitting an oops.
> 
> A bit odd that the smp_processor_id() debug code seemed to 
> prevent this.
> 
> I am using an old compiler on a NUMAQ system. Attaching the .config.
> 
> This is with 2.6 bk from yesterday + your patch.
> 
> It looks like it is in the list_add_tail() at the end of
> attribute_container_add_device.
> 
> [elm3b79 base]$ gcc -v
> Reading specs from /usr/lib/gcc-lib/i386-linux/2.95.4/specs
> gcc version 2.95.4 20011002 (Debian prerelease)
> 
> Unable to handle kernel paging request at virtual address 42555300
>  printing eip:
> c01dbebb
> *pde = 084bac0f
> Oops: 0000 [#1]
> PREEMPT SMP
> Modules linked in: qla2300 qla2xxx scsi_transport_fc
> CPU:    5
> EIP:    0060:[<c01dbebb>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.11-rc3pm)
> EIP is at attribute_container_add_device+0x143/0x16c
> eax: 42555300   ebx: f46200e4   ecx: 00000000   edx: 42555300
> esi: c0357964   edi: f4620000   ebp: c0357964   esp: e0b92e50
> ds: 007b   es: 007b   ss: 0068
> Process modprobe (pid: 8582, threadinfo=e0b92000 task=f4880570)
> Stack: f46200e4 c0357964 f4620000 c0357964 f462013c 42555300 
> c01dc2c7 f46200e4
>        c01dc294 c0203658 f46200e4 f4620184 f4620000 00000000 
> f46200e4 c01fbf79
>        f4620000 f46201ec f4620000 f5a81444 036310e5 f88b79d7 
> f4620000 f5a81444
> Call Trace:
>  [<c01dc2c7>] transport_setup_device+0xf/0x14
>  [<c01dc294>] transport_setup_classdev+0x0/0x24
>  [<c0203658>] scsi_sysfs_add_host+0xac/0xbc
>  [<c01fbf79>] scsi_add_host+0xf1/0x124
>  [<f88b79d7>] qla2x00_probe_one+0x75b/0x874 [qla2xxx]
>  [<f88d0012>] gcc2_compiled.+0x12/0x18 [qla2300]
>  [<c01b2424>] pci_device_probe_static+0x2c/0x40
>  [<c01b2457>] __pci_device_probe+0x1f/0x34
>  [<c01b2488>] pci_device_probe+0x1c/0x34
>  [<c01d918d>] driver_probe_device+0x41/0x64
>  [<c01d9260>] driver_attach+0x34/0x68
>  [<c01d96bb>] bus_add_driver+0x8b/0xbc
>  [<c01d9c08>] driver_register+0x50/0x54
>  [<c01b2686>] pci_register_driver+0x86/0xa0
>  [<f888800a>] qla2300_init+0xa/0x10 [qla2300]
>  [<c012c479>] sys_init_module+0x111/0x270
>  [<c0102443>] syscall_call+0x7/0xb
> Code: 55 e8 4a 02 00 00 83 c4 04 8b 44 24 14 83 c0 08 8b 50 
> 04 89 58 04 89 03 89 53 04 89 1a 8b 44 24 14 8b 00 89 44 24 
> 14 8b 54 24 14 <8b> 02 0f 18 00 90 81 fa 80 91 46 c0 0f 85 e7 
> fe ff ff f0 ff 05
> 
> -- Patrick Mansfield
> 
