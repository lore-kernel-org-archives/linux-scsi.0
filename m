From: "jameshsu" <jameshsu@mail.acard.com>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Fri, 7 Jan 2005 18:05:29 +0800
Message-ID: <035001c4f4a0$6b3b4e50$6200a8c0@jameshsu>
References: <026801c4ee56$1e802810$6200a8c0@jameshsu> <1105052325.17166.284.camel@localhost.localdomain>
Reply-To: "jameshsu" <jameshsu@mail.acard.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 219-80-62-20.static.tfn.net.tw ([219.80.62.20]:29958 "EHLO
	Thunder.acard.com") by vger.kernel.org with ESMTP id S261337AbVAGKCO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 05:02:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, EdwardLian <edwardlian@mail.acard.com>, Jason Wu <jason_wu@acard.com>

Hi Alan,

We are in the process to modify the driver in order to meet your suggests.
Following change has been made.
1) Put it back for originator's copyrights to the file.
2) Go back to build up/modify driver from kernel 2.6.10. according to James
Bottomley's suggestions
3) use new header
     <scsi/scsi.h>
    <scsi/scsi_host.h>
    <scsi/scsi_device.h>
    <scsi/scsi_cmnd.h>)
4) enable .max_sectors = 128
5) Either  modify or remove all following declare:
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+static irqreturn_t atp885_intr_handle(int irq, void *dev_id, struct
pt_regs *regs)
+#else
+static void atp885_intr_handle(int irq, void *dev_id, struct pt_regs
*regs)
+#endif

+static struct Scsi_Host *atp_host[MAX_ADAPTER];
+static int host_index = 0;

6) Reversals of some of improvements like hotplug pci made outside -
Addition of support for the AEC67160Acard
7) more.....
New driver will be submit around 1-2 week later.
During these period, if you have more suggestions, please let us know ASAP
while testing.
Again, Thanks for your help!

James Hsu,
Manager,Engineering Testing Dept.
ACARD TECHNOLOGY CORP.
Taipei Hsien,Taiwan
6F No78,Sec 1,Kwang Fu Road,Sang Chung,
(02)8512-2290 x 2311(O),(02)8512-1524(FAX)


----- Original Message -----
From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
To: "jameshsu" <jameshsu@mail.acard.com>
Cc: <linux-scsi@vger.kernel.org>
Sent: Friday, January 07, 2005 7:10 AM
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6


> The trouble with the patch as is, is that it mixes up
>
> - Reversals of improvements like hotplug pci made outside Acard
> - Addition of support for the AEC67160
> - Other unknown improvements Acard may have made
>
> In order for this to be useful we need to be able to see just the
> changes that are important.
>
> I can easily see for example the new PCI identifiers but not the other
> needed changes. In order to do that I really need either a description
> of the relevant changes or those changes versus the existing 2.6 driver
> tree.
>
> Any help welcomed.
>
> Alan
>

