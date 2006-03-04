From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 17:47:04 -0800
Message-ID: <1141436824.8649.32.camel@localhost.localdomain>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
	 <20060302231323.GA12869@us.ibm.com>
	 <1141360482.3238.91.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:56501 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751591AbWCDBrj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 20:47:39 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k241ldYD032028
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 20:47:39 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k241oPqb180676
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 18:50:25 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k241lcWM029378
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 18:47:38 -0700
In-Reply-To: <1141360482.3238.91.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Thu, 2006-03-02 at 22:34 -0600, James Bottomley wrote:
> On Thu, 2006-03-02 at 15:13 -0800, Mike Anderson wrote:
> > The issue also results in the device discovery not completing by the time
> > the module load completes resulting in the initrd not finding the boot
> > disk
> > http://bugzilla.kernel.org/show_bug.cgi?id=6045
> > 
> > I agree that we need a solution for this. Should the solution be in the
> > LLDDs.I thought previous comments was that we wanted this fixed outside
> > the kernel in user space. Though I have not seen any enabled support in
> > initrds or support in the initrd bins.
> > 
> > This appears to not only be an issue with aic94xx as it appears this could
> > happen with some of the fc transport LLDDs.
> 
I have been testing your series of patches (including the patch
mentioned in this email) on a x366 and there are some promising results.
However, on a reboot test (the machine is set to runlevel 6 and left to
reboot for 24hrs or until it dies) The race condition seen during device
discovery is still being observed (see boot dump below).  It took about
an hour for this result to be produced and at this point I have only
produced this scenario once.

At first glance of the dump it seems that the aic94xx driver is
finishing its initialization before the devices even have a chance of
being discovered (see line [  138.608199]).  I am looking into the
problem and hopefully will have some real answers soon.  If you have any
comments please let me know what you think.

> This is caused by two problems: one is the asynchronicity of the threads
> and the other is that the driver can finish loading before the threads
> finish.  I fixed both by moving the discovery thread over to the scsi
> work queue (so there's only one per host, so all discoveries are
> serialised) and by waiting for all work to be flushed before finishing
> module loading.
> 
> Of course, now there's the slight race of the hotplug events going to
> udev, but it's now no worse than any other driver.
> 
> I also pulled out a few more useless definitions.
> 
> James



