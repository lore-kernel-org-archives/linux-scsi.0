From: Douglas Gilbert <dougg@torque.net>
Subject: aic94xx driver woes
Date: Sat, 31 Mar 2007 12:48:51 -0400
Message-ID: <460E90F3.9070601@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXCaQuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2007 12:50:46 -0400
Received: from ip-229.82.126.206.dsl-cust.ca.inter.net ([206.126.82.229] helo=[192.168.48.87])
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1HXgmr-0003ZK-CN
	for linux-scsi@vger.kernel.org; Sat, 31 Mar 2007 17:50:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Every 3 months or so I complain about the aic94xx
SAS low level driver. Here I go again. Same old story
so most could just stop reading here.

-----------------------------------------------

I have been asked to look at SMP (SAS Management
Protocol) commands going via the bsg driver to
the SAS transport and onto the aic94xx driver.

My SAS hardware external to my HBAs (i.e. SAS+SATA disks
and some expanders) works just fine if it is connected
to:
  - a LSI Fusion HBA (I have two in the 34xx family)
  - an adaptec 48300 HBA if and only if it is running
    the _real_ Luben Tuikov aic94xx driver (or a W2K
    driver)

Unfortunately to run the above test I need to forego
Luben's driver and use the mainline kernel version.
[The mainline version also has Luben's name on it but
I think that should be changed as others have hacked it.]

So what happens when I run the aic94xx driver found
in linux-2.6-block.git bsg branch which says it is
lk 2.6.21-rc5? See below. Basically it times out
sending a REPORT GENERAL SMP request to an expander
(probably the first SMP request sent) and that is it.
No disks or expanders are found. However the 48300
card's POST scan sees everything (as does the W2K driver).

So that is almost 12 months that I have been reporting
this driver as broken. Is it just me or my hardware?


Doug Gilbert

Edited highlights from my log:

aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:03:04.0
scsi5 : aic94xx
aic94xx: BIOS present (1,1), 1822
aic94xx: ue num:4, ue size:88
aic94xx: manuf sect SAS_ADDR 50000d10002dc000
aic94xx: manuf sect PCBA SN 0BB0C54904WZ
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
aic94xx: ctrla: phy0: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 50000d10002dc000, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 50000d10002dc000
aic94xx: setting phy1 addr to 50000d10002dc000
aic94xx: setting phy2 addr to 50000d10002dc000
aic94xx: setting phy3 addr to 50000d10002dc000
aic94xx: setting phy4 addr to 50000d10002dc000
aic94xx: setting phy5 addr to 50000d10002dc000
aic94xx: setting phy6 addr to 50000d10002dc000
aic94xx: setting phy7 addr to 50000d10002dc000
aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)
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
aic94xx: First SCB dma_handle: 0x35189000
aic94xx: device 0000:03:04.0: SAS addr 50000d10002dc000, PCBA SN 0BB0C54904WZ, 8 phys, 8 enabled phys, flash present, BIOS build 1822
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 00 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 06 05 b0
aic94xx: 10: 00 00 33 ef
aic94xx: 14: 06 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
sas: phy0 added to port0, phy_mask:0x1
sas: DOING DISCOVERY on port 0, pid:2100
aic94xx: scb:0x80 timed out
sas last message repeated 6 times
sas: smp task timed out or aborted
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task 0xf4568ea8 aborted, res: 0x5
sas: SMP task aborted and not done
sas: RG to ex 500605b0000033ef failed:0xffffff06
sas: DONE DISCOVERY on port 0, pid:2100, result:-250


