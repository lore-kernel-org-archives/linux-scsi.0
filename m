Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D25C10F14
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 20:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5DA21871
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 20:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linode-com.20150623.gappssmtp.com header.i=@linode-com.20150623.gappssmtp.com header.b="10wWLf0F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbfJHUUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 16:20:08 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:37230 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730523AbfJHUUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Oct 2019 16:20:08 -0400
Received: by mail-qk1-f170.google.com with SMTP id u184so95344qkd.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2019 13:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linode-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:autocrypt:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4ipQHNAGC9kSKB7kvRMIPYYFB3N/TVwuQvR/m304Wg=;
        b=10wWLf0Fnq4bZyPx6p9z6aSN/VYa53Yfue9gysAF2rPrd1u7ytP0rrTwjKr4bfVbzd
         z8p99whsigEybRPp/+Ll2MkOW776AX8HY1uEFmegnbp0Qcq2D5ERHPGWjvktGXMe0T1h
         Rqt8uVCYIkEjBCggpjbmrVDRhukOsPEF5rq27vm2fYPsc+2xDTET3vhiC7AajzUqMHkt
         1WzkYA9v2dPqFKehEV8PtH7QinZBmfLJdgjjIGwSNZp+O2dtliiLfyErYa0F2aBvusRv
         GylNZj8wEn3EnEJp2Ev+9vhmWGXP84NuS2Dsd3OkbvHIm2WwzVb6q0wJ/xYtyW1v/Ceo
         a+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=f4ipQHNAGC9kSKB7kvRMIPYYFB3N/TVwuQvR/m304Wg=;
        b=E5sHU2GXv6yJInlE3jXWrMAnntuUMAilEDUR6U3ikmFx9JXTe99p8FQl4rwQRMwdym
         TGdUAx6P8hxFCbMQ6jVzAej8iq57YLQHWx+SPF7wP77DliAfSfkhIcBARufd2YH+ZoV6
         t3UdtjjeYSc75Aq3wlQGhuRbdR6RsnoZSCLx30+vdCmIPLL1vfb9/TFvTy70PvLWxVZ3
         nL6W3AIwoRmYEheEd6tNVrhtKUy+q9f+HvVvhzNNhpUr0aCmp2xI3Ty6BTiArYZjV8SP
         3fxQboLHbOJdDokZ3ss1bBDTGUcpikErmFmzdd2fZ7LqarjcNCIvQk0+YzhOocVvzU7A
         HQuQ==
X-Gm-Message-State: APjAAAU/4czpgsNGF0a3A0TiRbvyZcnDb1nc5gl1kgWZbNPlzo6hPzdL
        jz6RFPC1w7Oupmfs9HiPaVMwHt5ws+oOMdq7azWcZEY6gcuMcEEvy6kjP/yXkhqfOsLwb0RzsPJ
        oOHkmpzTUTofwpVK1jW9lFuKqpSBcyY06bGyagnPYReoMdFbiiw6L2LzheuqeOE+baZkvOs7bsQ
        ==
X-Google-Smtp-Source: APXvYqwnx1l+WsAhu87u153FNSDzhgu9WPteyk67UxxCTnhVXsHsndfx353w1U9JmZyysved4muYMg==
X-Received: by 2002:a37:4149:: with SMTP id o70mr28799641qka.283.1570566006883;
        Tue, 08 Oct 2019 13:20:06 -0700 (PDT)
Received: from [172.16.22.130] ([172.104.2.4])
        by smtp.gmail.com with ESMTPSA id g31sm11843704qte.78.2019.10.08.13.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 13:20:06 -0700 (PDT)
Subject: Re: SCSI device probing non-deterministic in 5.3
To:     Bart Van Assche <bvanassche@acm.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <d2ff27ce-67b0-735e-8652-0e925d5f756c@linode.com>
 <f6d6622d-a9a0-d7de-b5af-b7a885ee1b61@infradead.org>
 <59eedd28-25d4-7899-7c3c-89fe7fdd4b43@acm.org>
