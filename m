Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BA6C5517A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 13:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC4122250
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 13:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUp+Tm/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407738AbgJTN4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 09:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407722AbgJTN4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 09:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603202163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyQ28xr5/lapv6azTtFCvHFT5XQ1+OzeHk+84iEm66Y=;
        b=QUp+Tm/49C2D2ArfwdGiXcYEZLmxY3ITF9bXZyS+HEfcJJoqaGxmch+2EHiNHeADDWpHNz
        Ouzap4oFcZixuWmorb4Ub+lRVmWRZDipZO+0tL8W1vnU06zVM/xfLz81/8VfcBPp80A1RW
        EdBHqnK2mgm1gY9dzcmZeB2rW1Al8Fc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-1_ZNXiz_NAW6GGspxz0gnQ-1; Tue, 20 Oct 2020 09:56:01 -0400
X-MC-Unique: 1_ZNXiz_NAW6GGspxz0gnQ-1
Received: by mail-qv1-f70.google.com with SMTP id l1so1423610qvr.5
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 06:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HyQ28xr5/lapv6azTtFCvHFT5XQ1+OzeHk+84iEm66Y=;
        b=Iklsu8jNVrLHAoSnSMVCFIB5RPlZe/ya0CSguQ7SMNUDBQkOwNi2Nc4SOd2LJ20rIP
         YnJj3lPxyvKrU7nNy6STnFZtdFRTrRFJ8TVw5qhcgaSpRv1Vc7oshLdlz6ok+ku1283O
         LBhYRtVm5OCgCL4ScoBImOmCj00HvfHPXTr0bVRcagfj/qcWT9FH824AZsNqHpMkytnz
         8aoeyzhgwZqGnD3nc4y7g3zp8kQ9fCKMG1/sLymAXNiyWcnp2Qmeu0cHytpX2QJfOVzb
         ws7H+wP1+I0tJnjJog5YaBZ3DGB9hkmPtQ4qCRyAg+Hc5/IaKb4+2NzDh+jhUBQpWCe2
         J+YQ==
X-Gm-Message-State: AOAM533t2u+62Lpq6EhztPv93cJ5+CxAwMESOuydIeXTxyJnMNg8xzH3
        fag9cZmMZwaLLISjXERTdciIRcaODOqRf3Cr2GytLtG6VKi9mY/DjRhbOg6VMQI/pBhMNqnsZok
        YCmY+NhyTDyb8gjPAKqHJRQ==
X-Received: by 2002:a05:6214:174f:: with SMTP id dc15mr3370426qvb.25.1603202160687;
        Tue, 20 Oct 2020 06:56:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLUAfqrAOJzxwKF3+voCBF5yQYNbMOvfOkDZhumkJj3bEnT15V4x8vUJ5iQ5pWt9KusIZtsQ==
X-Received: by 2002:a05:6214:174f:: with SMTP id dc15mr3370377qvb.25.1603202160139;
        Tue, 20 Oct 2020 06:56:00 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id b8sm775938qkn.133.2020.10.20.06.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 06:55:59 -0700 (PDT)
Subject: Re: [RFC] treewide: cleanup unreachable breaks
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-power@fi.rohmeurope.com, linux-gpio@vger.kernel.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-can@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com, linux-nfc@lists.01.org,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, patches@opensource.cirrus.com,
        storagedev@microchip.com, devel@driverdev.osuosl.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        bpf <bpf@vger.kernel.org>, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        alsa-devel@alsa-project.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        George Burgess <gbiv@google.com>, Joe Perches <joe@perches.com>
References: <20201017160928.12698-1-trix@redhat.com>
 <20201018054332.GB593954@kroah.com>
 <CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <ca1f50d6-1005-8e3d-8d5c-98c82a704338@redhat.com>
Date:   Tue, 20 Oct 2020 06:55:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/19/20 12:42 PM, Nick Desaulniers wrote:
> On Sat, Oct 17, 2020 at 10:43 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
>>> From: Tom Rix <trix@redhat.com>
>>>
>>> This is a upcoming change to clean up a new warning treewide.
>>> I am wondering if the change could be one mega patch (see below) or
>>> normal patch per file about 100 patches or somewhere half way by collecting
>>> early acks.
>> Please break it up into one-patch-per-subsystem, like normal, and get it
>> merged that way.
>>
>> Sending us a patch, without even a diffstat to review, isn't going to
>> get you very far...
> Tom,
> If you're able to automate this cleanup, I suggest checking in a
> script that can be run on a directory.  Then for each subsystem you
> can say in your commit "I ran scripts/fix_whatever.py on this subdir."
>  Then others can help you drive the tree wide cleanup.  Then we can
> enable -Wunreachable-code-break either by default, or W=2 right now
> might be a good idea.

I should have waited for Joe Perches's fixer addition to checkpatch :)

The easy fixes I did only cover about 1/2 of the problems.

Remaining are mostly nested switches, which from a complexity standpoint is bad.

>
> Ah, George (gbiv@, cc'ed), did an analysis recently of
> `-Wunreachable-code-loop-increment`, `-Wunreachable-code-break`, and
> `-Wunreachable-code-return` for Android userspace.  From the review:
> ```
> Spoilers: of these, it seems useful to turn on
> -Wunreachable-code-loop-increment and -Wunreachable-code-return by
> default for Android

In my simple add-a-cflag bot, i see there are about 250

issues for -Wunreachable-code-return.

I'll see about doing this one next.

> ...
> While these conventions about always having break arguably became
> obsolete when we enabled -Wfallthrough, my sample turned up zero
> potential bugs caught by this warning, and we'd need to put a lot of
> effort into getting a clean tree. So this warning doesn't seem to be
> worth it.
> ```
> Looks like there's an order of magnitude of `-Wunreachable-code-break`
> than the other two.
>
> We probably should add all 3 to W=2 builds (wrapped in cc-option).
> I've filed https://github.com/ClangBuiltLinux/linux/issues/1180 to
> follow up on.

Yes, i think think these should be added.

Tom

