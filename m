From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 09 Mar 2006 09:06:09 -0800
Message-ID: <1141923969.8649.108.camel@localhost.localdomain>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
	 <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
	 <20060306193555.GA2316@us.ibm.com>
	 <1141674628.3167.31.camel@mulgrave.il.steeleye.com>
	 <1141692292.8649.75.camel@localhost.localdomain>
	 <1141830925.3194.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:26317 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750721AbWCIRHW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 12:07:22 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k29H7Gk3011383
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 12:07:16 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k29HA6qe159820
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 10:10:06 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k29H74N6021917
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 10:07:04 -0700
In-Reply-To: <1141830925.3194.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-03-08 at 09:15 -0600, James Bottomley wrote:
> On Mon, 2006-03-06 at 16:44 -0800, Alexis Bruemmer wrote:
> > Well the problems I have seen when testing your tree, as well as the
> > original aic94xx/sas_class tree, is that the aic94xx driver enables phys
> > before the upper level sas layer has discover all phys and ports.
> > (again please see the boot dump I posted on Friday). 
> 
> Actually, this code is a much more complex way of doing what I just did
> with the work queues.  The only difference is this:
> 
> > +	wait_for_completion(&asd_ha->sas_ha.discover_phy);
> > +
> >  	ASD_DPRINTK("enabled phys\n");
> 
> Which shows that the current scsi_flush_work() is in the wrong place.
> If you move it out of sas_init.c and into aic94xx_init.c at this place,
> I think you'll find everything now works for you.

I tried your suggestion and moved the scsi_flush_work() from sas_init.c
to aic94xx_init.c and, unfortunately the discovery race condition still
existed with this change (see dump below).  This makes sense because
where we are flushing the work queue we cannot guarantee that any work
actually exits there yet.

I realize that the patch I posted on Monday is a complex way of solving
a seemingly simple problem, and that there is possibly a simpler way,
but for now it does solve the race condition problem that we are seeing
during phy/port/device discovery.  


Alexis


