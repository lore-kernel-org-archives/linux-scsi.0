Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8A4C43219
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387345AbiBHWXG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387270AbiBHWUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 17:20:52 -0500
X-Greylist: delayed 370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 14:20:50 PST
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74F3C0612BC
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 14:20:50 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 403535C0184;
        Tue,  8 Feb 2022 17:14:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Feb 2022 17:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6/FjOpkdPkMtxIRka
        H1lps3frqUNnTZmpJdcqXsCHAk=; b=dBN5U3RlJ+t6elcaahsTdTo/UzfH6jr30
        Q5VnEFAThpoLz3BNN2gylQSSzvyHyW/snQ8vUsXWE3L3VNyFzejSkqgDYq5FB7qt
        8UqB/oVU7kptpKGJJccYKxzbd35e7Gs0zzRbVk/rfwTMghZVYUPV6C6v7Q87TWJn
        BE6XullwpflqzS44Ux6qnvO9nwBFvX3Q21vh99dI0XSgIT7P0yRYtIbH33Sg0BxZ
        0CRrEK4v8Lg4uoIx6JK12YQJzNUzudLJJ4tOgV3PcsKGcEkmGQPrJF8gkKJkvknk
        h9cGJR2el1S73iVzNdjoHbWP4yKxjDru9GmCWqO9RGNzJ+64w+U4g==
X-ME-Sender: <xms:TusCYoE1EdpFsm5U4E6zg0CPBQx5bmwKQhop6ItA1OQiV_acZRYy9g>
    <xme:TusCYhXKR8jfpopypwROi0QP_SkxTaEvgTVxV40Qzzu8bRxCuWPoN7dxFPSLzD16s
    k9dlLEdDfBsXw728DA>
X-ME-Received: <xmr:TusCYiJB3D5eUBRBZtCThO8d9ot3LhLUP5if1bj8CDl-61_JpVj5SKfr5VOZ2JWQJFfMpDcp-h3GEtNh1OpD2quKTwpxd7ke7vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:TusCYqGzh3LXxdPO-ejozm31GjgTGOHSwwEhBIqaIYkdivEEYeWEew>
    <xmx:TusCYuXl2SEfkvV6fZJyK_-tagwvgiNrN_ud4qQtRsauBlftCPs6rA>
    <xmx:TusCYtM8VTSrLJdDM6IYw-IRjCDxtKig3-TUiXcHwlNhte2gBaTtsg>
    <xmx:T-sCYgL9qsqYSKz1D_YYs5mceQvi_zgtRIHSayXR7IZgem_rhnk6Ag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 17:14:36 -0500 (EST)
Date:   Wed, 9 Feb 2022 09:14:29 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
In-Reply-To: <20220208172514.3481-5-bvanassche@acm.org>
Message-ID: <a1a4cc-d139-3b95-d0c5-52e8f36d10fd@linux-m68k.org>
References: <20220208172514.3481-1-bvanassche@acm.org> <20220208172514.3481-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Finn Thain <fthain@linux-m68k.org>

On Tue, 8 Feb 2022, Bart Van Assche wrote:

> This makes it easier to find users of the NCR5380_cmd data structure with
> 'grep'.
> 
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/NCR5380.h      | 2 --
>  drivers/scsi/arm/cumana_1.c | 2 +-
>  drivers/scsi/arm/oak.c      | 2 +-
>  drivers/scsi/atari_scsi.c   | 2 +-
>  drivers/scsi/dmx3191d.c     | 2 +-
>  drivers/scsi/g_NCR5380.c    | 2 +-
>  drivers/scsi/mac_scsi.c     | 2 +-
>  drivers/scsi/sun3_scsi.c    | 2 +-
>  8 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 8a3b41932288..845bd2423e66 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -230,8 +230,6 @@ struct NCR5380_cmd {
>  	struct list_head list;
>  };
>  
> -#define NCR5380_CMD_SIZE		(sizeof(struct NCR5380_cmd))
> -
>  #define NCR5380_PIO_CHUNK_SIZE		256
>  
>  /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
> diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> index 3fd944374631..5d4f67ba74c0 100644
> --- a/drivers/scsi/arm/cumana_1.c
> +++ b/drivers/scsi/arm/cumana_1.c
> @@ -223,7 +223,7 @@ static struct scsi_host_template cumanascsi_template = {
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= 2,
>  	.proc_name		= "CumanaSCSI-1",
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  	.max_sectors		= 128,
>  	.dma_boundary		= PAGE_SIZE - 1,
>  };
> diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
> index 78f33d57c3e8..f18a0620c808 100644
> --- a/drivers/scsi/arm/oak.c
> +++ b/drivers/scsi/arm/oak.c
> @@ -113,7 +113,7 @@ static struct scsi_host_template oakscsi_template = {
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
>  	.proc_name		= "oakscsi",
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  	.max_sectors		= 128,
>  };
>  
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 95d7a3586083..e9d0d99abc86 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -711,7 +711,7 @@ static struct scsi_host_template atari_scsi_template = {
>  	.this_id		= 7,
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  };
>  
>  static int __init atari_scsi_probe(struct platform_device *pdev)
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 6df60b31ecb0..a171ce6b70b2 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -52,7 +52,7 @@ static struct scsi_host_template dmx3191d_driver_template = {
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  };
>  
>  static int dmx3191d_probe_one(struct pci_dev *pdev,
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 7ba3c9312731..5923f86a384e 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -702,7 +702,7 @@ static struct scsi_host_template driver_template = {
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  	.max_sectors		= 128,
>  };
>  
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 5c808fbc6ce2..71d493a0bb43 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -434,7 +434,7 @@ static struct scsi_host_template mac_scsi_template = {
>  	.sg_tablesize		= 1,
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  	.max_sectors		= 128,
>  };
>  
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index f7f724a3ff1d..82a253270c3b 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -505,7 +505,7 @@ static struct scsi_host_template sun3_scsi_template = {
>  	.sg_tablesize		= 1,
>  	.cmd_per_lun		= 2,
>  	.dma_boundary		= PAGE_SIZE - 1,
> -	.cmd_size		= NCR5380_CMD_SIZE,
> +	.cmd_size		= sizeof(struct NCR5380_cmd),
>  };
>  
>  static int __init sun3_scsi_probe(struct platform_device *pdev)
> 
