Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF845C678DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 23:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353356AbjHQXLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355922AbjHQXLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 19:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12FF2D68
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 16:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6959063415
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 23:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149F9C433C7;
        Thu, 17 Aug 2023 23:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692313901;
        bh=yk+dMF7CqUE89ZrxIVtgb2O0fS/5TPNsPBLF24v/lMY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=F3AuA7rTYVFGVSHX/+ss3bbEOOA8vS4QHPsE7Clu4jOhA2G9VSaiuacdrzI/iLpxP
         yvaLHHHq7wyN9i9WE8doSozWpQi0F3wbmqL6XPRj9AYT04Zqaj/D70g4UZB71bO9m5
         mg47F5x2IPJBUXJ/Y6rtir6R02lpEBM7zFRNIPPJOL8oCkOBuOmXqw/kjL6MO0LBzy
         j37Injx/JvaofvBtIIp4EFIstLAgq8U6P6+ar44fHNwWwp7Szi2XfdKmSroUsqYNFn
         AGZ9U3VLuEeEgSungMFHXu5BUchZj625GjIzbjmLbDdtqlgwJJxSav/WfSAdH76Mg/
         ZHL6yUO5QUekA==
Message-ID: <f0de3678-ab9f-1e0d-029e-f5859e82160f@kernel.org>
Date:   Fri, 18 Aug 2023 08:11:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 1/3] ata: libata: Introduce ata_qc_has_cdl()
To:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230817214137.462044-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/18 6:41, Igor Pylypiv wrote:
> Introduce the inline helper function ata_qc_has_cdl() to test if
> a queued command has a Command Duration Limits descriptor set.
> 
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  include/linux/libata.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 820f7a3a2749..bc7870f1f527 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1062,6 +1062,11 @@ static inline bool ata_port_is_frozen(const struct ata_port *ap)
>  	return ap->pflags & ATA_PFLAG_FROZEN;
>  }
>  
> +static inline bool ata_qc_has_cdl(struct ata_queued_cmd *qc)
> +{
> +	return qc->flags & ATA_QCFLAG_HAS_CDL;
> +}

This is used in one place only in patch 3, and the only other place we test this
flag is in ata_build_rw_tf(). So I do not think this is necessary. Let's drop this.

> +
>  extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
>  extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
>  				int (*check_ready)(struct ata_link *link));

-- 
Damien Le Moal
Western Digital Research

