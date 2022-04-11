Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D5BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 16:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348633AbiDKQdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 12:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348655AbiDKQdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 12:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 130C331907
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 09:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649694685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9npo1nqXaxbPxEQzLk6Betnt1M5YLmZj/dlQsw0KH3E=;
        b=AZGAFAw9nXwNiNvUmodrL3DhNvbsVuRRFe3Ij9ik+5WjjpASoXQJWTMmpHa78m0c9KCPl/
        fg5d+EB/b7iJ/3e98ch3ZVqUilDCY94hLGvLIMCJmym5xR9ndFqA+/nh+/ZzVG/W3UwS6U
        mf1d5xEtrXDMusWEwtoRmf1fZk32XKQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-I6A7eE3zMFegj2rRABv8Zg-1; Mon, 11 Apr 2022 12:31:24 -0400
X-MC-Unique: I6A7eE3zMFegj2rRABv8Zg-1
Received: by mail-qt1-f200.google.com with SMTP id a24-20020ac81098000000b002e1e06a72aeso13060858qtj.6
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 09:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9npo1nqXaxbPxEQzLk6Betnt1M5YLmZj/dlQsw0KH3E=;
        b=Mh8vzDxH2LTmT8imDlE1rPiN/8eBfPIUNdt/x/MVOcio3TKg7Cr/st6jLZMju9tp9K
         96w1AWROjmPwASqVUD2finC2pPx1Py38RnpS6xXCH+vay5/lJw43gTS7dL/kY6M7+2dO
         ginNpyyG0qQoAtcS9yMW5lf6kfI8/wH/QcBkdITTw3qiOApAWuA5ZERQW2k+7BSdj3An
         ylxQA35sH/nWb1IbWl4LlEpe6MwInLDAvCjyU1JF5lOAsTcL7ynKMbeYYaOi0mKim7KF
         ThFbrWHmQNBFv8MMuXS1WaRJQelqpGsq2DAqWOnvMjPEWpLQrYe4MEssFoIvm0LbSiDt
         ofaQ==
X-Gm-Message-State: AOAM530kbUcyLexr5/BH3nc0J8/mups7XdEV8icmL84UDmgQl8bJkAB5
        IjpOb1hQXOLVu9IaqkQWE4EWMdwoZeda8WoBaDxeiLLSuCiF6dDptj+mizZm3neriN6rnPkd6rl
        gMe+xnu8N+MyDKsgjDju4hg==
X-Received: by 2002:a05:620a:1024:b0:69c:2e0f:d020 with SMTP id a4-20020a05620a102400b0069c2e0fd020mr160243qkk.108.1649694684320;
        Mon, 11 Apr 2022 09:31:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIBbuzUKRKdpRu1szbFKkqYCYu3AmHHhLAg8TDSWf8+WPdx1Tx8DzyFwTfgzm1rUwE2RhpZg==
X-Received: by 2002:a05:620a:1024:b0:69c:2e0f:d020 with SMTP id a4-20020a05620a102400b0069c2e0fd020mr160226qkk.108.1649694684121;
        Mon, 11 Apr 2022 09:31:24 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id s31-20020a05622a1a9f00b002e1df010316sm26851091qtc.80.2022.04.11.09.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 09:31:23 -0700 (PDT)
Subject: Re: [PATCH] security: do not leak information in ioctl
To:     Christoph Hellwig <hch@infradead.org>
Cc:     tim@cyberelk.net, axboe@kernel.dk, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev
References: <20220409145137.67592-1-trix@redhat.com>
 <YlREKRb/xgAFsi97@infradead.org>
From:   Tom Rix <trix@redhat.com>
Message-ID: <eec2efee-1153-8d8e-77c2-96156733a0c6@redhat.com>
Date:   Mon, 11 Apr 2022 09:31:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YlREKRb/xgAFsi97@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 4/11/22 8:07 AM, Christoph Hellwig wrote:
> Wrong subject prefix, and this really should be split into one patch for
> pcd and one for sr.
ok i will split
> The sr prt looks sensible to me.  But for pcd why can't you just
> initialize buffer using
>
> 	char buffer[32] = { };
>
> and be done with it?

The failure can happen in the transfer loop, so some of the data will 
not be zero.

And checking status should be done.

zero-ing is because i am paranoid.

Tom

>

