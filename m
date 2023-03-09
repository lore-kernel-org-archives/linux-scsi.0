Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E317AC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 23:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCIXhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjCIXhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 18:37:04 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5A9106A04
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 15:36:56 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bi9so4434627lfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 15:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678405015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pz86KEiMFgUOd6pTvJoAJJJfwI/jdCQkNURF8Fq6k08=;
        b=DZtFrc8qBu4nujlbaktFL+esUBy9EOeRfI5WRyUbXLrCNCR2+6AC1uF9FhnyCkuVhs
         QNZ8gn0RrUSlv7QmPyefPzpoITFRm07tMwAjhgtzZsh5gnPWhipuZsT9+I1l/faTnanT
         6xW/HWXVm3e5GXvDOIyLRQP3QCMuzLHVD2cNlfMKqCIpIRsnucwrVIma56H9ca8jiNQz
         BsQ9juwY6KE+hIphtqZfyFIqlnNIoJsVlqomennU0G+GIsQYsxM2jVVoTBQNW0CGturA
         wnZuDfIoNGUTk3/bShH/MzxAqdSbKhEG4QPch+UiSokhgtOwoeuoggqAe7CItidalUbN
         9sOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678405015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pz86KEiMFgUOd6pTvJoAJJJfwI/jdCQkNURF8Fq6k08=;
        b=YaCDfJM23eealmRwaVoaxqyCNiNI1bRJCCNANCCFa1X8zSD9reyJc657LdQ+sKT08u
         JRDLlKFeo/HAvFAJdtUXBi+gtjUN0XBtgCvz6a8+3Vuq9Fog2wryfsVm1aR4KOvAXO1g
         Q/PTxPQf2daah0dv9nJsTcXZb3fkhRYX8TN+sKdyj6ba3XAG/Hcpw8NDA4lOQ76qR8dE
         Tx9W4mBlLd1OsGmsaxW5DOKmQG09hIzI26Kt7IeVT0Tpg4gScjCKmIQZ5+fNOMSL4M5d
         6AEyRBgd/6FGOifTmxjjI9E402mxyKt4epxPsjgF4WntUz29H609d+VqDH3Yw8ip4sj8
         WTlA==
X-Gm-Message-State: AO0yUKVp82sl/01ibPikByU93lLnczXQ2Xdt3X8IeMxf2RRAUCPsi34I
        DHN79/W8YrbaQcUtR5Ryej4=
X-Google-Smtp-Source: AK7set+2ysFiB7+hfLhnYByQaAezjyOEthnXRPOTAJxiIGCsDkGC0sNUdeU498oGzYAk3gjW73hxFg==
X-Received: by 2002:ac2:55b0:0:b0:4e0:a426:6ddc with SMTP id y16-20020ac255b0000000b004e0a4266ddcmr6101189lfg.0.1678405014921;
        Thu, 09 Mar 2023 15:36:54 -0800 (PST)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id f20-20020a19ae14000000b004db2978e330sm60609lfc.258.2023.03.09.15.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 15:36:54 -0800 (PST)
Date:   Fri, 10 Mar 2023 02:36:51 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Ondrej Zary <linux@zary.sk>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v2 04/82] ata: Declare SCSI host templates const
Message-ID: <20230309233651.tcymciicgla5pw3e@mobilestation>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309192614.2240602-5-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 11:24:56AM -0800, Bart Van Assche wrote:
> Make it explicit that ATA host templates are not modified.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

[nip]

>  drivers/ata/ahci_dwc.c                  |  2 +-

[nip]

>  111 files changed, 129 insertions(+), 129 deletions(-)
> 

[nip]
  
> diff --git a/drivers/ata/ahci_dwc.c b/drivers/ata/ahci_dwc.c
> index 8fb66860db31..4bfbb09cdc02 100644
> --- a/drivers/ata/ahci_dwc.c
> +++ b/drivers/ata/ahci_dwc.c
> @@ -398,7 +398,7 @@ static const struct ata_port_info ahci_dwc_port_info = {
>  	.port_ops	= &ahci_dwc_port_ops,
>  };
>  
> -static struct scsi_host_template ahci_dwc_scsi_info = {
> +static const struct scsi_host_template ahci_dwc_scsi_info = {
>  	AHCI_SHT(DRV_NAME),
>  };
>  

For DWC AHCI SATA
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>

-Serge(y)

[nip]

