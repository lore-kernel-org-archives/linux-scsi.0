Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464AAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiECQVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbiECQVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:21:48 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465172CE3F
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:18:16 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id v10so14379094pgl.11
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3k+/IywsqhijfgH2P3Ecwj3gHWXRFdv46v2m3TfZmVw=;
        b=lxFsfQzumTa8uvHS2PeD2IhvW4S4AcageQKQU/bx1WYxBRhkQJfqRF1ov8sEBPuobZ
         G8kDWfZObuV0kFkGaMWGo8GC0dlwoIq6vJMd6wDqsnLXTwrKc2qbWxni89RDoJwqxd/F
         kwBbvtNMxSg7Daf8aUV2AYye6lCjzjemf//J3EOkNWdGDXxukqyhPWJUjNdZe/IMrBTX
         jy0OTK0rcSg5L4qSYmxD6SPt0dhvIBuNupd7eHy1IJgSD3xh6FqHsgLqr+9BEFlTicGx
         uh1OppHGqOBgLy8bBTNlOkM013Gtyb+LUCCSL9i1Gg01f6y+BO9K9hraLFw02OUHbaJR
         vL/A==
X-Gm-Message-State: AOAM531iXPnsRsl13A/Dn7O7uKSJqrDp3mQZgKEbGhUowJU9lnUkQqF2
        Wo2MBXqlTXBBNMV8KQbOiaI=
X-Google-Smtp-Source: ABdhPJwh6dPa5dnBjUwRq3awbw2CuaOY67dXAMMbf/TwWfklplUb+aHhhTeBo6IElcO076AncZzSWQ==
X-Received: by 2002:a63:115b:0:b0:3c1:eb46:6f5 with SMTP id 27-20020a63115b000000b003c1eb4606f5mr12021361pgr.277.1651594695721;
        Tue, 03 May 2022 09:18:15 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id p20-20020a1709028a9400b0015e8d4eb2b7sm6541525plo.257.2022.05.03.09.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:18:15 -0700 (PDT)
Message-ID: <b047dd15-4cb7-68d4-47d9-1cbe5f1b69d3@acm.org>
Date:   Tue, 3 May 2022 09:18:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502213820.3187-18-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:38, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 29d56396058c..f344cbc27923 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>   
>   	snic->max_tag_id = shost->can_queue;
> +	/* Reserve one reset command */
> +	shost->can_queue--;
> +	snic->tmf_tag_id = shost->can_queue;
>   
>   	shost->max_lun = snic->config.luns_per_tgt;
>   	shost->max_id = SNIC_MAX_TARGET;

Hmm ... shouldn't cmd_per_lun also be decreased?

Thanks,

Bart.
