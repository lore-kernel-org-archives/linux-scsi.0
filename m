From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [BUGFIXES 0/2] gdth: fix 2.6.24 driver breakage
Date: Tue, 12 Feb 2008 19:30:16 +0200
Message-ID: <47B1D7A8.8010108@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38230 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbYBLRbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 12:31:45 -0500
In-Reply-To: <47A19E26.30107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.o>
Cc: linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Thu, Jan 31 2008 at 12:08 +0200, Boaz Harrosh <bharrosh@panasas.com>=
 wrote:
> On Wed, Jan 30 2008 at 21:47 +0200, Sven K=F6hler <skoehler@upb.de> w=
rote:
>> Hi,
>>
>> so i have upgraded a system to kernel 2.6.24. After that, it failed =
to=20
>> boot with the usual message telling, that the rootfs on device /dev/=
sda1=20
>>   cannot be mounted (a raid1 run by the controller below).
>>
>> With 2.6.23.12, everything is working fine.
>>
>> # lspci -v:
>>
>> 03:01.0 RAID bus controller: Intel Corporation RAID Controller
>>          Subsystem: Intel Corporation Unknown device 01db
>>          Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
>>          Memory at ddffc000 (32-bit, prefetchable) [size=3D16K]
>>          [virtual] Expansion ROM at deef0000 [disabled] [size=3D32K]
>>          Capabilities: [80] Power Management version 2
>>
>> # GDT-related dmesg output (2.6.23.12):
>>
>> GDT-HA: Storage RAID Controller Driver. Version: 3.05
>> ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 24 (level, low) -> IRQ 17
>> GDT-HA: Found 1 PCI Storage RAID Controllers
>> Configuring GDT-PCI HA at 3/1 IRQ 17
>> GDT-HA 0: Name: SRCU42L
>> scsi0 : SRCU42L
>> scsi 0:0:0:0: Direct-Access     Intel    Host Drive  #00       PQ: 0=
 ANSI: 2
>> scsi 0:2:6:0: Processor         ESG-SHV  SCA HSBP M29     1.06 PQ: 0=
 ANSI: 2
>> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
>> sd 0:0:0:0: [sda] Assuming Write Enabled
>> sd 0:0:0:0: [sda] Assuming drive cache: write through
>> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
>> sd 0:0:0:0: [sda] Assuming Write Enabled
>> sd 0:0:0:0: [sda] Assuming drive cache: write through
>>   sda: sda1 sda2 < sda5 >
>> sd 0:0:0:0: [sda] Attached SCSI disk
>>
>> # cat /boot/config-2.6.24 |grep GDT
>>
>> CONFIG_SCSI_GDTH=3Dy
>>
>>
>>
>>
>> Any ideas?
>>
>> http://www.kernel.org/diff/diffview.cgi?file=3D%2Fpub%2Flinux%2Fkern=
el%2Fv2.6%2Fpatch-2.6.24.bz2=20
>> show huge drivers/scsi/gdth* related changes.
>>
>> Can't test at the moment. System went production.
>>
>>
>> Regards,
>>    Sven
>>
>=20
> Hi Sven!
<snip>

With the kind help of:
    Joerg Dorchain: <joerg@dorchain.net>
    Jon Chelton <jchelton@ffpglobal.com>
    Stefan Priebe <s.priebe@allied-internet.ag>

Which let me take up their machines their effort and their time
I hope I'm able to fix the gdth driver for the 2.6.24 kernel and forwar=
d.
Actually it was a simple miss by Christoph, but with my inexperience
it took me a bisection and a while to get it.

Both Joerg, and Stefan where able to boot with these patches and work
on their machine. Jon Chelton's disks array should also work, we're tes=
ting.

Submitted 2 patches. They should also be included after some testing
into the 2.6.24.x stable releases. (Will be posted after some more test=
ing)

[PATCH 1/2] gdth: scan for scsi devices
 simple but must fatal.

[PATCH 2/2] gdth: bugfix for the Timer at exit crash
  James please inspect and comment on this patch. It was not yet tested
  by the original bug submitter.

In the original gdth series Christoph has forgotten to add the call to
scsi_scan_host(). Jeff alternative patches did do the scan. After every=
thing
was probed, the code would loop on all found cards and scan. However I =
like
to individually scan at each probe, because I think this way it is more=
 ready
for the hot-plug API where the discovery is done outside of the driver,=
 and the
probe is called on single host at a time. Is that right? please comment=
=2E

Test away.

Meany thanks to Joerg, Jon && Stefan, Cheers.

Boaz

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
