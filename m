Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C984C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F260C61445
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhDVDV3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 23:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhDVDV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 23:21:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4143C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 20:20:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nk8so7384265pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 20:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YmmSdM90pO+sNar6XOrbSuxi/vNNsjBBP9QqUAGRLKs=;
        b=N4rfBPuNckMo+Fl/dEflNtB4rmTU6SHg0TMhaV0iuduYgSiQaUq6hI4moIv83mvcLK
         8i3XJyR/+rQgXenMfAXPOVN2FRqj+oybQNJHs5Vh8onyTvKFr4mUOhbagxlbJ/E/YnJJ
         3SlYXItdKqok6r2OWgFY1wRNX+EowDgvIQZEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YmmSdM90pO+sNar6XOrbSuxi/vNNsjBBP9QqUAGRLKs=;
        b=LBwibBOmqrP7RT+rCW6fBYKwcxw8s9RKGFfcYqQKTxxc6jkOiUaMez1pSsZbPtI8vH
         3ckbKhF4RkvrEwG3+/ZRPpJT3jytiqdvbyIv9Dthl7sgtmt3nZ9DvMZZYF1JXfftrc9F
         3NtaSyciOwJA01u4FXqi5CKZZJfWvcBjElNsV18vQWpr0iIeCYOfAkIIS7CqF7tYbBnb
         7mGw6M3nIcrP/+4Vx3L5n4sF+iyPbrdDGDaWWknFHgndhrwZu1zVISv6nJBNlfHAQsvN
         evpdYNXdWh05SXksvZsOysMELTg5pZZ+qJH4laEVXWRBPaij29Es7bYlWN8gbSspEb5M
         XzOA==
X-Gm-Message-State: AOAM530YFUE4s3jIhzxuU0yUEz9V3RdHP1oXpilrwQTu1JW40C+qZPsP
        vkgGthm7NZbY2H3Ny86rpcd9Yg==
X-Google-Smtp-Source: ABdhPJxXE21iqS93U9HQ1ku5cSKxhO6e51gwHM/EuN1XMjVT+yzg7TfUzLT6zz0CaK+8lBiRuj7KQA==
X-Received: by 2002:a17:902:7b8e:b029:ec:982d:7a7e with SMTP id w14-20020a1709027b8eb02900ec982d7a7emr1426937pll.55.1619061653273;
        Wed, 21 Apr 2021 20:20:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m7sm552380pfd.52.2021.04.21.20.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 20:20:52 -0700 (PDT)
Date:   Wed, 21 Apr 2021 20:20:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
Message-ID: <202104212019.4315F80C@keescook>
References: <20210421185611.GA105224@embeddedor>
 <yq18s5bt42e.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq18s5bt42e.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 21, 2021 at 11:03:19PM -0400, Martin K. Petersen wrote:
> 
> Hi Gustavo!
> 
> > Changes in v3:
> >  - Use (nseg_new-1)*sizeof(struct sge_ieee1212) to calculate
> >    size in call to memcpy() in order to avoid any confusion.
> 
> The amended memcpy() hunk appears to be missing from the v3 patch.

It's unchanged from the perspective of the original code. (i.e. there's
no need to change it since that memcpy isn't involved in anything
changed by the swapping to the flexible array.)

-- 
Kees Cook