Loading scsi_transport_sas_domain.ko module
Loading aic94xx.ko [  165.595181] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
module
[  165.602939] GSI 19 sharing vector 0xC1 and IRQ 19
[  165.608073] ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 193
[  165.615831] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
[  165.625680] aic94xx: BIOS present (1,0), 1074
[  165.630159] aic94xx: ue num:2, ue size:88
[  165.634568] aic94xx: 1Found FLASH(8) manuf:1, dev_id:0xda, sec_prot:0
[  165.659348] aic94xx: manuf sect SAS_ADDR 50000d1000018d80
[  165.664857] aic94xx: manuf sect PCBA SN
[  165.668885] aic94xx: ms: num_phy_desc: 8
[  165.672912] aic94xx: ms: phy0: ENEBLEABLE
[  165.677029] aic94xx: ms: phy1: ENEBLEABLE
[  165.681151] aic94xx: ms: phy2: ENEBLEABLE
[  165.685267] aic94xx: ms: phy3: ENEBLEABLE
[  165.689391] aic94xx: ms: phy4: ENEBLEABLE
[  165.693506] aic94xx: ms: phy5: ENEBLEABLE
[  165.697622] aic94xx: ms: phy6: ENEBLEABLE
[  165.701737] aic94xx: ms: phy7: ENEBLEABLE
[  165.705851] aic94xx: ms: max_phys:0x8, num_phys:0x8
[  165.710842] aic94xx: ms: enabled_phys:0xff
[  165.727966] aic94xx: ctrla: phy0: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.737956] aic94xx: ctrla: phy1: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.747951] aic94xx: ctrla: phy2: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.757939] aic94xx: ctrla: phy3: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.767935] aic94xx: ctrla: phy4: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.777932] aic94xx: ctrla: phy5: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.787928] aic94xx: ctrla: phy6: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.797914] aic94xx: ctrla: phy7: sas_addr: 50000d1000018d80, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[  165.807906] aic94xx: max_scbs:512, max_ddbs:128
[  165.812559] aic94xx: setting phy0 addr to 50000d1000018d80
[  165.818160] aic94xx: setting phy1 addr to 50000d1000018d80
[  165.823814] aic94xx: setting phy2 addr to 50000d1000018d80
[  165.829411] aic94xx: setting phy3 addr to 50000d1000018d80
[  165.835009] aic94xx: setting phy4 addr to 50000d1000018d80
[  165.840613] aic94xx: setting phy5 addr to 50000d1000018d80
[  165.846217] aic94xx: setting phy6 addr to 50000d1000018d80
[  165.851823] aic94xx: setting phy7 addr to 50000d1000018d80
[  165.857479] aic94xx: num_edbs:21
[  165.860818] aic94xx: num_escbs:3
[  165.864159] aic94xx: using sequencer Razor_10a1
[  165.868797] aic94xx: downloading CSEQ...
[  165.872855] aic94xx: dma-ing 8192 bytes
[  165.880160] aic94xx: verified 8192 bytes, passed
[  165.884892] aic94xx: downloading LSEQs...
[  165.889033] aic94xx: dma-ing 14336 bytes
[  165.898950] aic94xx: LSEQ0 verified 14336 bytes, passed
[  165.910005] aic94xx: LSEQ1 verified 14336 bytes, passed
[  165.921057] aic94xx: LSEQ2 verified 14336 bytes, passed
[  165.932107] aic94xx: LSEQ3 verified 14336 bytes, passed
[  165.943151] aic94xx: LSEQ4 verified 14336 bytes, passed
[  165.954197] aic94xx: LSEQ5 verified 14336 bytes, passed
[  165.965246] aic94xx: LSEQ6 verified 14336 bytes, passed
[  165.976293] aic94xx: LSEQ7 verified 14336 bytes, passed
[  165.998802] aic94xx: max_scbs:446
[  166.002228] aic94xx: first_scb_site_no:0x20
[  166.006521] aic94xx: last_scb_site_no:0x1fe
[  166.010848] aic94xx: First SCB dma_handle: 0x37d85000
[  166.016644] aic94xx: device 0000:01:02.0: SAS addr 50000d1000018d80, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1074
[  166.028824] aic94xx: posting 3 escbs
[  166.032506] aic94xx: escbs posted
[  166.036032] scsi0 : Adaptec AIC-9410W SAS/SATA Host Adapter
[  166.044774] aic94xx: posting 8 control phy scbs
[  166.049422] aic94xx: enabled phys
[  166.051955] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe[  166.051971] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe[  166.051976] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[  166.051979] aic94xx: SAS proto IDENTIFY:
[  166.051981] aic94xx: 00: 10 00 00 08
[  166.051983] aic94xx: 04: 00 00 00 00
[  166.051985] aic94xx: 08: 00 00 00 00
[  166.051987] aic94xx: 0c: 50 00 c5 00
[  166.051988] aic94xx: 10: 00 30 fd a9
[  166.051990] aic94xx: 14: 00 00 00 00
[  166.051992] aic94xx: 18: 00 00 00 00
[  166.051998] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[  166.052001] aic94xx: SAS proto IDENTIFY:
[  166.052003] aic94xx: 00: 10 00 00 08
[  166.052004] aic94xx: 04: 00 00 00 00
[  166.052006] aic94xx: 08: 00 00 00 00
[  166.052008] aic94xx: 0c: 50 00 c5 00
[  166.052010] aic94xx: 10: 00 30 2c 89
[  166.052011] aic94xx: 14: 00 00 00 00
[  166.052013] aic94xx: 18: 00 00 00 00
[  166.052022] sas: phy1: port event: PORTE_BYTES_DMAED
[  166.052026] sas: phy1 added to port0, phy_mask:0x2
[  166.052046] sas: phy2: port event: PORTE_BYTES_DMAED
[  166.052064] sas: phy2 added to port1, phy_mask:0x4
[  166.052068] sas: DOING DISCOVERY on port 0, pid:996
[  166.059523] aic94xx: control_phy_tasklet_complete: phy0: no device present: oob_status:0x0
[  166.059557] aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
[  166.059568] aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
[  166.059579] aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
[  166.059589] aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
[  166.059600] aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
Creating root de[  166.302074] Kernel panic - not syncing: Attempted to kill init!
vice
mkrootdev:[  166.309176]   label / not fou

> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

