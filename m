From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Fix probing cards without io port
Date: Mon, 08 Aug 2016 22:03:06 -0400
Message-ID: <yq1bn12u2at.fsf@sermon.lab.mkp.net>
References: <20160806063734.31083-1-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160806063734.31083-1-yinghai@kernel.org> (Yinghai Lu's message
	of "Fri, 5 Aug 2016 23:37:34 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Yinghai" == Yinghai Lu <yinghai@kernel.org> writes:

> Found one megaraid_sas HBA probe fails,
> 
> [  187.235190] scsi host2: Avago SAS based MegaRAID driver
> [  191.112365] megaraid_sas 0000:89:00.0: BAR 0: can't reserve [io  0x0000-0x00ff]
> [  191.120548] megaraid_sas 0000:89:00.0: IO memory region busy!

> and the card has resource like,
> [  125.097714] pci 0000:89:00.0: [1000:005d] type 00 class 0x010400
> [  125.104446] pci 0000:89:00.0: reg 0x10: [io  0x0000-0x00ff]
> [  125.110686] pci 0000:89:00.0: reg 0x14: [mem 0xce400000-0xce40ffff 64bit]
> [  125.118286] pci 0000:89:00.0: reg 0x1c: [mem 0xce300000-0xce3fffff 64bit]
> [  125.125891] pci 0000:89:00.0: reg 0x30: [mem 0xce200000-0xce2fffff pref]

> that does not io port resource allocated from BIOS, and kernel can not assign
> one as io port shortage.
> 
> The driver is only looking for MEM, and should not fail.

> It turns out megasas_init_fw() etc are using bar index as mask.
> index 1 is used as mask 1, so that pci_request_selected_regions()
> is trying to request BAR0 instead of BAR1.

> Fix all related reference.

Kashyap? Sumit?

-- 
Martin K. Petersen	Oracle Linux Engineering
