Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3754DEB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjF1UJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjF1UJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:09:03 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685AF1FEB
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:09:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b7e1875cc1so3285625ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687982940; x=1690574940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kD2OEdZdTzzghvOs1OtoVVgGOc4SQ+lxa4knp1TJQ4I=;
        b=N9gpBLBiCFJKXDKwt98HxNss1tSUuUjNAoPP5v+TPKBnX9fySyU0vI2sYZjMSzpiTF
         E9VF6p0ar88k5NynZdY5rkTT3KSZre5QlPyvW26ABMhgaIIFVcC1XA7CrK8KSVt6Q/27
         1SIOteWSqj5H5qSXU0Tr54JL5ckntDnJZCp+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687982940; x=1690574940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kD2OEdZdTzzghvOs1OtoVVgGOc4SQ+lxa4knp1TJQ4I=;
        b=enaHVlLVll5ooVfaYk4wYPoxd/2TTwYubKYoxC3//lNfy4RUzuE+jC6nRc6EkVdgj3
         cHTAp/Mq7UpoxkcL9GrcTW8WZsLLXMxKT45qwZ+n6a5kvDcbdTX4Diu/gRUGo9AZfNSl
         1Iu4JCEGVHYkDqGkffwS205XrGpfWk7RnfmIUBeun6WMOqULorPaEC+GFwijUAbuMQZ3
         BJ4hSW/dME7hXeLCiIo2vX45mh3Acu+MRvEr2aSxxxfo2Vkx4uRA7v3Cmbsgk7dWo55L
         uzODklbp7I7KCCP6o/6swCpdcm9yxcAh62Q+Fuqpe5/ikevZ8RrqgLV3Y5zIeRyLrtwJ
         Bo8Q==
X-Gm-Message-State: AC+VfDx+LtCBwileYRosdP4PzovyouHGtYn1cp5mJU6bENGrhWWRHERK
        7wgmpvC557B7zRfNRRJNrW7yHg==
X-Google-Smtp-Source: ACHHUZ7zGIrMnjKfjDm04NUqas7nZLV2QYUC7y9FPVci064C1JvJ8VEzq0kae/AsVkSOVLQO17YoKw==
X-Received: by 2002:a17:902:c40d:b0:1b5:5bf2:b7e2 with SMTP id k13-20020a170902c40d00b001b55bf2b7e2mr11799831plk.6.1687982940470;
        Wed, 28 Jun 2023 13:09:00 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709028c8700b001b03842ab78sm8054527plo.89.2023.06.28.13.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:08:59 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:08:58 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 00/10][next] scsi: aacraid: Replace one-element arrays
 with flexible-array members
Message-ID: <202306281307.BB7B4369F@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:53:45AM -0600, Gustavo A. R. Silva wrote:
> This series aims to replace one-element arrays with flexible-array
> members in multiple structures in drivers/scsi/aacraid/aacraid.h.
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> These issues were found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://github.com/KSPP/linux/issues/79
> 
> Gustavo A. R. Silva (10):
>   scsi: aacraid: Replace one-element array with flexible-array member
>   scsi: aacraid: Use struct_size() helper in aac_get_safw_ciss_luns()
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct aac_aifcmd
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmapraw
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmapraw
>   scsi: aacraid: Use struct_size() helper in code related to struct
>     sgmapraw
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmap64
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmap
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmap64
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmap

I'd like to reorganize this series so that all the conversions are
first, and then struct_size() additions are at the end. That way, if
desired, the conversions can land as fixes to turn the Clang builds
green again.

-- 
Kees Cook
