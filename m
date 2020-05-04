Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1D0C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 11:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6821C20752
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 11:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ctESzeT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgEDLhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 07:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728270AbgEDLhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 07:37:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F5FC061A0E
        for <linux-scsi@vger.kernel.org>; Mon,  4 May 2020 04:37:52 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id i7so7756728qkl.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2020 04:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ylHmL3MlF35GEQB2FmgIpVN3gT11kUeMdOvLET/1Ok=;
        b=ctESzeT6nmUBI45i6UDvnKeo8bYKgcdyqGH6aiqhMWeUZ0lE1reUea0/8jv9ssYz5l
         Qx9Fl/+XLUgNElSwHMwEag6vKymEuyBglY9gRLqlPhj1xcCNwllB/4+txdH0I0SSiG/t
         /EGbVJGDsjB9QBFeZ1l+8WSIWX6JQt2Q4lgWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ylHmL3MlF35GEQB2FmgIpVN3gT11kUeMdOvLET/1Ok=;
        b=Wc+lJ+s5Q8T61+tNG4znIV6GM97dthJsyzF0TfqL2vBwFgFbp9YSIFdISe8A1JqTKD
         d164fLX21mTqiPoGj9UsLPqBf8XR3Mya0gvKfb9rbuXFH55bSXsWASoWD4XBelZ2K9xK
         tttXXFnNpKXw2+LEi0OygmTpAtlAExXsQfMswOtlclSVScC3DIqBKTUCPAXfDQ42sg9c
         Qt4FNQWZiG2JrgXRMtIVc8L0LNjIkzUBaKnKjAluF1woSgLjclFqcjqqwDY513bQM3bZ
         j6aBlNbFOb7n2Sqd5TM7Na0sBGuqi7FvXdQyRdNuFO72oQ15Dil1Ra582ZlsmRA8My+L
         P5RQ==
X-Gm-Message-State: AGi0PubnmQ/QBsfKGz5u4PKRYpQ6hCbIET0VRa4I5i1ANwTqk9/9rE3J
        6be04hdjAj+b5joESPyu4ipcBXYKwHYb7/aeMllcsl91VL8PNg==
X-Google-Smtp-Source: APiQypL4zQhtd2pBCrTeLeUbTw5nm5HYcW1I9wRu2oWb+EOPWpGl5lX0W77hvJeehqma6QotbeBTLRZbdjl+9Mt65og=
X-Received: by 2002:a37:6797:: with SMTP id b145mr11012121qkc.350.1588592271359;
 Mon, 04 May 2020 04:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200429142149.GA823478@mwanda> <20200501095311.GD1992@kadam>
In-Reply-To: <20200501095311.GD1992@kadam>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Mon, 4 May 2020 17:09:30 +0530
Message-ID: <CA+RiK67eijyKw_SJSEqkf1Aw6yF1GEF5o8ksmiuUW+z2WfoLWw@mail.gmail.com>
Subject: Re: [bug report] scsi: mpt3sas: Handle RDPQ DMA allocation in same 4G region
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,

We will post the patch with fix as soon as possible.

Thanks,
Suganath


On Fri, May 1, 2020 at 3:25 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> This also causes a bug in the callers.
>
>     drivers/scsi/mpt3sas/mpt3sas_base.c:7428 mpt3sas_base_attach()
>     warn: 'ioc->hpr_lookup' double freed
>
> We free the pointers, then return an error and the caller frees the
> pointers as well.
>
> Smatch is very limited in the types of double frees it looks for.
> It really requires someone to manually go through the free paths and
> check it by hand because I'm sure there are other bugs there as well.
>
> Please CC me on the Fix because I'm not subscribed to the linux-scsi
> mailing list.
>
> regards,
> dan carpenter
>
