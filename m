From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: aic94xx: failing on high load
Date: Mon, 14 Jan 2008 22:03:05 +0100
Message-ID: <20080114210305.GD25714@suse.cz>
References: <20080114144916.GD23867@alaris.suse.cz> <20080114194513.GC7118@tree.beaverton.ibm.com> <1200341026.3159.62.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51200 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbYANVD0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 16:03:26 -0500
Content-Disposition: inline
In-Reply-To: <1200341026.3159.62.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org, hare@suse.de, Peter Bogdanovic <pbog@us.ibm.com>

On Mon, Jan 14, 2008 at 02:03:45PM -0600, James Bottomley wrote:
> 
> On Mon, 2008-01-14 at 11:45 -0800, Darrick J. Wong wrote:
> > On Mon, Jan 14, 2008 at 03:49:16PM +0100, Jan Sembera wrote:
> > > Hi,
> > > 
> > > 	we have array of 16 SAS disks connected to Adaptec controllers
> > > ...
> > > this elsewhere and I was recommended to send it to linux-scsi.
> > 
> > Hmm... I think Peter Bogdanovic was hitting this error recently (cc'd).
> > There are a lot of PRIMITIVE_RECVD messages in the log, which make me
> > wonder if the expander is being flaky or something?  The commands that
> > start timing out under heavy load followed by the repeated broadcasts
> > might be indicative of that, since the sequencer firmware and the kernel
> > driver are up to date.  Unfortunately, I don't have any LSI expanders...
> 
> I do, and actually, I've seen behaviour like this, except on a SATAPI
> DVD not a disk.  What seems to happen is that the expander hangs up on
> the device and I can't recover it except by power cycling the expander
> (other devices on the expander continue to work normally).

It'd be rather hard to power cycle the 16-drive backplane with dual
LSISASx28 expanders in this server without bringing the rest of the
system down. 

If the backplane was as flaky as you suggest, I doubt anyone could use
these machines in production, even under other OSs ...

> The problem is (if it is the same problem) there isn't any defined error
> recovery from this ... the standards don't contain an expander reset,
> and the expander isn't responding to the phy reset (either hard or
> soft). So I'm not sure what can be done at this point.

In our last test run, we've received some more errors, but this time the
system recovered and actually finished the test load:

aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:04:02.0
scsi3 : aic94xx
OCM is not initialized by BIOS,reinitialize it and ignore it, current IntrptStatusis 0x0
aic94xx: couldn't find BIOS_CHIM dir ent
aic94xx: couldn't read ocm(-2)
aic94xx: manuf sect SAS_ADDR 500304800003b820
aic94xx: manuf sect PCBA SN ORG
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ctrla: phy0: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500304800003b820, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 500304800003b820
aic94xx: setting phy1 addr to 500304800003b820
aic94xx: setting phy2 addr to 500304800003b820
aic94xx: setting phy3 addr to 500304800003b820
aic94xx: setting phy4 addr to 500304800003b820
aic94xx: setting phy5 addr to 500304800003b820
aic94xx: setting phy6 addr to 500304800003b820
aic94xx: setting phy7 addr to 500304800003b820
aic94xx: num_edbs:21
aic94xx: num_escbs:3
scsi 2:0:0:0: Direct-Access     PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
sd 2:0:0:0: [sdc] Attached SCSI removable disk
aic94xx: Found sequencer Firmware version 1.1 (V30)
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x31cbe4000
aic94xx: device 0000:04:02.0: SAS addr 500304800003b820, PCBA SN ORG, 8 phys, 8 enabled phys, flash present, BIOS not present0
aic94xx: posting 3 escbs
aic94xx: escbs posted
sd 2:0:0:0: Attached scsi generic sg2 type 0
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 03 04 80
aic94xx: 10: 00 01 c4 7f
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 03 04 80
aic94xx: 10: 00 01 c4 7f
aic94xx: 14: 01 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x3 for phy1
aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 03 04 80
aic94xx: 10: 00 01 c4 7f
aic94xx: 14: 02 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x7 for phy2
aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 03 04 80
aic94xx: 10: 00 01 c4 7f
aic94xx: 14: 03 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0xf for phy3
sas: phy0 added to port0, phy_mask:0x1
sas: phy1 matched wide port0
sas: phy1 added to port0, phy_mask:0x3
sas: phy2 matched wide port0
sas: phy2 added to port0, phy_mask:0x7
sas: phy3 matched wide port0
sas: phy3 added to port0, phy_mask:0xf
sas: DOING DISCOVERY on port 0, pid:2358
aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
sas: ex 500304800001c47f phy00:S attached: 500304800003b820
sas: ex 500304800001c47f phy01:S attached: 500304800003b820
sas: ex 500304800001c47f phy02:S attached: 500304800003b820
sas: ex 500304800001c47f phy03:S attached: 500304800003b820
usb-storage: device scan complete
sas: ex 500304800001c47f phy04:T attached: 0000000000000000
sas: ex 500304800001c47f phy05:T attached: 0000000000000000
sas: ex 500304800001c47f phy06:T attached: 0000000000000000
sas: ex 500304800001c47f phy07:T attached: 0000000000000000
sas: ex 500304800001c47f phy08:D attached: 5000c5000647cca5
sas: ex 500304800001c47f phy09:D attached: 5000c50006481869
sas: ex 500304800001c47f phy10:D attached: 5000c5000647e515
sas: ex 500304800001c47f phy11:D attached: 5000c5000647eecd
sas: ex 500304800001c47f phy12:D attached: 5000c5000647e0f1
sas: ex 500304800001c47f phy13:D attached: 5000c5000647e449
sas: ex 500304800001c47f phy14:D attached: 5000c50006481ea9
sas: ex 500304800001c47f phy15:D attached: 5000c50006480629
sas: ex 500304800001c47f phy16:D attached: 5000c5000648048d
sas: ex 500304800001c47f phy17:D attached: 5000c5000647ca89
sas: ex 500304800001c47f phy18:D attached: 5000c5000647e471
sas: ex 500304800001c47f phy19:D attached: 5000c50006480289
sas: ex 500304800001c47f phy20:D attached: 5000c5000647c10d
sas: ex 500304800001c47f phy21:D attached: 5000c500064811e5
sas: ex 500304800001c47f phy22:D attached: 5000c5000647cf25
sas: ex 500304800001c47f phy23:D attached: 5000c5000647cbcd
sas: ex 500304800001c47f phy24:T attached: 0000000000000000
sas: ex 500304800001c47f phy25:T attached: 0000000000000000
sas: ex 500304800001c47f phy26:T attached: 0000000000000000
sas: ex 500304800001c47f phy27:T attached: 0000000000000000
sas: ex 500304800001c47f phy28:D attached: 500304800001c47d
sas: ex 500304800001c47f phy29:D attached: 500304800001c47e
scsi 3:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: b3 00 10 08
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:0:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: b3 00 10 08
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
scsi 3:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:1:0: [sde] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:1:0: [sde] Write Protect is off
sd 3:0:1:0: [sde] Mode Sense: b3 00 10 08
sd 3:0:1:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:1:0: [sde] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:1:0: [sde] Write Protect is off
sd 3:0:1:0: [sde] Mode Sense: b3 00 10 08
sd 3:0:1:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sde: sde1
sd 3:0:1:0: [sde] Attached SCSI disk
sd 3:0:1:0: Attached scsi generic sg4 type 0
scsi 3:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:2:0: [sdf] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:2:0: [sdf] Write Protect is off
sd 3:0:2:0: [sdf] Mode Sense: b3 00 10 08
sd 3:0:2:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:2:0: [sdf] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:2:0: [sdf] Write Protect is off
sd 3:0:2:0: [sdf] Mode Sense: b3 00 10 08
sd 3:0:2:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdf: sdf1
sd 3:0:2:0: [sdf] Attached SCSI disk
sd 3:0:2:0: Attached scsi generic sg5 type 0
scsi 3:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:3:0: [sdg] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:3:0: [sdg] Write Protect is off
sd 3:0:3:0: [sdg] Mode Sense: b3 00 10 08
sd 3:0:3:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:3:0: [sdg] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:3:0: [sdg] Write Protect is off
sd 3:0:3:0: [sdg] Mode Sense: b3 00 10 08
sd 3:0:3:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdg: sdg1
sd 3:0:3:0: [sdg] Attached SCSI disk
sd 3:0:3:0: Attached scsi generic sg6 type 0
scsi 3:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:4:0: [sdh] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:4:0: [sdh] Write Protect is off
sd 3:0:4:0: [sdh] Mode Sense: b3 00 10 08
sd 3:0:4:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:4:0: [sdh] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:4:0: [sdh] Write Protect is off
sd 3:0:4:0: [sdh] Mode Sense: b3 00 10 08
sd 3:0:4:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdh: sdh1
sd 3:0:4:0: [sdh] Attached SCSI disk
sd 3:0:4:0: Attached scsi generic sg7 type 0
scsi 3:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:5:0: [sdi] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:5:0: [sdi] Write Protect is off
sd 3:0:5:0: [sdi] Mode Sense: b3 00 10 08
sd 3:0:5:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:5:0: [sdi] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:5:0: [sdi] Write Protect is off
sd 3:0:5:0: [sdi] Mode Sense: b3 00 10 08
sd 3:0:5:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdi: sdi1
sd 3:0:5:0: [sdi] Attached SCSI disk
sd 3:0:5:0: Attached scsi generic sg8 type 0
scsi 3:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:6:0: [sdj] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:6:0: [sdj] Write Protect is off
sd 3:0:6:0: [sdj] Mode Sense: b3 00 10 08
sd 3:0:6:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:6:0: [sdj] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:6:0: [sdj] Write Protect is off
sd 3:0:6:0: [sdj] Mode Sense: b3 00 10 08
sd 3:0:6:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdj: sdj1
sd 3:0:6:0: [sdj] Attached SCSI disk
sd 3:0:6:0: Attached scsi generic sg9 type 0
scsi 3:0:7:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:7:0: [sdk] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:7:0: [sdk] Write Protect is off
sd 3:0:7:0: [sdk] Mode Sense: b3 00 10 08
sd 3:0:7:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:7:0: [sdk] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:7:0: [sdk] Write Protect is off
sd 3:0:7:0: [sdk] Mode Sense: b3 00 10 08
sd 3:0:7:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdk: sdk1 sdk2 sdk3 sdk4
sd 3:0:7:0: [sdk] Attached SCSI disk
sd 3:0:7:0: Attached scsi generic sg10 type 0
scsi 3:0:8:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:8:0: [sdl] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:8:0: [sdl] Write Protect is off
sd 3:0:8:0: [sdl] Mode Sense: b3 00 10 08
sd 3:0:8:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:8:0: [sdl] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:8:0: [sdl] Write Protect is off
sd 3:0:8:0: [sdl] Mode Sense: b3 00 10 08
sd 3:0:8:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdl: sdl1
sd 3:0:8:0: [sdl] Attached SCSI disk
sd 3:0:8:0: Attached scsi generic sg11 type 0
scsi 3:0:9:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:9:0: [sdm] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:9:0: [sdm] Write Protect is off
sd 3:0:9:0: [sdm] Mode Sense: b3 00 10 08
sd 3:0:9:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:9:0: [sdm] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:9:0: [sdm] Write Protect is off
sd 3:0:9:0: [sdm] Mode Sense: b3 00 10 08
sd 3:0:9:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdm: sdm1
sd 3:0:9:0: [sdm] Attached SCSI disk
sd 3:0:9:0: Attached scsi generic sg12 type 0
scsi 3:0:10:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:10:0: [sdn] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:10:0: [sdn] Write Protect is off
sd 3:0:10:0: [sdn] Mode Sense: b3 00 10 08
sd 3:0:10:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:10:0: [sdn] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:10:0: [sdn] Write Protect is off
sd 3:0:10:0: [sdn] Mode Sense: b3 00 10 08
sd 3:0:10:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdn: sdn1
sd 3:0:10:0: [sdn] Attached SCSI disk
sd 3:0:10:0: Attached scsi generic sg13 type 0
scsi 3:0:11:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:11:0: [sdo] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:11:0: [sdo] Write Protect is off
sd 3:0:11:0: [sdo] Mode Sense: b3 00 10 08
sd 3:0:11:0: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:11:0: [sdo] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:11:0: [sdo] Write Protect is off
sd 3:0:11:0: [sdo] Mode Sense: b3 00 10 08
sd 3:0:11:0: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdo: sdo1
sd 3:0:11:0: [sdo] Attached SCSI disk
sd 3:0:11:0: Attached scsi generic sg14 type 0
scsi 3:0:12:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:12:0: [sdp] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:12:0: [sdp] Write Protect is off
sd 3:0:12:0: [sdp] Mode Sense: b3 00 10 08
sd 3:0:12:0: [sdp] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:12:0: [sdp] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:12:0: [sdp] Write Protect is off
sd 3:0:12:0: [sdp] Mode Sense: b3 00 10 08
sd 3:0:12:0: [sdp] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdp: sdp1
sd 3:0:12:0: [sdp] Attached SCSI disk
sd 3:0:12:0: Attached scsi generic sg15 type 0
scsi 3:0:13:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:13:0: [sdq] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:13:0: [sdq] Write Protect is off
sd 3:0:13:0: [sdq] Mode Sense: b3 00 10 08
sd 3:0:13:0: [sdq] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:13:0: [sdq] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:13:0: [sdq] Write Protect is off
sd 3:0:13:0: [sdq] Mode Sense: b3 00 10 08
sd 3:0:13:0: [sdq] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdq: sdq1
sd 3:0:13:0: [sdq] Attached SCSI disk
sd 3:0:13:0: Attached scsi generic sg16 type 0
scsi 3:0:14:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:14:0: [sdr] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:14:0: [sdr] Write Protect is off
sd 3:0:14:0: [sdr] Mode Sense: b3 00 10 08
sd 3:0:14:0: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:14:0: [sdr] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:14:0: [sdr] Write Protect is off
sd 3:0:14:0: [sdr] Mode Sense: b3 00 10 08
sd 3:0:14:0: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdr: sdr1
sd 3:0:14:0: [sdr] Attached SCSI disk
sd 3:0:14:0: Attached scsi generic sg17 type 0
scsi 3:0:15:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sd 3:0:15:0: [sds] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:15:0: [sds] Write Protect is off
sd 3:0:15:0: [sds] Mode Sense: b3 00 10 08
sd 3:0:15:0: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:15:0: [sds] 143374744 512-byte hardware sectors (73408 MB)
sd 3:0:15:0: [sds] Write Protect is off
sd 3:0:15:0: [sds] Mode Sense: b3 00 10 08
sd 3:0:15:0: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sds: sds1
sd 3:0:15:0: [sds] Attached SCSI disk
sd 3:0:15:0: Attached scsi generic sg18 type 0
scsi 3:0:16:0: Enclosure         LSILOGIC SASX28 A.0          9 PQ: 0 ANSI: 3
scsi 3:0:16:0: Attached scsi generic sg19 type 13
sas: DONE DISCOVERY on port 0, pid:2358, result:0

