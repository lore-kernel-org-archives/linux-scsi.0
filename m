From: "emmanuel\.fuste" <emmanuel.fuste@laposte.net>
Subject: Re: panic with AIC7xxx
Date: Tue, 10 Jan 2006 22:41:08 +0100
Message-ID: <ISWC8K$B14D076AABEAA715E4BC889EAAA17D8B@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:37038 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932362AbWAJVm5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 16:42:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk <bunk@stusta.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Somme good and somme bad news :

> Hello,
> > > I recently made the switch from 2.4.26 to 2.6.13 and
> 2.6.14rc5 on my old
> > > dual 586mmx 233mhz.
> >=20
> > are your problems still present in 2.6.15?
> >=20
> > > I've got many problems with SMP on 2.6.13 (bad irq
> balancing/routing
> > > very bad performance on IDE and SCSI) but I tried to use
> the long
> > > awaited CDRW support.
=2E...
> > --=20
>=20
> I was waiting the merge of the patch serie from Hannes
> Reinecke <hare () suse ! de>, because of the sequencer fixes.
> I did'nt try this patch serie myself because the sequencer
> fixes one ([PATCH 5/6]] never reach lkml or linux-scsi.
>=20
> I will compile a clean 2.6.15 today and give it a try this
> evening.

So, good news, kernel boot and raw hardisk perfs (hdparm -t)
are event a little better.

Bad news :=20
- irq balancing/routing is one more time broken
rafale:~# cat /proc/interrupts=20
           CPU0       CPU1      =20
  0:     209712        167    IO-APIC-edge  timer
  1:        861         10    IO-APIC-edge  i8042
  2:          0          0          XT-PIC  cascade
  5:          0          0    IO-APIC-edge  SoundBlaster
  7:          1          2    IO-APIC-edge  parport0
  8:          3          1    IO-APIC-edge  rtc
 12:      17770          3    IO-APIC-edge  i8042
145:       2362          1   IO-APIC-level  eth0
161:      24282          1   IO-APIC-level  aic7xxx, uhci_hcd:usb1
NMI:          0          0=20
LOC:     209769     209768=20
ERR:          0
MIS:          0

- when I try to format my cdrw with cdrwtool -d /dev/sr0 -q,
the red led of the scsi bus activity ligth on, scsi bus lock
(I could switch console and try to log in but without succes
since hdd could not be reach), all without any message on the
console and few seconds later, the machine is killed with a
kernel panic : "Fatal exception in Interrupt" in=20
ahc_handle_seqint +0x371/0x1055 [aic7xxx]
If you want, I could send you a screen-shot of the panic taken
with my phone tomorow (I need a windows computer to get the
picture out of my phone).

Regards,
Emmanuel.

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
