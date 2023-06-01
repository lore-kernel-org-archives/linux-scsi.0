Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A650C7EE2A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 14:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjFAOOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 10:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbjFAOOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 10:14:11 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEE5C0
        for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2023 07:14:09 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6513e7e5d44so248005b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2023 07:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685628849; x=1688220849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mab2RUBazxiwELCVkHtwUaKLkmEIFRtIxgag3AAomQ=;
        b=aO1nsMj9pBeqSaQU88cRv/LUeWxAYvM1mHoaGHbKfcK469QLJoxNORuinFnxfWhiG2
         K7dIi2dKlLv7lQfQbF0/361zC2UTNl+LfG/AN1FJizzC8lgja5jrq27qveweQt06k72q
         71ACjFpjag/fgOM8VW9fTFiUmH5X/4HWK1N1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685628849; x=1688220849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mab2RUBazxiwELCVkHtwUaKLkmEIFRtIxgag3AAomQ=;
        b=aMGjiUbxgtikUNT6IPy89IAibTXI07FjtxPJb+Z0IXgjG9vS+WsNZzcXHMInC52Iya
         s8PsVOA4wpcwcr3UoaVxfcTwnppIb4ZVUXYshBFEo7xkiCrvT3Sn5DRsDdCiEPYaGL5N
         OjXWx3x6FUf8WCtRBZSkUURxVYrwjCxVLFfFbrtjfX4uLy6ydbrVWAdcSYuUE2re+22U
         RwvqBSr6CuLA3UFHOK9h10asQBCZAVblGHLxbnNMvGISHUhdK8eqBgo9ewT3JI74HQw5
         SjJ1/i5n+mN9KOcNwVs5VxKcuEQhx/N6GwvCEh+zes3pFoB4A5H4jmxjKxmH6OSTJuUu
         OMVw==
X-Gm-Message-State: AC+VfDzJecPiYUAZPE17IAr1IBa1PFDn9eL7geXHZb013UJcQcjdKqIX
        tvj+Y9NTgk0ZiNXzqjkcIJsVLQ==
X-Google-Smtp-Source: ACHHUZ6EzOphSjvsm0rKJMsTmt8Is1MGClCRLDgTL9TH/bpEFW/aAXPumSq1qDtE3CLs2hQr8LHSxA==
X-Received: by 2002:a05:6a20:258e:b0:10b:2203:6ab1 with SMTP id k14-20020a056a20258e00b0010b22036ab1mr7787961pzd.4.1685628849244;
        Thu, 01 Jun 2023 07:14:09 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a19-20020aa780d3000000b0064d45eea573sm5127718pfn.41.2023.06.01.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 07:14:08 -0700 (PDT)
Date:   Thu, 1 Jun 2023 07:14:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v3][next] scsi: lpfc: Use struct_size() helper
Message-ID: <202306010712.71318C84E@keescook>
References: <20230531223319.24328-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531223319.24328-1-justintee8345@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 31, 2023 at 03:33:19PM -0700, Justin Tee wrote:
> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> Link: https://github.com/KSPP/linux/issues/160

The SoB chain here looks weird -- I think this should include the C-d-b
tags as well:

> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Co-developed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

> Signed-off-by: Kees Cook <keescook@chromium.org>

Co-developed-by: Kees Cook <keescook@chromium.org>

> Signed-off-by: Justin Tee <justin.tee@broadcom.com>

But regardless, thank you -- looks good!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> Changes in v3:
>  - Instead of hardcode to 1, use be32_to_cpu(rap->no_of_objects).
>    (Justin Tee).
> 
> v2:
>  - Use literal 1 in call to struct_size(), instead of rap->no_of_objects
>    (Kees Cook).
> 
> v1:
>  - Link:
>    https://lore.kernel.org/linux-hardening/99e06733f5f35c6cd62e05f530b93107bfd03362.1684358315.git.gustavoars@kernel.org/
> ---
>  drivers/scsi/lpfc/lpfc_ct.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index e880d127d7f5..703429512ead 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3748,8 +3748,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
>  		rap->obj[0].entity_id_len = vmid->vmid_len;
>  		memcpy(rap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
>  		size = RAPP_IDENT_OFFSET +
> -			sizeof(struct lpfc_vmid_rapp_ident_list) +
> -			sizeof(struct entity_id_object);
> +		       struct_size(rap, obj, be32_to_cpu(rap->no_of_objects));
>  		retry = 1;
>  		break;
>  
> @@ -3768,8 +3767,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
>  		dap->obj[0].entity_id_len = vmid->vmid_len;
>  		memcpy(dap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
>  		size = DAPP_IDENT_OFFSET +
> -			sizeof(struct lpfc_vmid_dapp_ident_list) +
> -			sizeof(struct entity_id_object);
> +		       struct_size(dap, obj, be32_to_cpu(dap->no_of_objects));
>  		write_lock(&vport->vmid_lock);
>  		vmid->flag &= ~LPFC_VMID_REGISTERED;
>  		write_unlock(&vport->vmid_lock);
> -- 
> 2.38.0
> 

-- 
Kees Cook
