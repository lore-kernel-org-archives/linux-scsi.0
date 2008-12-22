From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: BUG: bad: [58e2a02eb18393e76a469580fedf7caec190eb5e] [SCSI] eata:
 convert to use the data buffer accessors
Date: Tue, 23 Dec 2008 04:17:58 +1030
Message-ID: <494FD2CE.7060009@internode.on.net>
References: <494E69F0.3060300@internode.on.net> <20081222110935D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52632 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYLVRsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 12:48:37 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LEotM-00034a-I9
	for linux-scsi@vger.kernel.org; Mon, 22 Dec 2008 17:48:32 +0000
Received: from ppp121-45-91-187.lns10.adl6.internode.on.net ([121.45.91.187])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 17:48:32 +0000
Received: from arthur.marsh by ppp121-45-91-187.lns10.adl6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 17:48:32 +0000
In-Reply-To: <20081222110935D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ballabio_dario@emc.com, 506835@bugs.debian.org

FUJITA Tomonori wrote, on 22/12/08 12:39:

> 
> Sorry about the problem. Can you try this patch?
> 
> 
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index a73a6bb..976cdd5 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -1626,8 +1626,15 @@ static void map_dma(unsigned int i, struct hostdata *ha)
>  
>  	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
>  
> -	count = scsi_dma_map(SCpnt);
> -	BUG_ON(count < 0);
> +	if (!scsi_sg_count(SCpnt)) {
> +		cpp->data_len = 0;
> +		return;
> +	}
> +
> +	count = pci_map_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
> +			   pci_dir);
> +	BUG_ON(!count);
> +
>  	scsi_for_each_sg(SCpnt, sg, count, k) {
>  		cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
>  		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
> @@ -1655,7 +1662,9 @@ static void unmap_dma(unsigned int i, struct hostdata *ha)
>  		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
>  				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
>  
> -	scsi_dma_unmap(SCpnt);
> +	if (scsi_sg_count(SCpnt))
> +		pci_unmap_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
> +			     pci_dir);
>  
>  	if (!DEV2H(cpp->data_len))
>  		pci_dir = PCI_DMA_BIDIRECTIONAL;

Thanks, I applied the patch manually against the Debian 2.6.27 kernel 
source at http://kernel-archive.buildserver.net/ and after starting the 
  patched kernel, the eata module loaded successfully. I mounted the 
filesystems on the attached scsi disk and ran ls -alR on all filesystems 
successfully.

dmesg reported:

[  168.343910] PCI: setting IRQ 5 as level-triggered
[  168.343944] pci 0000:00:0a.0: found PCI INT A -> IRQ 5
[  168.346548] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[  168.346657] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:y, ep:n, pp:y.
[  168.346769] EATA0: 2.0C, PCI 0xe010, IRQ 5, BMST, SG 122, MB 64.
[  168.346863] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[  168.346958] EATA0: SCSI channel 0 enabled, host target ID 7.
[  168.411912] scsi0 : EATA/DMA 2.0x rev. 8.10.00
[  169.953101] scsi 0:0:6:0: Direct-Access     IBM      DCAS-34330W 
  S65A PQ: 0 ANSI: 2
[  169.953239] scsi 0:0:6:0: cmds/lun 16, sorted, simple tags.
[  172.189180] Driver 'sd' needs updating - please use bus_type methods
[  172.193186] sd 0:0:6:0: [sda] 8466688 512-byte hardware sectors (4335 MB)
[  172.230078] sd 0:0:6:0: [sda] Write Protect is off
[  172.230191] sd 0:0:6:0: [sda] Mode Sense: b3 00 00 08
[  172.251052] sd 0:0:6:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  172.254288] sd 0:0:6:0: [sda] 8466688 512-byte hardware sectors (4335 MB)
[  172.263454] sd 0:0:6:0: [sda] Write Protect is off
[  172.263551] sd 0:0:6:0: [sda] Mode Sense: b3 00 00 08
[  172.284232] sd 0:0:6:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  172.284375]  sda: sda1 sda2 < sda5 >
[  172.322394] sd 0:0:6:0: [sda] Attached SCSI disk


As with 2.6.22 kernels gnu fdisk had problems with the scsi drive, but 
cfdisk and sfdisk were ok:

[  222.575704] fdisk[1996]: segfault at 60 ip 41b6d443 sp bff98034 error 
4 in libc-2.7.so[41af7000+155000]
[  249.063672] lfdisk[1998]: segfault at 60 ip 41b6d443 sp bfe50084 
error 4 in libc-2.7.so[41af7000+155000]

The gfdisk/lfdisk error was reported as Debian Bug#463720:

Thanks very much for the rapid response to this bug report!

Arthur.

