From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Fri, 23 Mar 2007 00:00:42 +0100
Message-ID: <46030A9A.2060604@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de> <4602EED5.5070503@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752702AbXCVXAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 19:00:44 -0400
In-Reply-To: <4602EED5.5070503@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

[   48.848796] Loading iSCSI transport class v2.0-724.
[   48.854066] iscsi: registered transport (tcp)
[   48.858479] ahc_linux_pci_init
[   48.861676] ahc_linux_pci_dev_probe
[   48.865208] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ
 17
[   48.872628] ahc_pci_config
[   48.875335] set_power_state
[   48.878126] map_registers
[   48.880744] ahc_pci_map_registers enter
[   48.884571] .read_config
[   48.887106] .reserve_mem
[   48.889647] .write_config_iferr0
[   48.892871] .test_registers_iferr0
[   48.896265] ahc_pci_test_register_access enter
[   48.900699] .read_config
[   48.903235] .write_config_noserr
[   48.906462] .hcnctrl
[   48.908648] .hcntrl pause cmd
[   48.911616] .I will pause 4E4 if missing errh before :/

ok, as expected, the wait for pause ended loop, (someone with the specs pls say max HZ 
for a) wait_interruptible(_timeout)() here.
yes, I know that case must not happen and it should bug cause 
the pci config is messed up already, but generally such loops are 
surely inacceptable in such a kernel thread.

will dump the config data to here, maybe its readable to the aic devs. 

then disable test and will let it bug somewhere further where the 
cause can possibly be easier seen.
