From: Laurence Oberman <loberman@redhat.com>
Subject: Re: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based 8Gb)
 with BAR 3 error, work fine on 4.9
Date: Sun, 12 Mar 2017 14:30:53 -0400 (EDT)
Message-ID: <1431912146.999887.1489343453156.JavaMail.zimbra@redhat.com>
References: <718134298.971770.1489318763327.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38424 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934809AbdCLSa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Mar 2017 14:30:56 -0400
In-Reply-To: <718134298.971770.1489318763327.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>, Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Chad Dupuis" <chad.dupuis@cavium.com>, "Himanshu Madhani" <Himanshu.Madhani@cavium.com>
> Cc: "Linux SCSI List" <linux-scsi@vger.kernel.org>
> Sent: Sunday, March 12, 2017 7:39:23 AM
> Subject: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based 8Gb) with BAR 3 error, work fine on 4.9
> 
> Chad, Himanshu
> 
> Before I bisect or go chase changes, wanted to reach out because the driver
> seems to be the same version.
> Perhaps this is a PCIE change in the kernel for 4.10 affecting the load.
> Its the same targetLIO server I have been using for a long time with 4.9
> 
> 27:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
> Express HBA (rev 02)
> 
> With 4.9 I have no issues loading the driver for my targetLIO server.
> (DL380G8)
> 
> # modinfo qla2xxx | more
> filename:
> /lib/modules/4.9.0.lobetcm+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
> firmware:       ql2500_fw.bin
> version:        8.07.00.38-k
> license:        GPL
> description:    QLogic Fibre Channel HBA Driver
> author:         QLogic Corporation
> srcversion:     94A8431A85BFF854B97B02D
> 
> [    8.906351] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> Driver: 8.07.00.38-k.
> [   10.014052] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 106 iobase
> 0xffffadce989a1000.
> [   10.455108] scsi host4: qla2xxx
> [   10.460206] qla2xxx [0000:27:00.0]-00fb:4: QLogic QLE2562 - PCI-Express
> Dual Channel 8Gb Fibre Channel HBA.
> [   10.460215] qla2xxx [0000:27:00.0]-00fc:4: ISP2532: PCIe (5.0GT/s x8) @
> 0000:27:00.0 hdma+ host#=4 fw=8.03.00 (90d5).
> [   10.460545] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 110 iobase
> 0xffffadce989a9000.
> [   10.662120] scsi host5: qla2xxx
> [   11.007841] qla2xxx [0000:27:00.1]-00fb:5: QLogic QLE2562 - PCI-Express
> Dual Channel 8Gb Fibre Channel HBA.
> [   11.007849] qla2xxx [0000:27:00.1]-00fc:5: ISP2532: PCIe (5.0GT/s x8) @
> 0000:27:00.1 hdma+ host#=5 fw=8.03.00 (90d5).
> 
> Rebooting on the same server with 4.10 fails to load
> 
> Linux  4.10.0+
> # modinfo qla2xxx | more
> filename:       /lib/modules/4.10.0+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
> firmware:       ql2500_fw.bin
> version:        8.07.00.38-k
> license:        GPL
> description:    QLogic Fibre Channel HBA Driver
> author:         QLogic Corporation
> srcversion:     939E0595E8A3C2E1BE94392
> 
> [    8.754040] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> Driver: 8.07.00.38-k.
> [    9.979523] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.
> [   10.201268] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 110 iobase
> 0xffffacbf189b1000.
> [   10.407865] scsi host5: qla2xxx
> [   10.444281] qla2xxx: probe of 0000:27:00.0 failed with error -22
> [   10.444519] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
> [   10.444522] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 110 iobase
> 0xffffacbf189b9000.
> [   10.645932] scsi host5: qla2xxx
> [   10.682233] qla2xxx: probe of 0000:27:00.1 failed with error -22
> 
> Thanks
> Laurence
> 

I started bisecting this, cannot believe others have not bumped into this on 4.10.
This is a generic QLE2562 and firmware is loaded by the driver so wondering why I am seeing this and other are not.
There is nothing special with the PCIE bus on this DL380G8.

Anyway during the bisect I got to a point where in the 4.10 commits I still saw the "BAR 3" message
but the probe worked.

[    7.208237] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k.
[    7.208492] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.

       see this above but probe did not fail

[    7.208494] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 97 iobase 0xffffc02f98989000.
[    7.414738] scsi host4: qla2xxx

[    7.419267] qla2xxx [0000:27:00.0]-00fb:4: QLogic QLE2562 - PCI-Express Dual Channel 8Gb Fibre Channel HBA.
[    7.419278] qla2xxx [0000:27:00.0]-00fc:4: ISP2532: PCIe (5.0GT/s x8) @ 0000:27:00.0 hdma+ host#=4 fw=8.03.00 (90d5).
[    7.419698] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
[    7.419701] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 100 iobase 0xffffc02f989b1000.
[    7.625691] scsi host6: qla2xxx
[    7.629218] qla2xxx [0000:27:00.1]-00fb:6: QLogic QLE2562 - PCI-Express Dual Channel 8Gb Fibre Channel HBA.
[    7.629222] qla2xxx [0000:27:00.1]-00fc:6: ISP2532: PCIe (5.0GT/s x8) @ 0000:27:00.1 hdma+ host#=6 

I marked that still as bad and am continuing, I have 9 builds to go.

Thanks
Laurence
