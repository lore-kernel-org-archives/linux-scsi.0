Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67661CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 428A320818
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbfKEFyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 00:54:37 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49436 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387443AbfKEFyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 00:54:37 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 6DA6A29D2D;
        Tue,  5 Nov 2019 00:54:35 -0500 (EST)
Date:   Tue, 5 Nov 2019 16:54:39 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, schmitz@debian.org
Subject: Re: [PATCH] scsi: scsi-lib.c: increase cmd_size by sizeof(struct
 scatterlist)
In-Reply-To: <1572922150-4358-1-git-send-email-schmitzmic@gmail.com>
Message-ID: <alpine.LNX.2.21.1.1911051635230.194@nippy.intranet>
References: <cover.1572656814.git.fthain@telegraphics.com.au> <1572922150-4358-1-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Nov 2019, Michael Schmitz wrote:

> In scsi_mq_setup_tags(), cmd_size is calculated based on zero size
> for the scatter-gather list in case the low level driver uses SG_NONE
> in its host template.
> 
> cmd_size is passed on to the block layer for calculation of the request
> size, and we've seen NULL pointer dereference errors from the block
> layer in drivers where SG_NONE is used and a mq IO scheduler is active,
> apparently as a consequence of this (see commit 68ab2d76e4be for the
> cxflash driver, and a recent patch by Finn Thain converting the three
> m68k NFR5380 drivers to avoid setting SG_NONE).
> 
> Try to avoid these errors by accounting for at least one sg list entry
> when caculating cmd_size, regardless of whether the low level driver
> set a zero sg_tablesize.
> 
> Tested on 030 m68k with the atari_scsi driver - setting sg_tablesize to
> SG_NONE no longer results in a crash when loading this driver.
> 
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> CC: Finn Thain <fthain@telegraphics.com.au>

No objections from me. I still like the patch series I sent but it's a 
matter of taste. I'm happy to leave it to the scsi maintainers to figure 
out the best fix for this regression.

-- 

> ---
>  drivers/scsi/scsi_lib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d47d637..d38b0e1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1867,7 +1867,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  {
>  	unsigned int cmd_size, sgl_size;
>  
> -	sgl_size = scsi_mq_inline_sgl_size(shost);
> +	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
> +				scsi_mq_inline_sgl_size(shost));
>  	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
>  	if (scsi_host_get_prot(shost))
>  		cmd_size += sizeof(struct scsi_data_buffer) +
> 