From:   Bradley LaBoon <blaboon@linode.com>
Autocrypt: addr=blaboon@linode.com; prefer-encrypt=mutual; keydata=
 mQENBFnSOxYBCAC4hL/8AuiiKp/WamEAd5nf7JGVPHR5fZ2EmEgGtYOnypwaDY0uwFmTV4gR
 nJ8CCsBX7AtVKVLob+zwxaTFniRnamvcuirE5+sVGIChb2GVLAxjqRRXkrKYgisCjIwCXQFu
 FYKzpRksRaPZloLghlp36bAAPm7KIiACbb1W33PrxHHJPz99N5v3bJvc4/8cH1MoEOdnLHH1
 3zGzcyBeL3JIsRGS0jC3VT5qs9zO1DsL/X6vBYwYkjSve5vFCsTMmVKZFL8aeGDRt09/8EoM
 YlmgI/fctO8jHiF2VCMWH3Dq5i7NH+jYQ4/SqeXCxqhWlxXf+FXFS3eW741h9P7LB9RJABEB
 AAG0I0JyYWRsZXkgTGFCb29uIDxibGFib29uQGxpbm9kZS5jb20+iQFUBBMBCAA+AhsDBQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAFiEEbS4MuuHK2wr7CfjY2AcDUfXj3UAFAl1wERsFCQV/
 CYUACgkQ2AcDUfXj3UAlqAf/UrwkrW4kITCiOaIykfVogTbJ54RBwy9Qmi9HbWMG/o+wNwhO
 GDjD0l5362mXQVP2V/TQwrx/e1kGTTC5PFv/xN6vT1oXIwxzn1lezr5eBA53KgV2paBBZ4Qo
 ALpoI4UJn6YYIhD14BUw3Fn2o15a/pvSz9vxx70NjEbT1Or0gxaRZuam62fMbsLM327ikhau
 lWQSdVZs3rdMzFCz87F0CiwNtfKU730/JLeJGuIfXFDb8W/XLWc7JHaL8gIn+kS/0/Txgl8Q
 pfXQ6E2vnQojlXDmo4WYhbDxwzw4R9Kv8E6S25CuoP+8tmbHdB8NRXdhZ4nMU1TON5tKd1BG
 Sh+MobkBDQRZ0jsWAQgA5fxyts5E5WmgifFoVMfGmhPyGFE5KdYM2cREWypaTgRIWqxznDdM
 7ODabZzlWVrgW2o3DyzdRW6vXAW96lDB9Riug4kPTYOz8gkPuJG2SA1pGgkykLIVlpN28pFQ
 O4s0C0Xe4LxfzjniWtbshm0+fQCMfaA7/7A0iZiP2N6ikr8cYJw/nsQsMCrml5oStEl1T8/2
 oBzHz6VxsUuNlXxgurgDYJBRmlUMw3BV9aKgg7SgHhW19SmG3TfzydH5KXReLynCDMFnyXeW
 yNuBnuqgYI8VKiOSz5v+OfqhPGHvUdqUgTagVgLaEORdZB6Z84qM3jnHvZVtxT9KVca98vCn
 7wARAQABiQE8BBgBCAAmAhsMFiEEbS4MuuHK2wr7CfjY2AcDUfXj3UAFAl1wETMFCQV/CZ0A
 CgkQ2AcDUfXj3UBcQQf/YEjNvpWmsp3tMkECTl+Xaxsm5dyxn9+dM6VQ0vPeI5t/7tpevIJs
 a0jLeiTz5qa2uDZVd+LhlXj8oMoOYYQWa/3OwXaKgigtFTXSSrXimKVqvgf5LVpw3g83x/99
 mas/Kv+aJ9+6QA6dTYLEbMuzlt1TPF5go1watceQapxN09pkouoG5Yt/GhbX1OSg9WXiaOZ0
 USJ3f3jifWWJ7NkRV2yzio6IMqbStJtuk097PiVv7r2BUuurrYkWTQbVemBx2qDTpQHWuIn7
 nxR9YeutMRR02dm9249dQcA6GyF256HMQty/CDBiIX5xeth1OCgX8VL6SWcCSd0t/k3+zHw9 Ag==
Organization: Linode, LLC
Message-ID: <66c09da4-1041-ff8d-713a-5f67b87d1672@linode.com>
Date:   Tue, 8 Oct 2019 16:20:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <59eedd28-25d4-7899-7c3c-89fe7fdd4b43@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 10/4/19 11:39 AM, Bart Van Assche wrote:
> Have you already had a look at the /dev/disk/by-path directory? An
> example of the contents of that directory:
> 
> $ (cd /dev/disk/by-path && ls -l | grep /s)
> lrwxrwxrwx 1 root root  9 Oct  3 16:49 pci-0000:00:02.0-ata-1 -> ../../sda
> lrwxrwxrwx 1 root root  9 Oct  3 16:49 pci-0000:00:08.0-scsi-0:0:0:1 ->
> ../../sr0
> 
> Have you considered to use these soft links in /etc/fstab?
> 
> In case using these links would be impractical: have you considered to
> add a udev rule that creates H:C:I:L soft links under a subdirectory of
> /dev, that makes these soft links point at the /dev/sd* device nodes and
> to use these soft links in /etc/fstab? That's probably a much more
> elegant solution than what has been proposed above.
> 
> As one can see the information that is needed to implement such a udev
> rule is already available in sysfs:
> 
> $ (cd /sys/class/scsi_device && ls -ld */device/block/*)
> drwxr-xr-x 9 root root 0 Oct  3 16:48 2:0:0:1/device/block/sr0
> drwxr-xr-x 9 root root 0 Oct  3 16:48 3:0:0:0/device/block/sda
> 
> Bart.

Thanks for the reply! I wasn't aware that sysfs exposed the mapping that
way. That is very useful, and we should be able to utilize that.

Regards,
Bradley LaBoon
