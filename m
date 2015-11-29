From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Sun, 29 Nov 2015 10:09:57 +0100
Message-ID: <201511291009.57886.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511290013.06581.linux@rainbow-software.org> <alpine.LNX.2.00.1511291034460.18868@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:55791 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbK2JKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2015 04:10:09 -0500
In-Reply-To: <alpine.LNX.2.00.1511291034460.18868@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sunday 29 November 2015 01:46:03 Finn Thain wrote:
> 
> On Sun, 29 Nov 2015, Ondrej Zary wrote:
> 
> > > [...] I think that this should solve the problem:
> > 
> > Yes, it does!
> > 
> > [   48.119367] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_DMA_FIXUP }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > [   49.715388] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> 
> That still takes about 1.6 seconds to scan a vacant bus ID. It should be 
> more like 0.25 seconds. Did you have the entire patch series applied?
> 
> The code presently in mainline spins for 500 iterations in the relevant 
> busy-wait loop, with the comment, "8uS a cycle for the cpu access". That 
> doesn't help me much. Does that refer to an ISA bus cycle? Or one 
> iteration of the loop? Electrical conductance?
> 
> If we knew how many loops_per_jiffy your machine gets, and your CONFIG_HZ 
> value, we could figure out how long a chip register access takes (which 
> might be 8 us).

loops_per_jiffy=4797252
CONFIG_HZ=250

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Celeron(TM) CPU                1200MHz
stepping        : 1
microcode       : 0x1c
cpu MHz         : 1199.313
cache size      : 256 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx fxsr sse
bugs            :
bogomips        : 2398.62
clflush size    : 32
cache_alignment : 32
address sizes   : 36 bits physical, 32 bits virtual
power management:


# cat iotest.c
#include <stdio.h>
#include <sys/io.h>

int main(void) {
        if (iopl(3)) {
                perror("iopl");
                return 1;
        }
        for (int i = 0; i < 10000000; i++)
                inb(0x280);
        return 0;
}

# cc --std=c99 iotest.c -o iotest
# time ./iotest

real    0m16.938s
user    0m16.932s
sys     0m0.000s

outb() instead of inb():
# time ./iotest

real    0m17.210s
user    0m17.204s
sys     0m0.000s


> I'll try to figure out a similar timing for my Domex PCI card to see if 
> there is some sort of compromise to be found.


-- 
Ondrej Zary