/* test load started here */

aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
aic94xx: escb_tasklet_complete: Can't find task (tc=47) to abort!
sas: command 0xffff810307ebc180, task 0xffff810307f98e00, timed out: EH_NOT_HANDLED
sas: command 0xffff810307c86540, task 0xffff810309faf240, timed out: EH_NOT_HANDLED
sas: command 0xffff810307f3ebc0, task 0xffff8103079eed40, timed out: EH_NOT_HANDLED
sas: command 0xffff810319b46080, task 0xffff810307e1e7c0, timed out: EH_NOT_HANDLED
sas: command 0xffff810307f91cc0, task 0xffff810307ecb0c0, timed out: EH_NOT_HANDLED
sas: command 0xffff810307ea1480, task 0xffff810307ef91c0, timed out: EH_NOT_HANDLED
sas: command 0xffff8103087e1380, task 0xffff81031b7124c0, timed out: EH_NOT_HANDLED
sas: command 0xffff810307ebcdc0, task 0xffff810307ef9380, timed out: EH_NOT_HANDLED
sas: command 0xffff810307d52140, task 0xffff810318d981c0, timed out: EH_NOT_HANDLED
sas: command 0xffff81030875d300, task 0xffff81031e0147c0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff810307f98e00
sas: sas_scsi_find_task: aborting task 0xffff810307f98e00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810307f98e00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810307f98e00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810307f98e00 is done
sas: sas_eh_handle_sas_errors: task 0xffff810307f98e00 is done
sas: trying to find task 0xffff8103079eed40
sas: sas_scsi_find_task: aborting task 0xffff8103079eed40
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff8103079eed40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff8103079eed40 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff8103079eed40 is done
sas: sas_eh_handle_sas_errors: task 0xffff8103079eed40 is done
sas: trying to find task 0xffff810307e1e7c0
sas: sas_scsi_find_task: aborting task 0xffff810307e1e7c0
aic94xx: task 0xffff810309faf240 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810307e1e7c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810307e1e7c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810307e1e7c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff810307e1e7c0 is done
sas: trying to find task 0xffff810309faf240
sas: sas_scsi_find_task: aborting task 0xffff810309faf240
aic94xx: asd_abort_task: task 0xffff810309faf240 done
aic94xx: task 0xffff810309faf240 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810309faf240 is done
sas: sas_eh_handle_sas_errors: task 0xffff810309faf240 is done
sas: trying to find task 0xffff810307ef91c0
sas: sas_scsi_find_task: aborting task 0xffff810307ef91c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810307ef91c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810307ef91c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810307ef91c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff810307ef91c0 is done
sas: trying to find task 0xffff810307ecb0c0
sas: sas_scsi_find_task: aborting task 0xffff810307ecb0c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810307ecb0c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810307ecb0c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810307ecb0c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff810307ecb0c0 is done
sas: trying to find task 0xffff81031b7124c0
sas: sas_scsi_find_task: aborting task 0xffff81031b7124c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81031b7124c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81031b7124c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81031b7124c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81031b7124c0 is done
sas: trying to find task 0xffff810307ef9380
sas: sas_scsi_find_task: aborting task 0xffff810307ef9380
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810307ef9380 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810307ef9380 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810307ef9380 is done
sas: sas_eh_handle_sas_errors: task 0xffff810307ef9380 is done
sas: trying to find task 0xffff810318d981c0
sas: sas_scsi_find_task: aborting task 0xffff810318d981c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810318d981c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810318d981c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810318d981c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff810318d981c0 is done
sas: trying to find task 0xffff81031e0147c0
sas: sas_scsi_find_task: aborting task 0xffff81031e0147c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81031e0147c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81031e0147c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81031e0147c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81031e0147c0 is done
sas: --- Exit sas_scsi_recover_host

/* And finished here successfully */

-- 
Vojtech Pavlik
Director SuSE Labs
