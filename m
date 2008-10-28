From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 10/22] libata-sff: clean up BMDMA initialization
Date: Tue, 28 Oct 2008 00:16:04 -0400
Message-ID: <49069204.4040502@garzik.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-11-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56563 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYJ1EQI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 00:16:08 -0400
In-Reply-To: <1224580680-13698-11-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> This patch improves BMDMA initialization such that
> 
> * When BMDMA register initialization fails, falls back to PIO instead
>   of failing.  ata_pci_bmdma_init() never fails now.
> 
> * When ata_pci_bmdma_init() falls back to PIO, it clears
>   ap->mwdma_mask and udma_mask instead of depending on
>   ata_bmdma_mode_filter().  This makes ata_bmdma_mode_filter()
>   unnecessary and p1 is removed.
> 
> * ata_port_start() which actually is BMDMA specific is moved to
>   ata_bmdma_port_start().  ata_port_start() and ata_sff_port_start()
>   are killed.
> 
> Drivers which no longer calls into PRD table allocation are...
> 
>   pdc_adma, sata_inic162x, sata_qstor, sata_sx4, pata_cmd640 and all
>   drivers which inherit from ata_sff_port_ops.
> 
> pata_icside sets ->port_start to ATA_OP_NULL as it doesn't need PRD
> but is a BMDMA controller and doesn't have custom port_start like
> other such controllers.

Nice!


