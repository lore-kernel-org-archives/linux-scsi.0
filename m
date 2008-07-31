From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11185] New: Device/host RESET in SCSI
Date: Wed, 30 Jul 2008 23:24:09 -0700
Message-ID: <20080730232409.81965504.akpm@linux-foundation.org>
References: <bug-11185-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbYGaGYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 02:24:43 -0400
In-Reply-To: <bug-11185-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cijoml@volny.cz
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 30 Jul 2008 23:18:04 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11185
> 
>            Summary: Device/host RESET in SCSI
>            Product: Platform Specific/Hardware
>            Version: 2.5
>      KernelVersion: 2.6.26
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: PPC-64
>         AssignedTo: anton@samba.org
>         ReportedBy: cijoml@volny.cz
> 
> 
> Latest working kernel version: 2.6.25, 2.6.18??? both tested are Debian
> distribution kernels
> Earliest failing kernel version: unknown
> Distribution: Debian stable
> Hardware Environment: IBM H70, PPC64 kernel
> Software Environment: Debian stable, 2.6.26 self compiled

Why do you describe this regression as a powerpc problem rather than a
scsi one?

(It could be either or both, I'm just wondering...)

> Problem Description:
> 
> [    3.881326] sym53c8xx 0000:00:0c.0: enabling device (0140 -> 0143)
> [    3.959117] sym0: <875> rev 0x4 at pci 0000:00:0c.0 irq 17
> [    4.029503] sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
> [    4.108967] sym0: SCSI BUS has been reset.
> [    4.160753] scsi0 : sym-2.2.3
> [    4.200066] sym53c8xx 0000:00:11.0: enabling device (0140 -> 0143)
> [    4.278375] sym1: <895> rev 0x1 at pci 0000:00:11.0 irq 19
> [    4.349340] sym1: No NVRAM, ID 7, Fast-40, SE, parity checking
> [    4.429359] sym1: SCSI BUS has been reset.
> [    4.481660] scsi1 : sym-2.2.3
> [    4.521351] sym53c8xx 0001:40:0c.0: enabling device (0140 -> 0143)
> [    4.600250] sym2: <875> rev 0x3 at pci 0001:40:0c.0 irq 29
> [    4.756252] sym2: No NVRAM, ID 7, Fast-20, SE, parity checking
> [    4.836739] sym2: SCSI BUS has been reset.
> [    4.889450] scsi2 : sym-2.2.3
> [    4.929845] st: Version 20080224, fixed bufsize 32768, s/g segs 256
> [    5.008868] Driver 'st' needs updating - please use bus_type methods
> [    5.089184] Driver 'sd' needs updating - please use bus_type methods
> [    5.169000] Driver 'sr' needs updating - please use bus_type methods
> [    5.248969] SCSI Media Changer driver v0.25
> [    5.303686] Driver 'ch' needs updating - please use bus_type methods
> [    5.385159] mice: PS/2 mouse device common for all mice
> [    5.454519] TCP cubic registered
> [    5.496517] NET: Registered protocol family 17
> [    5.553945] registered taskstats version 1
> [    5.606960] scsi: waiting for bus probes to complete ...
> [   12.689883] scsi 0:0:0:0: ABORT operation started
> [   13.057829] scsi 1:0:0:0: ABORT operation started
> [   13.401828] scsi 2:0:0:0: ABORT operation started
> [   17.745837] scsi 0:0:0:0: ABORT operation timed-out.
> [   17.808370] scsi 0:0:0:0: DEVICE RESET operation started
> [   18.113823] scsi 1:0:0:0: ABORT operation timed-out.
> [   18.176365] scsi 1:0:0:0: DEVICE RESET operation started
> [   18.457824] scsi 2:0:0:0: ABORT operation timed-out.
> [   18.520280] scsi 2:0:0:0: DEVICE RESET operation started
> [   22.873822] scsi 0:0:0:0: DEVICE RESET operation timed-out.
> [   22.943527] scsi 0:0:0:0: BUS RESET operation started
> [   23.241823] scsi 1:0:0:0: DEVICE RESET operation timed-out.
> [   23.311387] scsi 1:0:0:0: BUS RESET operation started
> [   23.585824] scsi 2:0:0:0: DEVICE RESET operation timed-out.
> [   23.655371] scsi 2:0:0:0: BUS RESET operation started
> [   28.005857] scsi 0:0:0:0: BUS RESET operation timed-out.
> [   28.072268] scsi 0:0:0:0: HOST RESET operation started
> [   28.143373] sym0: SCSI BUS has been reset.
> [   28.373822] scsi 1:0:0:0: BUS RESET operation timed-out.
> [   28.440183] scsi 1:0:0:0: HOST RESET operation started
> [   28.511103] sym1: SCSI BUS has been reset.
> [   28.717826] scsi 2:0:0:0: BUS RESET operation timed-out.
> [   28.784138] scsi 2:0:0:0: HOST RESET operation started
> [   28.854961] sym2: SCSI BUS has been reset.
> [   33.193826] scsi 0:0:0:0: HOST RESET operation timed-out.
> [   33.261164] scsi 0:0:0:0: Device offlined - not ready after error recovery
> [   33.561823] scsi 1:0:0:0: HOST RESET operation timed-out.
> [   33.629409] scsi 1:0:0:0: Device offlined - not ready after error recovery
> [   33.905841] scsi 2:0:0:0: HOST RESET operation timed-out.
> [   33.973557] scsi 2:0:0:0: Device offlined - not ready after error recovery
> [   38.845823] scsi 0:0:1:0: ABORT operation started
> [   39.213828] scsi 1:0:1:0: ABORT operation started
> [   39.469825] scsi 2:0:1:0: ABORT operation started
> [   43.901857] scsi 0:0:1:0: ABORT operation timed-out.
> [   43.964323] scsi 0:0:1:0: DEVICE RESET operation started
> [   44.269822] scsi 1:0:1:0: ABORT operation timed-out.
> [   44.332252] scsi 1:0:1:0: DEVICE RESET operation started
> [   44.525821] scsi 2:0:1:0: ABORT operation timed-out.
> [   44.588275] scsi 2:0:1:0: DEVICE RESET operation started
> [   49.029823] scsi 0:0:1:0: DEVICE RESET operation timed-out.
> [   49.099525] scsi 0:0:1:0: BUS RESET operation started
> [   49.397822] scsi 1:0:1:0: DEVICE RESET operation timed-out.
> [   49.467597] scsi 1:0:1:0: BUS RESET operation started
> [   49.653820] scsi 2:0:1:0: DEVICE RESET operation timed-out.
> [   49.723526] scsi 2:0:1:0: BUS RESET operation started
> [   54.161858] scsi 0:0:1:0: BUS RESET operation timed-out.
> [   54.228409] scsi 0:0:1:0: HOST RESET operation started
> [   54.299580] sym0: SCSI BUS has been reset.
> [   54.529821] scsi 1:0:1:0: BUS RESET operation timed-out.
> [   54.596347] scsi 1:0:1:0: HOST RESET operation started
> [   54.667436] sym1: SCSI BUS has been reset.
> [   54.785819] scsi 2:0:1:0: BUS RESET operation timed-out.
> [   54.852267] scsi 2:0:1:0: HOST RESET operation started
> [   54.922982] sym2: SCSI BUS has been reset.
> [   59.349828] scsi 0:0:1:0: HOST RESET operation timed-out.
> [   59.417183] scsi 0:0:1:0: Device offlined - not ready after error recovery
> [   59.717822] scsi 1:0:1:0: HOST RESET operation timed-out.
> [   59.785439] scsi 1:0:1:0: Device offlined - not ready after error recovery
> [   59.973820] scsi 2:0:1:0: HOST RESET operation timed-out.
> [   60.041448] scsi 2:0:1:0: Device offlined - not ready after error recovery
> [   65.001825] scsi 0:0:2:0: ABORT operation started
> [   65.369821] scsi 1:0:2:0: ABORT operation started
> [   65.625824] scsi 2:0:2:0: ABORT operation started
> [   70.057856] scsi 0:0:2:0: ABORT operation timed-out.
> [   70.120341] scsi 0:0:2:0: DEVICE RESET operation started
> [   70.425820] scsi 1:0:2:0: ABORT operation timed-out.
> [   70.488251] scsi 1:0:2:0: DEVICE RESET operation started
> [   70.681820] scsi 2:0:2:0: ABORT operation timed-out.
> [   70.744266] scsi 2:0:2:0: DEVICE RESET operation started
> [   75.185827] scsi 0:0:2:0: DEVICE RESET operation timed-out.
> [   75.255546] scsi 0:0:2:0: BUS RESET operation started
> [   75.553822] scsi 1:0:2:0: DEVICE RESET operation timed-out.
> [   75.623581] scsi 1:0:2:0: BUS RESET operation started
> [   75.809837] scsi 2:0:2:0: DEVICE RESET operation timed-out.
> [   75.879524] scsi 2:0:2:0: BUS RESET operation started
> [   80.317876] scsi 0:0:2:0: BUS RESET operation timed-out.
> [   80.384393] scsi 0:0:2:0: HOST RESET operation started
> [   80.455478] sym0: SCSI BUS has been reset.
> [   80.685820] scsi 1:0:2:0: BUS RESET operation timed-out.
> [   80.752306] scsi 1:0:2:0: HOST RESET operation started
> [   80.823332] sym1: SCSI BUS has been reset.
> [   80.941820] scsi 2:0:2:0: BUS RESET operation timed-out.
> [   81.008217] scsi 2:0:2:0: HOST RESET operation started
> [   81.079035] sym2: SCSI BUS has been reset.
> [   85.505820] scsi 0:0:2:0: HOST RESET operation timed-out.
> [   85.573175] scsi 0:0:2:0: Device offlined - not ready after error recovery
> [   85.873839] scsi 1:0:2:0: HOST RESET operation timed-out.
> [   85.941331] scsi 1:0:2:0: Device offlined - not ready after error recovery
> [   86.129819] scsi 2:0:2:0: HOST RESET operation timed-out.
> [   86.197497] scsi 2:0:2:0: Device offlined - not ready after error recovery
> [   91.157827] scsi 0:0:3:0: ABORT operation started
> [   91.525844] scsi 1:0:3:0: ABORT operation started
> [   91.781824] scsi 2:0:3:0: ABORT operation started
> [   96.213848] scsi 0:0:3:0: ABORT operation timed-out.
> [   96.276335] scsi 0:0:3:0: DEVICE RESET operation started
> [   96.581820] scsi 1:0:3:0: ABORT operation timed-out.
> [   96.644261] scsi 1:0:3:0: DEVICE RESET operation started
> [   96.837819] scsi 2:0:3:0: ABORT operation timed-out.
> [   96.900213] scsi 2:0:3:0: DEVICE RESET operation started
> [  101.341843] scsi 0:0:3:0: DEVICE RESET operation timed-out.
> [  101.411555] scsi 0:0:3:0: BUS RESET operation started
> [  101.709820] scsi 1:0:3:0: DEVICE RESET operation timed-out.
> [  101.779494] scsi 1:0:3:0: BUS RESET operation started
> [  101.965819] scsi 2:0:3:0: DEVICE RESET operation timed-out.
> [  102.035530] scsi 2:0:3:0: BUS RESET operation started
> [  106.473854] scsi 0:0:3:0: BUS RESET operation timed-out.
> [  106.540347] scsi 0:0:3:0: HOST RESET operation started
> [  106.611496] sym0: SCSI BUS has been reset.
> [  106.841818] scsi 1:0:3:0: BUS RESET operation timed-out.
> [  106.908266] scsi 1:0:3:0: HOST RESET operation started
> [  106.979253] sym1: SCSI BUS has been reset.
> [  107.097818] scsi 2:0:3:0: BUS RESET operation timed-out.
> [  107.164208] scsi 2:0:3:0: HOST RESET operation started
> [  107.234919] sym2: SCSI BUS has been reset.
> [  111.661848] scsi 0:0:3:0: HOST RESET operation timed-out.
> [  111.729202] scsi 0:0:3:0: Device offlined - not ready after error recovery
> [  112.029820] scsi 1:0:3:0: HOST RESET operation timed-out.
> [  112.097359] scsi 1:0:3:0: Device offlined - not ready after error recovery
> [  112.285818] scsi 2:0:3:0: HOST RESET operation timed-out.
> [  112.353503] scsi 2:0:3:0: Device offlined - not ready after error recovery
> [  117.313828] scsi 0:0:4:0: ABORT operation started
> [  117.681823] scsi 1:0:4:0: ABORT operation started
> [  117.937839] scsi 2:0:4:0: ABORT operation started
> [  122.369861] scsi 0:0:4:0: ABORT operation timed-out.
> [  122.432287] scsi 0:0:4:0: DEVICE RESET operation started
> [  122.737819] scsi 1:0:4:0: ABORT operation timed-out.
> [  122.800214] scsi 1:0:4:0: DEVICE RESET operation started
> [  122.993820] scsi 2:0:4:0: ABORT operation timed-out.
> [  123.056273] scsi 2:0:4:0: DEVICE RESET operation started
> [  127.497830] scsi 0:0:4:0: DEVICE RESET operation timed-out.
> [  127.567586] scsi 0:0:4:0: BUS RESET operation started
> [  127.865836] scsi 1:0:4:0: DEVICE RESET operation timed-out.
> [  127.935537] scsi 1:0:4:0: BUS RESET operation started
> [  128.121818] scsi 2:0:4:0: DEVICE RESET operation timed-out.
> [  128.191627] scsi 2:0:4:0: BUS RESET operation started
> [  132.629865] scsi 0:0:4:0: BUS RESET operation timed-out.
> [  132.696399] scsi 0:0:4:0: HOST RESET operation started
> [  132.767554] sym0: SCSI BUS has been reset.
> [  132.997819] scsi 1:0:4:0: BUS RESET operation timed-out.
> [  133.064328] scsi 1:0:4:0: HOST RESET operation started
> [  133.135414] sym1: SCSI BUS has been reset.
> [  133.253817] scsi 2:0:4:0: BUS RESET operation timed-out.
> [  133.320242] scsi 2:0:4:0: HOST RESET operation started
> [  133.390987] sym2: SCSI BUS has been reset.
> [  137.817850] scsi 0:0:4:0: HOST RESET operation timed-out.
> [  137.885271] scsi 0:0:4:0: Device offlined - not ready after error recovery
> [  138.185819] scsi 1:0:4:0: HOST RESET operation timed-out.
> [  138.253407] scsi 1:0:4:0: Device offlined - not ready after error recovery
> [  138.441818] scsi 2:0:4:0: HOST RESET operation timed-out.
> [  138.509454] scsi 2:0:4:0: Device offlined - not ready after error recovery
> [  143.469830] scsi 0:0:5:0: ABORT operation started
> [  143.837839] scsi 1:0:5:0: ABORT operation started
> [  144.093822] scsi 2:0:5:0: ABORT operation started
> [  148.525863] scsi 0:0:5:0: ABORT operation timed-out.
> [  148.588334] scsi 0:0:5:0: DEVICE RESET operation started
> [  148.893821] scsi 1:0:5:0: ABORT operation timed-out.
> [  148.956234] scsi 1:0:5:0: DEVICE RESET operation started
> [  149.149817] scsi 2:0:5:0: ABORT operation timed-out.
> [  149.212295] scsi 2:0:5:0: DEVICE RESET operation started
> [  153.653831] scsi 0:0:5:0: DEVICE RESET operation timed-out.
> [  153.723629] scsi 0:0:5:0: BUS RESET operation started
> [  154.021836] scsi 1:0:5:0: DEVICE RESET operation timed-out.
> [  154.091593] scsi 1:0:5:0: BUS RESET operation started
> [  154.277817] scsi 2:0:5:0: DEVICE RESET operation timed-out.
> [  154.347515] scsi 2:0:5:0: BUS RESET operation started
> [  158.785866] scsi 0:0:5:0: BUS RESET operation timed-out.
> [  158.852420] scsi 0:0:5:0: HOST RESET operation started
> [  158.923602] sym0: SCSI BUS has been reset.
> [  159.153819] scsi 1:0:5:0: BUS RESET operation timed-out.
> [  159.220336] scsi 1:0:5:0: HOST RESET operation started
> [  159.291467] sym1: SCSI BUS has been reset.
> [  159.409816] scsi 2:0:5:0: BUS RESET operation timed-out.
> [  159.476196] scsi 2:0:5:0: HOST RESET operation started
> [  159.546998] sym2: SCSI BUS has been reset.
> [  163.973852] scsi 0:0:5:0: HOST RESET operation timed-out.
> [  164.041152] scsi 0:0:5:0: Device offlined - not ready after error recovery
> [  164.341818] scsi 1:0:5:0: HOST RESET operation timed-out.
> [  164.409398] scsi 1:0:5:0: Device offlined - not ready after error recovery
> [  164.597817] scsi 2:0:5:0: HOST RESET operation timed-out.
> [  164.665478] scsi 2:0:5:0: Device offlined - not ready after error recovery
> [  169.625832] scsi 0:0:6:0: ABORT operation started
> [  169.993842] scsi 1:0:6:0: ABORT operation started
> [  170.249820] scsi 2:0:6:0: ABORT operation started
> [  174.681864] scsi 0:0:6:0: ABORT operation timed-out.
> [  174.744345] scsi 0:0:6:0: DEVICE RESET operation started
> [  175.049819] scsi 1:0:6:0: ABORT operation timed-out.
> [  175.112276] scsi 1:0:6:0: DEVICE RESET operation started
> [  175.305816] scsi 2:0:6:0: ABORT operation timed-out.
> [  175.368234] scsi 2:0:6:0: DEVICE RESET operation started
> [  179.809848] scsi 0:0:6:0: DEVICE RESET operation timed-out.
> [  179.879566] scsi 0:0:6:0: BUS RESET operation started
> [  180.177820] scsi 1:0:6:0: DEVICE RESET operation timed-out.
> [  180.247619] scsi 1:0:6:0: BUS RESET operation started
> [  180.433833] scsi 2:0:6:0: DEVICE RESET operation timed-out.
> [  180.503503] scsi 2:0:6:0: BUS RESET operation started
> [  184.941817] scsi 0:0:6:0: BUS RESET operation timed-out.
> [  185.008334] scsi 0:0:6:0: HOST RESET operation started
> [  185.079490] sym0: SCSI BUS has been reset.
> [  185.309817] scsi 1:0:6:0: BUS RESET operation timed-out.
> [  185.376387] scsi 1:0:6:0: HOST RESET operation started
> [  185.447443] sym1: SCSI BUS has been reset.
> [  185.565816] scsi 2:0:6:0: BUS RESET operation timed-out.
> [  185.632200] scsi 2:0:6:0: HOST RESET operation started
> [  185.703010] sym2: SCSI BUS has been reset.
> [  190.129853] scsi 0:0:6:0: HOST RESET operation timed-out.
> [  190.197192] scsi 0:0:6:0: Device offlined - not ready after error recovery
> [  190.497836] scsi 1:0:6:0: HOST RESET operation timed-out.
> [  190.565325] scsi 1:0:6:0: Device offlined - not ready after error recovery
> [  190.753820] scsi 2:0:6:0: HOST RESET operation timed-out.
> [  190.753842] scsi 2:0:6:0: Device offlined - not ready after error recovery
> [  195.781822] scsi 0:0:8:0: ABORT operation started
> [  196.149821] scsi 1:0:8:0: ABORT operation started
> [  196.253813] scsi 2:0:8:0: ABORT operation started
> [  200.837815] scsi 0:0:8:0: ABORT operation timed-out.
> [  200.900204] scsi 0:0:8:0: DEVICE RESET operation started
> [  201.205818] scsi 1:0:8:0: ABORT operation timed-out.
> [  201.268267] scsi 1:0:8:0: DEVICE RESET operation started
> [  201.334835] scsi 2:0:8:0: ABORT operation timed-out.
> [  201.397227] scsi 2:0:8:0: DEVICE RESET operation started
> and so on in neverending loop...
> 
> Steps to reproduce:
> 
> Boot with 2.6.26
> 


