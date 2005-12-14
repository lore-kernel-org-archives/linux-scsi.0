From: Hermann Lauer <Hermann.Lauer@iwr.uni-heidelberg.de>
Subject: Fusion MPT SPI Host driver fails with LSI bios disabled
Date: Wed, 14 Dec 2005 16:14:55 +0100
Message-ID: <20051214151455.GB2714@lemon.iwr.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:8363 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S964789AbVLNPO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 10:14:57 -0500
Received: from mail.iwr.uni-heidelberg.de (mail.iwr.uni-heidelberg.de [129.206.104.30])
	by relay.uni-heidelberg.de (8.13.4/8.13.1) with ESMTP id jBEFEtHA004250
	for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2005 16:14:55 +0100
Received: from lemon.iwr.uni-heidelberg.de (lemon.iwr.uni-heidelberg.de [129.206.104.80])
	by mail.iwr.uni-heidelberg.de (8.12.11/8.12.11) with ESMTP id jBEFEtqM010194
	for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2005 16:14:55 +0100 (MET)
Received: (from hlauer@localhost)
	by lemon.iwr.uni-heidelberg.de (8.12.11/8.12.11) id jBEFEtZV002832
	for linux-scsi@vger.kernel.org; Wed, 14 Dec 2005 16:14:55 +0100 (MET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

I noticed that when the bios of the LSI Logic 53c1030 PCI-X Fusion-MPT Dual
Ultra320 SCSI host is disabled the driver (linux-2.6.14.3) fails to initialize
the controller:

Dec 14 12:26:02 quadopt2 kernel: Fusion MPT SPI Host driver 3.03.03
Dec 14 12:26:02 quadopt2 kernel: ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 24 (level, low) -> IRQ 18
Dec 14 12:26:02 quadopt2 kernel: mptbase: Initiating ioc0 bringup
Dec 14 12:26:02 quadopt2 kernel: mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
Dec 14 12:26:02 quadopt2 kernel: mptbase: ioc0: ERROR - Diagnostic reset FAILED! (102h)
Dec 14 12:26:02 quadopt2 kernel: mptbase: ioc0 NOT READY WARNING!
Dec 14 12:26:02 quadopt2 kernel: mptbase: WARNING - ioc0 did not initialize properly! (-1)
Dec 14 12:26:02 quadopt2 kernel: mptspi: probe of 0000:02:04.0 failed with error -1

Maybe this has something to do with the PCI latency setting, which is in the
error case 64 (LSI bios disabled, shown below), with LSI bios enabled it
reads 72:

lspci -v
...
0000:02:04.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1000
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19

I didn't know if somethings like this could be set in the driver.
But it's not a real problem here.

Thanks for all the work.
Greetings
   Hermann

-- 
Netzwerkadministration/Zentrale Dienste, Interdiziplinaeres 
Zentrum fuer wissenschaftliches Rechnen der Universitaet Heidelberg
IWR; INF 368; 69120 Heidelberg; Tel: (06221)54-8236 Fax: -5224
Email: Hermann.Lauer@iwr.uni-heidelberg.de
