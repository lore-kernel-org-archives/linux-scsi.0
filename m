From: Andrew Morton <akpm@digeo.com>
Subject: Re: aix7xxx_old woes in 2.5
Date: Mon, 16 Dec 2002 02:39:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFDAD52.BB836AA4@digeo.com>
References: <3DFC06C9.19AFADE2@digeo.com> <20021216074008.GC13989@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id CAA13394
	for <linux-scsi@vger.kernel.org>; Mon, 16 Dec 2002 02:39:16 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Doug Ledford wrote:
> 
> On Sat, Dec 14, 2002 at 08:36:25PM -0800, Andrew Morton wrote:
> >
> > ho hum.
> >
> > It just doesn't start at all:
> >
> > scsi HBA driver <NULL> didn't set max_sectors, please fix the template<6>(scsi0) <Adaptec AIC-7892 Ultra 160/m SCSI host adapter> found at PCI 3/4/0
> > (scsi0) Wide Channel, SCSI ID=7, 32/255 SCBs
> > (scsi0) Downloading sequencer code... 396 instructions downloaded
> > (scsi1) <Adaptec AIC-7880 Ultra SCSI host adapter> found at PCI 0/10/0
> > (scsi1) Wide Channel, SCSI ID=7, 16/255 SCBs
> > (scsi1) Downloading sequencer code... 436 instructions downloaded
> > scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
> >        <Adaptec AIC-7892 Ultra 160/m SCSI host adapter>
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 0 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 1 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 2 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 3 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 4 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 5 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 6 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 8 lun 0
> >
> > (The above took three minutes or more)
> 
> Interrupt routing problems is what that looks like to me, not driver
> problems.  Try booting with different interrupt settings or with a
> different kernel (smp vs. up, that sort of thing).

Uniprocessor, no IO-APIC.  No go:

           CPU0       
  0:     736412          XT-PIC  timer
  1:         15          XT-PIC  i8042
  2:          0          XT-PIC  cascade
  4:          0          XT-PIC  GDB-stub
  8:          1          XT-PIC  rtc
 11:        294          XT-PIC  ide2, ide3, ide4, ide5, aic7xxx, aic7xxx, eth0
 12:         52          XT-PIC  i8042
 14:       2848          XT-PIC  ide0
 15:          8          XT-PIC  ide1
NMI:          0 
ERR:          0

(Doesn't this rule out your theory?  If it's asserting the IRQ, we will
take an interrupt with this configuration?)

Uniprocessor, IO-APIC:

           CPU0       
  0:     654721    IO-APIC-edge  timer
  1:         15    IO-APIC-edge  i8042
  2:          0          XT-PIC  cascade
  4:          0    IO-APIC-edge  GDB-stub
  8:          1    IO-APIC-edge  rtc
 12:         55    IO-APIC-edge  i8042
 14:       2835    IO-APIC-edge  ide0
 15:         10    IO-APIC-edge  ide1
 19:         43   IO-APIC-level  ide2, ide3, ide4, ide5
 35:          0   IO-APIC-level  aic7xxx
 38:        296   IO-APIC-level  eth0
 58:        137   IO-APIC-level  aic7xxx
NMI:        668 
LOC:     654631 
ERR:          0
MIS:          0


I assume SMP/IO-APIC will do the same thing (takes too darn long
to go through them all).

Why should aic7xxx_old have this problem, and not aic7xxx?

Here's /proc/interrupts with aic7xxx, uniproc, IO-APIC:

           CPU0       
  0:      38650    IO-APIC-edge  timer
  1:         16    IO-APIC-edge  i8042
  2:          0          XT-PIC  cascade
  4:          0    IO-APIC-edge  GDB-stub
  8:          1    IO-APIC-edge  rtc
 12:         55    IO-APIC-edge  i8042
 14:       2726    IO-APIC-edge  ide0
 15:         10    IO-APIC-edge  ide1
 19:         43   IO-APIC-level  ide2, ide3, ide4, ide5
 35:        391   IO-APIC-level  aic7xxx
 38:        115   IO-APIC-level  eth0
 58:        284   IO-APIC-level  aic7xxx
NMI:         48 
LOC:      38516 
ERR:          0
MIS:          0

Just the same, only this time it's generating interrupts.
I don't think this is a mainboard problem.

The logs say:


scsi HBA driver <NULL> didn't set max_sectors, please fix the template
(scsi0) <Adaptec AIC-7892 Ultra 160/m SCSI host adapter> found at PCI 3/4/0
(scsi0) Wide Channel, SCSI ID=7, 32/255 SCBs
(scsi0) Downloading sequencer code... 396 instructions downloaded
(scsi1) <Adaptec AIC-7880 Ultra SCSI host adapter> found at PCI 0/10/0
(scsi1) Wide Channel, SCSI ID=7, 16/255 SCBs
(scsi1) Downloading sequencer code... 436 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7892 Ultra 160/m SCSI host adapter>
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 0 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 1 lun 0

Maybe the 7892 sequencer code is bust??
