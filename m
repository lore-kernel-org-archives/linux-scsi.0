From: Alexandru Deac <andu@shaw.ca>
Subject: Kernel 2.5.26 panics with Adaptec 2930U
Date: Wed, 17 Jul 2002 21:06:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207172106.58939.andu@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I just compiled kernel 2.5.26 but I can't get it to boot up as it always 
panics when it gets to the scsi devices.
I have a Adaptec 2939U SCSI controller and a Sony SDT-9000 DDS-3 tape 
drive connected to it.
The aic7xxx is built-in to the kernel along  with the tape support as well as 
scsi cdrom support and the scsi-emulation driver for my CD-RW.

Here's the panic output:

Unable to handle NULL pointer dereference at virtual address 0000000c 
printing eip:
c022d7e1
*pde = 00000000
Oops: 0000
CPU: 0
EIP: 0010:[<c022d7e1>]	Not tainted
EFLAGS: 00010092
eax: 00000000	ebx: dfd8d380	ecx: 00000018	edx: 00000000
esi: dfd4e600	edi: 00000000	ebp: 00000013	esp: dffc3e70
ds: 0018   es: 0018   ss: 0018

Process swapper(pid: 1, threadinfo=dffc2000 task=dffc6680)
Stack: dfd8d380 04000001 00000000 c14d5800 00000292 c08093f1 00000013 dfd4e600
       dffc3ed0 c03e8040 c03aacc0 00000013 dffc3ec8 c01095e6 00000013 dffc3ed0
       dfd8d380 dffc2000 00000002 00001c80 00000000 dfd8d380 ff000000 c0107893
Call Trace: [<c01093f1>] [<c01095e6>] [<c0107893>] [<c022fcba>] [<c01e48ac>]
[<c01e3c03>] [<c01e4d67>] [<c01af686>] [<c02324ab>] [<c022c3dc>] [<c0218cb9>]

[<c01e4b2f>] [<c02183a0>] [<c010507b>] [<c0105718>]

Code: 8b 40 0c f0 fe 08 0f 88 d0 1e 00 00 8b 9e 88 00 00 00 81 e3
<0>Kernel panic: Aiee, killing interrup handeler!
In interrupt handeler - not syncing

I didn't run a ksymoops on it since I cannot boot 2.5.26 so I can't use its 
/proc/modules and /proc/ksym. Okay well I did a ksymoops against my current 
kernel 2.4.18 but using 2.5.26 sys map and its modules. I'm not sure if this 
has any value since it was made using a wrong version but here's it output:

>>EIP; c022d7e1 <ahc_linux_isr+21/2e0>   <=====

>>ebx; dfd8d380 <_end+1f95dac4/20453744>
>>esi; dfd4e600 <_end+1f91ed44/20453744>
>>esp; dffc3e70 <_end+1fb945b4/20453744>

Trace; c01093f1 <handle_IRQ_event+51/80>
Trace; c01095e6 <do_IRQ+a6/f0>
Trace; c0107893 <common_interrupt+1f/24>
Trace; c022fcba <aic7770_linux_probe+6a/150>
Trace; c01e48ac <bus_for_each_dev+bc/d0>
Trace; c01e3c03 <driver_attach+13/20>
Trace; c01e4d67 <driver_register+87/a0>
Trace; c01af686 <pci_register_driver+36/50>
Trace; c02324ab <ahc_linux_pci_probe+b/40>
Trace; c022c3dc <ahc_linux_detect+2c/70>
Trace; c0218cb9 <scsi_register_host+49/300>
Trace; c01e4b2f <bus_register+5f/70>
Trace; c02183a0 <scsi_softirq+0/e0>
Trace; c010507b <init+2b/170>
Trace; c0105718 <kernel_thread+28/40>

Code;  c022d7e1 <ahc_linux_isr+21/2e0>
00000000 <_EIP>:
Code;  c022d7e1 <ahc_linux_isr+21/2e0>   <=====
   0:   8b 40 0c                  mov    0xc(%eax),%eax   <=====
Code;  c022d7e4 <ahc_linux_isr+24/2e0>
   3:   f0 fe 08                  lock decb (%eax)
Code;  c022d7e7 <ahc_linux_isr+27/2e0>
   6:   0f 88 d0 1e 00 00         js     1edc <_EIP+0x1edc> c022f6bd 
<.text.lock.aic7xxx_linux+18/ab>
Code;  c022d7ed <ahc_linux_isr+2d/2e0>
   c:   8b 9e 88 00 00 00         mov    0x88(%esi),%ebx
Code;  c022d7f3 <ahc_linux_isr+33/2e0>
  12:   81 e3 00 00 00 00         and    $0x0,%ebx

I don't have much experience submiting kernel bugs as you  have probably 
noticed from this post, but if you need anything else to trace this thing now 
let me know and I'll provide it.

As a side note I just tested 2.5.25 and it gives the same error.

Cheers,
Alex.

