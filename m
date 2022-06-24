Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB09C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jun 2022 17:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiFXRso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jun 2022 13:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiFXRsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jun 2022 13:48:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C1B237E0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 10:48:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so6453525pjg.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 10:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zliD2Qsx7OubU1h4LVAM9OejLzFcsBaCjZJRdpEsKrg=;
        b=Pz4gqJjlBZdH2FUZf+LZ3Zk2c4Q5PjoLHgSJvUIfFCXLQ3s0DQzl2M7apET6Zy18l+
         gg0BY+PsbRil96ZfM2R0pnbNH0l4VO7BByOsiIJRLMuVeDsIjk5zBu5mdXPAuoNx6L7B
         hNj9RV6ELW7Ls1GQSQx6AOxZK02AhyVXkIwbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zliD2Qsx7OubU1h4LVAM9OejLzFcsBaCjZJRdpEsKrg=;
        b=bEBjW6GTnFxLTzWFeNpogT4YlNLVdrmO2GFre8EAuJ+6SjdIju7pKa8iEbCsLPTHPl
         fDltI4baOT0IpPySQ/W7nkWyuNbtPdEwbx86xIOdatjjs/hmPTDWIrM9agAhph28SYLi
         yaHmARsB3+b3LQL+Ve9o1G3htlNOdgp3LPy8sYL59QLssehRsEdBCiZcI5pcfQg0sABW
         xiFQ/SG/Z2XsVFD5hFDkSqBT3nN63z51GI9EnVJBbh64ACowRHhrgb5q5FglVHatZu4K
         bc53N+ia+Lb/7+DGdFnRcaeIpba1jMLJefsE8YVQzGhcHLmUM0YEO95YMoG4fVFEyauh
         QQ2g==
X-Gm-Message-State: AJIora+TMgYTRdmYUD8PZqd9NkbFv+SdvqQabhhGLtUb3GlEIBeGuvSu
        osT0xN64zguSoVI+/nu+Hah14w==
X-Google-Smtp-Source: AGRyM1uURdhPI99lDJvqkOTCp86a8zulQKgFl/xro0YHHIZMRm4Fw3TKtsoXL4ek9b2CUpM+7eruIw==
X-Received: by 2002:a17:903:2443:b0:16a:2b65:7edd with SMTP id l3-20020a170903244300b0016a2b657eddmr332318pls.20.1656092921012;
        Fri, 24 Jun 2022 10:48:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902e9c200b00168ba5ac8adsm2111628plk.163.2022.06.24.10.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 10:48:40 -0700 (PDT)
Date:   Fri, 24 Jun 2022 10:48:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 3/4][next] scsi: megaraid_sas: Replace one-element
 array with flexible-array member in MR_DRV_RAID_MAP
Message-ID: <202206241047.903049ED@keescook>
References: <cover.1628136510.git.gustavoars@kernel.org>
 <b43d4083d9788bb746dc0b2205d6a67ebb609b0d.1628136510.git.gustavoars@kernel.org>
 <202206221457.1A12D768EF@keescook>
 <20220623014533.GA7132@embeddedor>
 <20220623031401.GA8896@embeddedor>
 <202206230816.1383511C@keescook>
 <20220623153825.GA6458@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623153825.GA6458@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 23, 2022 at 05:38:25PM +0200, Gustavo A. R. Silva wrote:
> Which object files are you comparing here? because I don't see the zero
> change when comparing the before and after of megaraid_sas_fp.o with
> the change you propose.

Hm, maybe I did something wrong. But I was looking at megaraid_sas_fp.o

-- 
Kees Cook
