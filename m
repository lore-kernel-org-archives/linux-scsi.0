Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88834C5DF63
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 21:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EBBE214D8
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 21:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfKFVw3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:52:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:37074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726779AbfKFVw3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Nov 2019 16:52:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00D50AED5;
        Wed,  6 Nov 2019 21:52:27 +0000 (UTC)
Message-ID: <83f1cc2e978b874d0b135fef7524fcc5e5d00d7f.camel@suse.de>
Subject: Re: [PATCH 2/2] qla2xxx: Fix a dma_pool_free() call
From:   Martin Wilck <mwilck@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Date:   Wed, 06 Nov 2019 22:52:57 +0100
In-Reply-To: <20191106044226.5207-3-bvanassche@acm.org>
References: <20191106044226.5207-1-bvanassche@acm.org>
         <20191106044226.5207-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-05 at 20:42 -0800, Bart Van Assche wrote:
> This patch fixes the following kernel warning:
> 
> DMA-API: qla2xxx 0000:00:0a.0: device driver frees DMA memory with
> different size [device address=0x00000000c7b60000] [map size=4088
> bytes] [unmap size=512 bytes]
> WARNING: CPU: 3 PID: 1122 at kernel/dma/debug.c:1021
> check_unmap+0x4d0/0xbd0
> CPU: 3 PID: 1122 Comm: rmmod Tainted: G           O      5.4.0-rc1-
> dbg+ #1
> RIP: 0010:check_unmap+0x4d0/0xbd0
> Call Trace:
>  debug_dma_free_coherent+0x123/0x173
>  dma_free_attrs+0x76/0xe0
>  qla2x00_mem_free+0x329/0xc40 [qla2xxx_scst]
>  qla2x00_free_device+0x170/0x1c0 [qla2xxx_scst]
>  qla2x00_remove_one+0x4f0/0x6d0 [qla2xxx_scst]
>  pci_device_remove+0xd5/0x1f0
>  device_release_driver_internal+0x159/0x280
>  driver_detach+0x8b/0xf2
>  bus_remove_driver+0x9a/0x15a
>  driver_unregister+0x51/0x70
>  pci_unregister_driver+0x2d/0x130
>  qla2x00_module_exit+0x1c/0xbc [qla2xxx_scst]
>  __x64_sys_delete_module+0x22a/0x300
>  do_syscall_64+0x6f/0x2e0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Cc: Michael Hernandez <mhernandez@marvell.com>
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Fixes: 3f006ac342c0 ("scsi: qla2xxx: Secure flash update support for
> ISP28XX") # v5.2-rc1~130^2~270.
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> index 16f9b6ed574a..05fba5c2c926 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4676,7 +4676,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>  	ha->sfp_data = NULL;
>  
>  	if (ha->flt)
> -		dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
> +		dma_free_coherent(&ha->pdev->dev,
> +		    sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
>  		    ha->flt, ha->flt_dma);
>  	ha->flt = NULL;
>  	ha->flt_dma = 0;

Reviewed-by: Martin Wilck <mwilck@suse.com>


