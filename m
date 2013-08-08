From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH V2 4/8] [SCSI] megaraid: add missing __iomem annotation
Date: Thu, 8 Aug 2013 17:00:11 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A00DBF90@inbmail01.lsi.com>
References: <002701ce93d4$d234ab60$769e0220$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28263 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965050Ab3HHLaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Aug 2013 07:30:23 -0400
In-Reply-To: <002701ce93d4$d234ab60$769e0220$@samsung.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>, 'James Bottomley' <JBottomley@Parallels.com>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>, 'James Bottomley' <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


>-----Original Message-----
>From: Jingoo Han [mailto:jg1.han@samsung.com]
>Sent: Thursday, August 08, 2013 6:46 AM
>To: 'James Bottomley'
>Cc: DL-MegaRAID Linux; 'James Bottomley'; linux-scsi@vger.kernel.org;
>Jingoo Han
>Subject: [PATCH V2 4/8] [SCSI] megaraid: add missing __iomem annotation
>
>Added missing __iomem annotation in order to fix the following sparse
>warnings:
>
>drivers/scsi/megaraid.c:4595:26: warning: incorrect type in argument 1
>(different address spaces)
>drivers/scsi/megaraid.c:4595:26:    expected void volatile [noderef]
><asn:2>*addr
>drivers/scsi/megaraid.c:4595:26:    got void *<noident>
>drivers/scsi/megaraid.c:4653:26: warning: incorrect type in argument 1
>(different address spaces)
>drivers/scsi/megaraid.c:4653:26:    expected void volatile [noderef]
><asn:2>*addr
>drivers/scsi/megaraid.c:4653:26:    got void *<noident>
>
>Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>---
>No changes since v1:
>
> drivers/scsi/megaraid.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
>90c95a3..a395207 100644
>--- a/drivers/scsi/megaraid.c
>+++ b/drivers/scsi/megaraid.c
>@@ -4592,7 +4592,7 @@ megaraid_probe_one(struct pci_dev *pdev, const
>struct pci_device_id *id)
> 	scsi_host_put(host);
>  out_iounmap:
> 	if (flag & BOARD_MEMMAP)
>-		iounmap((void *)mega_baseport);
>+		iounmap((void __iomem *)mega_baseport);
>  out_release_region:
> 	if (flag & BOARD_MEMMAP)
> 		release_mem_region(tbase, 128);
>@@ -4650,7 +4650,7 @@ megaraid_remove_one(struct pci_dev *pdev)
>
> 	/* Free our resources */
> 	if (adapter->flag & BOARD_MEMMAP) {
>-		iounmap((void *)adapter->base);
>+		iounmap((void __iomem *)adapter->base);
> 		release_mem_region(adapter->host->base, 128);
> 	} else
> 		release_region(adapter->base, 16);
>--
>1.7.10.4
>
>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>


Sumit