Loading scsi_transport_sas_domain.ko module
Loading aic94xx.ko [  138.154516] aic94xx: Adaptec aic94xx SAS/SATA
driver version 1.0.2 loaded
module
[  138.162047] GSI 19 sharing vector 0xC1 and IRQ 19
[  138.167196] ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level,
low) -> IRQ 193
[  138.174942] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter,
device 0000:01:02.0
[  138.184840] aic94xx: BIOS present (1,0), 1074
[  138.189319] aic94xx: ue num:2, ue size:88
[  138.193733] aic94xx: 1Found FLASH(8) manuf:1, dev_id:0xda, sec_prot:0
[  138.218519] aic94xx: manuf sect SAS_ADDR 50000d1000018d80
[  138.224037] aic94xx: manuf sect PCBA SN
[  138.228075] aic94xx: ms: num_phy_desc: 8
[  138.232112] aic94xx: ms: phy0: ENEBLEABLE
[  138.236235] aic94xx: ms: phy1: ENEBLEABLE
[  138.240360] aic94xx: ms: phy2: ENEBLEABLE
[  138.244501] aic94xx: ms: phy3: ENEBLEABLE
[  138.248625] aic94xx: ms: phy4: ENEBLEABLE
[  138.252749] aic94xx: ms: phy5: ENEBLEABLE
[  138.256871] aic94xx: ms: phy6: ENEBLEABLE
[  138.260994] aic94xx: ms: phy7: ENEBLEABLE
[  138.265118] aic94xx: ms: max_phys:0x8, num_phys:0x8
[  138.270111] aic94xx: ms: enabled_phys:0xff
[  138.287234] aic94xx: ctrla: phy0: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.297229] aic94xx: ctrla: phy1: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.307225] aic94xx: ctrla: phy2: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.317221] aic94xx: ctrla: phy3: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.327217] aic94xx: ctrla: phy4: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.337214] aic94xx: ctrla: phy5: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.347212] aic94xx: ctrla: phy6: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.357208] aic94xx: ctrla: phy7: sas_addr: 50000d1000018d80, sas
rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  138.367208] aic94xx: max_scbs:512, max_ddbs:128
[  138.371862] aic94xx: setting phy0 addr to 50000d1000018d80
[  138.377479] aic94xx: setting phy1 addr to 50000d1000018d80
[  138.383087] aic94xx: setting phy2 addr to 50000d1000018d80
[  138.388692] aic94xx: setting phy3 addr to 50000d1000018d80
[  138.394294] aic94xx: setting phy4 addr to 50000d1000018d80
[  138.399900] aic94xx: setting phy5 addr to 50000d1000018d80
[  138.405509] aic94xx: setting phy6 addr to 50000d1000018d80
[  138.411109] aic94xx: setting phy7 addr to 50000d1000018d80
[  138.416759] aic94xx: num_edbs:21
[  138.420102] aic94xx: num_escbs:3
[  138.423454] aic94xx: using sequencer Razor_10a1
[  138.428102] aic94xx: downloading CSEQ...
[  138.432159] aic94xx: dma-ing 8192 bytes
[  138.439469] aic94xx: verified 8192 bytes, passed
[  138.444198] aic94xx: downloading LSEQs...
[  138.448338] aic94xx: dma-ing 14336 bytes
[  138.458265] aic94xx: LSEQ0 verified 14336 bytes, passed
[  138.469320] aic94xx: LSEQ1 verified 14336 bytes, passed
[  138.480371] aic94xx: LSEQ2 verified 14336 bytes, passed
[  138.491415] aic94xx: LSEQ3 verified 14336 bytes, passed
[  138.502459] aic94xx: LSEQ4 verified 14336 bytes, passed
[  138.513509] aic94xx: LSEQ5 verified 14336 bytes, passed
[  138.524556] aic94xx: LSEQ6 verified 14336 bytes, passed
[  138.535604] aic94xx: LSEQ7 verified 14336 bytes, passed
[  138.558108] aic94xx: max_scbs:446
[  138.561535] aic94xx: first_scb_site_no:0x20
[  138.565826] aic94xx: last_scb_site_no:0x1fe
[  138.570154] aic94xx: First SCB dma_handle: 0x7fd39000
[  138.575946] aic94xx: device 0000:01:02.0: SAS addr 50000d1000018d80,
PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1074
[  138.588147] aic94xx: posting 3 escbs
[  138.591850] aic94xx: escbs posted
[  138.595399] scsi0 : Adaptec AIC-9410W SAS/SATA Host Adapter
[  138.603526] aic94xx: posting 8 control phy scbs
[  138.608199] aic94xx: enabled phys
[  138.611662] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9,
proto:0xe
[  138.611674] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9,
proto:0xe
[  138.611677] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[  138.611679] aic94xx: SAS proto IDENTIFY:
[  138.611682] aic94xx: 00: 10 00 00 08
[  138.611684] aic94xx: 04: 00 00 00 00
[  138.611685] aic94xx: 08: 00 00 00 00
[  138.611687] aic94xx: 0c: 50 00 c5 00
[  138.611689] aic94xx: 10: 00 30 fd a9
[  138.611691] aic94xx: 14: 00 00 00 00
[  138.611692] aic94xx: 18: 00 00 00 00
[  138.611699] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[  138.611701] aic94xx: SAS proto IDENTIFY:
[  138.611702] aic94xx: 00: 10 00 00 08
[  138.611705] aic94xx: 04: 00 00 00 00
[  138.611717] sas: phy1: port event: PORTE_BYTES_DMAED
[  138.611730] aic94xx: 08: 00 00 00 00
[  138.611739] aic94xx: 0c: 50 00 c5 00
[  138.611746] sas: phy1 added to port0, phy_mask:0x2
[  138.611757] aic94xx: 10: 00 30 2c 89
[  138.611759] aic94xx: 14: 00 00 00 00
[  138.611761] aic94xx: 18: 00 00 00 00
[  138.611779] sas: phy2: port event: PORTE_BYTES_DMAED
[  138.611795] sas: phy2 added to port1, phy_mask:0x4
[  138.611800] sas: DOING DISCOVERY on port 0, pid:996
[  138.707456] aic94xx: control_phy_tasklet_complete: phy0: no device
present: oob_status:0x0
[  138.707468] aic94xx: control_phy_tasklet_complete: phy3: no device
present: oob_status:0x0
[  138.707478] aic94xx: control_phy_tasklet_complete: phy4: no device
present: oob_status:0x0
[  138.707488] aic94xx: control_phy_tasklet_complete: phy5: no device
present: oob_status:0x0
[  138.707499] aic94xx: control_phy_tasklet_complete: phy6: no device
present: oob_status:0x0
[  138.707509] aic94xx: control_phy_tasklet_complete: phy7: no device
present: oob_status:0x0
Creating root de[  138.856311] Kernel panic - not syncing: Attempted to
kill init!
vice


