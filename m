Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD0BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiKPWY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiKPWYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 17:24:47 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C86132BA3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 14:24:45 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k7so17754114pll.6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 14:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H0Wl4WXlZ9TtxCS/7cbCnqRMePuRd+lB/ZGpLWihPag=;
        b=Z1e+Sc3OetTCAQVdLTOaCpJQhUAM41Z5P5Zm1uYJoWTHvOeggqH4IDrkjIc7NGsNZz
         q8RzSMAQ6wffrTcixCdTMO8NP/R+3GqN77eQRMHUdLkjfb/Wqphq4NPG70Brt+E7SzFR
         8XnD+jPys9D8fH40n/994uKnYFzZ1sntvg/ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0Wl4WXlZ9TtxCS/7cbCnqRMePuRd+lB/ZGpLWihPag=;
        b=WWatfjnFWaYOOdKj6BPby4BSf7nWj7DRli3bTDDEkmfp5EUVkiyLECZRuFShyVfMSW
         Amsi3qThlqUcPukj02AVxB994zGAQvAGikQx4SYAJZPy9STYvsxz8Y3X9Lju2HVnfEIN
         4WQATqdJpKpoGxNe1ZTv3zruB8wlnuetddlZgSd2FV87U/dDveceVx+6EHGYXQeEPNcK
         synQvs2tkfOw9Hj/47eXK+xDlF2NCiIIoG45k4HFk1VcMrrmfA2c+TSt20+tIeQ8lbao
         WwyT0EsFpGwGb7gW41hdYcqcZJvjFe6lIG4O3xxxK/ZvNtHXHvhozQgwXRsDwFENp05k
         4GlQ==
X-Gm-Message-State: ANoB5pmxxFfxlFu8Fji76P413o0NkR8hUF6VCKtHK9RQrCGYVEmZVD5T
        eOgwERIJE8u12vSYWCr1QtnLmw==
X-Google-Smtp-Source: AA0mqf4rz5uYxs0pdlSPjexuCrjBLrAOCIIqlFBQmnF0VeQWmRXzPz48Qx95Oo5rNx5HXl9GQBIZjg==
X-Received: by 2002:a17:903:2642:b0:178:b4b7:d74d with SMTP id je2-20020a170903264200b00178b4b7d74dmr10795273plb.83.1668637485474;
        Wed, 16 Nov 2022 14:24:45 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b0017f7628cbddsm12774143plh.30.2022.11.16.14.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:24:44 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:24:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: bfa: Replace one-element array with
 flexible-array member
Message-ID: <202211161424.A47F4BAD1@keescook>
References: <Y3P1rEEBq7HzJygq@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3P1rEEBq7HzJygq@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 15, 2022 at 02:25:16PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct fdmi_attr_s.
> 
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/209
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
