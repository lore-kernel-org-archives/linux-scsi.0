Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDB8C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjEQXBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjEQXBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:01:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB13894
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:01:48 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae51b07338so9175535ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684364508; x=1686956508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7BzCe/htlM5mTAaSOzvP8pEpnyOYq7XwMu4hjpniWzo=;
        b=B/J7qvOTlzVBF6bH+lZ1fSjUgxLBV+R4eZ+jYhz/z7+S5IILF0ehttCPGNSyoMI3ub
         pZZlsX3zL98h9GWstYJknqvKryfgKw//T778pjlMZh+uODdCWwpS9hx/J36oaYLURxlS
         cyqOXevDrp4eByr5L4zRgmx+xnpgp96/7O1Pw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364508; x=1686956508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BzCe/htlM5mTAaSOzvP8pEpnyOYq7XwMu4hjpniWzo=;
        b=OJHL/j5MLISQgOZKchMESoEMR7XxOqWiavw/8D98jhTQuCFB7MzITYHlQo3HP+4dY2
         7hSaGO5IbvTnU8ij+333fq5JW5qT6bnBdGF7D9RkiE2aIYldB5HdKGc4f/+XerHkBXKW
         rsVs4UGk/gYScZbF0oP9erimIaa1ciQFO2B5uUAqO/+FZ84Nue3tPNEYE+zQfDC9V0Wi
         h+HCgt4lyYEZGV8Ue5+YObKQ8U35oL4zDEjMR1btP9U7R/dISSqrxOfNal5rj+ZVunlR
         z0BfAvnr7q6n8r0Uru25+6Q+1z+KbCbe1jzG26gJrdWbFbB7ogb6rqTiZzvoT+JDvWPc
         wSGQ==
X-Gm-Message-State: AC+VfDyqogtz7rCepYa1bi8PEBF2TVQu7x62ZGhUvfQZJbENIkWR8xks
        39sgh1klknzqaxk0OcHz8MxkLQ==
X-Google-Smtp-Source: ACHHUZ54qKIN5A4ugmU6aiQY1NXaOIPnQ8RUOJisfyPF5LS+vhwZWZ17iQt+hucvIjzEZ21J39EIWQ==
X-Received: by 2002:a17:902:e5c8:b0:1ad:fa2e:17fc with SMTP id u8-20020a170902e5c800b001adfa2e17fcmr530850plf.2.1684364508211;
        Wed, 17 May 2023 16:01:48 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902a41400b0019719f752c5sm9901606plq.59.2023.05.17.16.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:01:47 -0700 (PDT)
Date:   Wed, 17 May 2023 16:01:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2][next] scsi: lpfc: Use struct_size() helper
Message-ID: <202305171601.B3FF9D0BB@keescook>
References: <cover.1684358315.git.gustavoars@kernel.org>
 <99e06733f5f35c6cd62e05f530b93107bfd03362.1684358315.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e06733f5f35c6cd62e05f530b93107bfd03362.1684358315.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 03:23:01PM -0600, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index e880d127d7f5..3b95c56023bf 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3748,8 +3748,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
>  		rap->obj[0].entity_id_len = vmid->vmid_len;
>  		memcpy(rap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
>  		size = RAPP_IDENT_OFFSET +
> -			sizeof(struct lpfc_vmid_rapp_ident_list) +
> -			sizeof(struct entity_id_object);
> +			struct_size(rap, obj, rap->no_of_objects);

Has rap->no_of_objects always been "1"? (i.e. there was a prior
multiplication here before...

-- 
Kees Cook
