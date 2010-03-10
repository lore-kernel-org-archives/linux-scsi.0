From: Keith Mannthey <kmannth@us.ibm.com>
Subject: lpfc driver loading is rebooting the box: 2.6.33 and above.
Date: Wed, 10 Mar 2010 13:29:08 -0800
Message-ID: <1268256548.7818.20.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46258 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0CJV3M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 16:29:12 -0500
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2ALIBOn028974
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2010 16:18:11 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2ALTBR9173056
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2010 16:29:11 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2ALTAh1025738
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2010 18:29:11 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: rlary@us.ibm.com, kmannth@us.ibm.com

I moved forwarded and a server started rebooting while loading the
kernel current kernels.=20

I isolated it to the lpfc driver.=20

Upsteam kernels tried so far:

3.6.34-rc1
3.4.33-git15=20

With these kernels I see the following when the driver loads:=20

"
=EF=BB=BF[ 276.643991] Emulex LightPulse Fibre Channel SCSI driver 8.3.=
9
[ 276.643996] Copyright(c) 2004-2009 Emulex. All rights reserved.
[ 276.644058] lpfc 0000:1a:00.0: PCI INT A -> GSI 30 (level, low) -> IR=
Q 30
[ 276.644067] lpfc 0000:1a:00.0: setting latency timer to 64
[ 276.645003] scsi5 : on PCI bus 1a device 00 irq 30
[ 277.480150] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 278.167137] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 278.167171] alloc irq_desc for 72 on node -1
[ 278.167174] alloc kstat_irqs on node -1
[ 278.167181] alloc irq_2_iommu on node -1
[ 278.167195] lpfc 0000:1a:00.0: irq 72 for MSI/MSI-X
[ 278.857352] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 279.547573] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 280.237779] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 280.927994] lpfc 0000:1a:00.0: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 280.927999] lpfc 0000:1a:00.0: 0:1477 Failed to set up hba
[ 281.028380] lpfc 0000:1a:00.0: PCI INT A disabled
[ 281.028411] alloc irq_desc for 37 on node -1
[ 281.028412] alloc kstat_irqs on node -1
[ 281.028416] alloc irq_2_iommu on node -1
[ 281.028422] lpfc 0000:1a:00.1: PCI INT B -> GSI 37 (level, low) -> IR=
Q 37
[ 281.028427] lpfc 0000:1a:00.1: setting latency timer to 64
[ 281.028939] scsi6 : on PCI bus 1a device 01 irq 37
[ 281.717949] lpfc 0000:1a:00.1: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 282.408169] lpfc 0000:1a:00.1: 0:0440 Adapter failed to init, READ_RE=
V has missing revision information.
[ 282.408210] lpfc 0000:1a:00.1: irq 72 for MSI/MSI-X
[ 283.098375] lpfc 0000:1a:00.1: 0:0440 Adapter failed to inelm
 "

A little while (less then 30 seconds) after loading the driver (rmmod
sometimes extends the life of the box). I get a hardware level pci faul=
t
and my box reboots.=20

My FW has been constant during this at 282a4 (current I believe) and
lspci reports the card as

1a:00.0 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Cha=
nnel Host Adapter (rev 02)
1a:00.1 Fibre Channel: Emulex Corporation Zephyr-X LightPulse Fibre Cha=
nnel Host Adapter (rev 02)

The system is a 2 socket Intel based server IBM x3550m2. =20


I forwarded ported some of the older versions of the driver 8.3.7 and
8.3.6 and that didn't not fix the issue, I am not convinced it is a
direct driver change that is causing this.  I also tried "lpfc_use_msi"
and =EF=BB=BF"lpfc_sli_mode" modules options without any affect on beha=
vior.=20

Then I started testing whole kernels, .config file remained as close as
possible. After some boots it seem 2.6.33-rc8 and before works. It is a
relatively small window of change and I am still digging but I thought =
I
would post and see if there were any ideas or suggestions out there.=20

Anyone seen anything like this? =20

Thanks,
  Keith Mannthey
  LTC FS-Dev=20



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
