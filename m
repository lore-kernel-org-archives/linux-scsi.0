Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3DBC48BE5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7C361040
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhFSPsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 11:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhFSPsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 11:48:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377C7C061574;
        Sat, 19 Jun 2021 08:46:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 69so6224360plc.5;
        Sat, 19 Jun 2021 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b0K8HSAqOAgzoJk09xtqO95f4D/akP/DcQsZH563JKY=;
        b=TuPm5T2vE34LrYNmzepdpUqwjK8MpRQNmhFeOP1xqMp3pWWca74FHaAqMtguYvHEQg
         JrIgH23kfRh+u0D/IH6qg/iro6Jtco4SxOLVYNj6rwp/lQSsRbY9N72/I8vKod0gMvTI
         nXvYEpqvrTxa1gojdnZggVOsp+lmxUmGHoQjhqMjmSxXkkWGxK31UTluRS9KNKyaRZoV
         x6y5QOWbyzzCxqleVYDHD064+ShUXjvqs1b+AaqWMwvcTyHS7/4WhX/Jl8PkBEklViSY
         YRrcf58Oeq5oz5YHbsq16DIdCaFpJ+SbLZbq62DrXDcsXxomgA+zYTzBpeWXaYEPCbUk
         zgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0K8HSAqOAgzoJk09xtqO95f4D/akP/DcQsZH563JKY=;
        b=cXKctdnBZqfkb0opkURmNXx4XCQGmP0f/CqdyYCuAG840sXwl6Gj2xPo6kmAI4VAwO
         e6P3QXODFx0iQMctsz3nM1kq1EC2WOJJyu49HaBpcmP7wc/qIsJBB0XcYui63OH48Rmj
         DymAv3ZlT6dHd8JSNXQyG8w1LWXLxdmAqxI9GJmaevEyfz0Vw2r2lSaELwyk6RdCM6fS
         cEVkgr5gqx95Kwf4Jc2DzRG9UHnXWMYS0TYXX1xLUBUu94zEl2vRHv221z7tUuani4hE
         h2JlgK/qIa+DAKPu/QEbdc7PlArD0Vh3Oyu4AD9ldcjV9Im2bb6xFrYK+WY9sBQ00Ah7
         SgnQ==
X-Gm-Message-State: AOAM532NuDzqc0WSCR/HBT2kJ7SwJnaKIhsKEPK563gTo6ilwlkNK8O2
        w7RVaNSgz4KYBYi1f3rI3z2B/BfxBpU=
X-Google-Smtp-Source: ABdhPJxeLCgKu43N6SH9B2StFApUiyVm5/CK27TIBXxf4z5tJHFNJLJxXY1cXXtSzV2v7pJJ2uOBEg==
X-Received: by 2002:a17:902:ab88:b029:11d:20fa:8ca6 with SMTP id f8-20020a170902ab88b029011d20fa8ca6mr9737530plr.67.1624117588705;
        Sat, 19 Jun 2021 08:46:28 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e24sm11926205pgi.17.2021.06.19.08.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jun 2021 08:46:28 -0700 (PDT)
Subject: Re: [PATCH][next] scsi: elx: libefc: Fix less than zero comparison of
 a unsigned int
To:     Colin King <colin.king@canonical.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210616170401.15831-1-colin.king@canonical.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <b1fbaad3-972b-53f5-817c-9b6ee14a02ce@gmail.com>
Date:   Sat, 19 Jun 2021 08:46:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616170401.15831-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/2021 10:04 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u32 variable rc to less than zero always
> false because it is unsigned. Fix this by making it an int.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/elx/libefc/efc_device.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Thanks!

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


