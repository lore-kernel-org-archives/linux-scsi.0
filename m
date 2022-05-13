Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70773C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 15:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382186AbiEMPoo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382188AbiEMPol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 11:44:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F0F3A71A
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2022 08:44:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i1so8316969plg.7
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2022 08:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptf+f5eGDE5JGEu9b++jcke6m+bu7vV+b5hUvmlYQQo=;
        b=SjhK1c9Qotr1qDOqwKlBj3Rw1mlIdcXMiMnONLsDWXIlWQego7JtnDd+2u8lNhcb5o
         VntS/+cGhwP5NiXqFa0xo4Eurcd+QW1c6ntV0GvlsEyq5axRcQY1ctFnycyCWVGns4We
         RoLfLtxqMSNKYzeck8DbrFFmqTXggtzGcj49k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptf+f5eGDE5JGEu9b++jcke6m+bu7vV+b5hUvmlYQQo=;
        b=xWTPs+YMmFuasHSJuncPM60PJ+2+yMqPPfKSHqA4nuqEFfAnLUA03ZPYyA+97UCyw7
         fExklRWYKwEYAa3LSyyliI0SPi4NES6simvk70nUcgRP80ykgv7U15rRr4Emy0CYprGr
         hTQ9IdLAjsNc4v1q7Py1vItnlXkq5SJ1/J/PfFEiE+RoMDQrgNAS3YLZqvL6Ts3gedYj
         ypKvO8/2WthZVA1e0hb3rVRTzCTbi5uoNUC2y2+H5xe7mZqsLYWq2ZhN1ZzpzhNUoKA3
         nNMul7RqlrrUW7Ya1NGk8Gx2xarAtknpBaqLxGwTqDLoqXdjzwQPvxW3e4nZG4s7SaOe
         nthw==
X-Gm-Message-State: AOAM531Qn1uILd44X6DrQ3VF7fepaloYMqbwpKCcbQJEh/H3Vs0yLUQI
        Y3Lct+1SgurVkmdKfp8RFQTh5Q==
X-Google-Smtp-Source: ABdhPJxasBICZO798rz+17+y+t9nZitCCqENVQI5RwTabPKWbsVJ7C2OmZDJ+yTA2ILgpXFaCw37jw==
X-Received: by 2002:a17:902:ecc8:b0:15e:9e46:cb7e with SMTP id a8-20020a170902ecc800b0015e9e46cb7emr5389423plh.111.1652456677896;
        Fri, 13 May 2022 08:44:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b0015e8d4eb1c9sm2059662plb.19.2022.05.13.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:44:37 -0700 (PDT)
Date:   Fri, 13 May 2022 08:44:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Howells <dhowells@redhat.com>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 19/32] afs: Use mem_to_flex_dup() with struct afs_acl
Message-ID: <202205130841.686F21B64@keescook>
References: <20220504014440.3697851-20-keescook@chromium.org>
 <20220504014440.3697851-1-keescook@chromium.org>
 <898803.1652391665@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <898803.1652391665@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 12, 2022 at 10:41:05PM +0100, David Howells wrote:
> 
> Kees Cook <keescook@chromium.org> wrote:
> 
> >  struct afs_acl {
> > -	u32	size;
> > -	u8	data[];
> > +	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u32, size);
> > +	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
> >  };
> 
> Oof...  That's really quite unpleasant syntax.  Is it not possible to have
> mem_to_flex_dup() and friends work without that?  You are telling them the
> fields they have to fill in.

Other threads discussed this too. I'm hoping to have something more
flexible (pardon the pun) in v2.

> [...]
> or:
> 
> 	ret = mem_to_flex_dup(&acl, buffer, size, GFP_KERNEL);
> 	if (ret < 0)
> 
> (or use != 0 rather than < 0)

Sure, I can make the tests more explicit. The kerndoc, etc all shows it's
using < 0 for errors.

-- 
Kees Cook
