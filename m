From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Wed, 3 Dec 2014 19:29:14 +0100
Message-ID: <201412031929.14767.linux@rainbow-software.org>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:34052 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLCSaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 13:30:03 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Wednesday 03 December 2014 12:44:53 Hannes Reinecke wrote:
> Hi all,
>
> it has been bugged me for ages that the advansys driver always
> reported a compilation warning about not having been converted
> to the DMA-API.
> And even aggressive waiting hasn't made this warning go away.
>
> So here's a patchset to update the advansys driver to current
> standards and use the DMA-API.
> Tested on ABP940-U2W.
>
> As usual, reviews and comments are welcome.
>
> Hannes Reinecke (12):
>   advansys: use host_reset
>   advansys: use shared host tag map for command lookup
>   advansys: use DMA-API for mapping sense buffer
>   advansys: Use DMA-API for carrier buffer
>   advansys: Use DMA-API for mapping request blocks
>   advansys: Use dma_pool for sg elements
>   advansys: use 'bool' instead of 'int'
>   advansys: use standard data types
>   advansys: Remove 'TRUE' and 'FALSE' definitions
>   advansys: Remove 'ERR' definition
>   advansys: cleanup function return codes
>   advansys: Update to version 3.5 and remove compilation warning
>
>  MAINTAINERS             |    1 +
>  drivers/scsi/advansys.c | 1073
> +++++++++++++++++++++-------------------------- 2 files changed, 469
> insertions(+), 605 deletions(-)

Seems to break narrow boards, at least mine ASB-3940UA :(

[    4.266292] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
[    7.661374] scsi host2: AdvanSys SCSI 3.5: PCI Ultra: IO 0xA800-0xA80F, IRQ 0x9
[   28.840078] scsi 2:0:0:0: SCSI bus reset started...
[   28.846640] scsi 2:0:0:0: SCSI bus reset error: 0x2, status: 0x0
[   28.846648] scsi 2:0:0:0: Device offlined - not ready after error recovery
[   28.846803] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.852052] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.860051] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.868047] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.868249] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.876050] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.884048] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.892047] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.892243] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.900051] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.908048] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.916047] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.916241] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.924051] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.932048] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.940048] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.940240] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.948051] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.956049] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.964047] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.964239] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.972050] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.980048] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
[   28.988050] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2

Before the patch:
[    4.226690] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
[    7.644841] scsi host2: AdvanSys SCSI 3.4: PCI Ultra: IO 0xA800-0xA80F, IRQ 0x9
[    8.072257] scsi 2:0:2:0: Processor         HP       C1790A           3226 PQ: 0 ANSI: 2
[    8.919128] scsi 2:0:2:0: Attached scsi generic sg3 type 3

-- 
Ondrej Zary
