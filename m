Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15DFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352005AbiEDPRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352068AbiEDPQw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:16:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E71443EC7
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 08:13:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 6so1373161pgb.13
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2022 08:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K5o0mxzRhIj/1qVaf+Qsisfgid2WQLM66dSEL7WW688=;
        b=XkqjtCLvOAHdMweJpAE7OFgXj0jWG7id7d0Hhskj9BPIqKJFUoqoOWLf2YUT5xAOL1
         wZmhUNtZAmbQT4d6fpbwfM2QOncu2zNn3djMX16s2PmGSDIstIDxugPIALaO8utyKIj7
         sKwWZedxfPJh4WLIB65ege/77jViBz9SzZ4sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K5o0mxzRhIj/1qVaf+Qsisfgid2WQLM66dSEL7WW688=;
        b=xFwRxbDhC3rnrcO9Gr+4PqVg1+6GDj8X6tGzyhH2nqR4w/843U2CBBojz/SdRfJWOZ
         x+lWO9auB/zN9ER1Al5q/GXdMtdTIj26Z+fLPynQgwo4K4T5oTyewmrDSUNAsk3E39eF
         r4K5Ni0bz15igIr4cw22eIlflW7QWDdipGVySPZ/hYB2VXoimrx0HhQAzfJNK5Rwe7G7
         l5VFTfn6Zyw4FXQZSzRp8m07F8QqvKH4XmjibduYVy4Og+GaNK4NxwTzUZZ6ZE6B1rL0
         //92kwgKxAjUh+MEhNSuCkE3lVDVhFYesQXkJ0LoJI3fkDIXDkWmc1ssC4S1ezvXQm5B
         CQ6Q==
X-Gm-Message-State: AOAM532JzYWIWvlLzUAr2F8lj2a/fKk7F5t+JU1jk3on2fvfEb6Zqclj
        PN16KQ61eizHxMrFOvma9GykJg==
X-Google-Smtp-Source: ABdhPJz90TOpMyff1PtQa6IsHmC44gl1STwuqZnossp54kBJNr59JnE6SQEpdVpiz10qBB7q+ENACA==
X-Received: by 2002:a63:9d46:0:b0:3ab:573b:d7ca with SMTP id i67-20020a639d46000000b003ab573bd7camr18269533pgd.349.1651677193254;
        Wed, 04 May 2022 08:13:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902b20100b0015e8d4eb20bsm8443013plr.85.2022.05.04.08.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:13:12 -0700 (PDT)
Date:   Wed, 4 May 2022 08:13:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
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
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
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
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
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
Subject: Re: [PATCH 12/32] cfg80211: Use mem_to_flex_dup() with struct
 cfg80211_bss_ies
Message-ID: <202205040811.05D7E61@keescook>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-13-keescook@chromium.org>
 <c31c1752cf6393319f5c7abd178ef43e0fbec5c1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c31c1752cf6393319f5c7abd178ef43e0fbec5c1.camel@sipsolutions.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 04, 2022 at 09:28:46AM +0200, Johannes Berg wrote:
> On Tue, 2022-05-03 at 18:44 -0700, Kees Cook wrote:
> > 
> > @@ -2277,7 +2274,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	size_t ielen = len - offsetof(struct ieee80211_mgmt,
> >  				      u.probe_resp.variable);
> >  	size_t new_ie_len;
> > -	struct cfg80211_bss_ies *new_ies;
> > +	struct cfg80211_bss_ies *new_ies = NULL;
> >  	const struct cfg80211_bss_ies *old;
> >  	u8 cpy_len;
> >  
> > @@ -2314,8 +2311,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	if (!new_ie)
> >  		return;
> >  
> > -	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, GFP_ATOMIC);
> > -	if (!new_ies)
> > +	if (mem_to_flex_dup(&new_ies, new_ie, new_ie_len, GFP_ATOMIC))
> >  		goto out_free;
> >  
> >  	pos = new_ie;
> > @@ -2333,10 +2329,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
> >  	memcpy(pos, mbssid + cpy_len, ((ie + ielen) - (mbssid + cpy_len)));
> >  
> >  	/* update ie */
> > -	new_ies->len = new_ie_len;
> >  	new_ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
> >  	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
> > -	memcpy(new_ies->data, new_ie, new_ie_len);
> 
> This introduces a bug, "new_ie" is modified between the kzalloc() and
> the memcpy(), but you've moved the memcpy() into the allocation. In
> fact, new_ie is completely freshly kzalloc()'ed at this point. So you
> need to change the ordering here, but since new_ie is freed pretty much
> immediately, we can probably just build the stuff directly inside
> new_ies->data, though then of course we cannot use your helper anymore?

Eek, yes, thanks. My attempt to locate the alloc/memcpy pattern failed
to take into account anything touch the source between alloc and memcpy.
I'll double check the other examples.

-Kees

-- 
Kees Cook
