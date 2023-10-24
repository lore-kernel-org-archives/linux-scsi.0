Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CB4C07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 13:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbjJXN6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 09:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbjJXN6J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 09:58:09 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E894170A;
        Tue, 24 Oct 2023 06:57:54 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ba172c5f3dso3740580b3a.0;
        Tue, 24 Oct 2023 06:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698155873; x=1698760673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHLUl2rviwOEYzkUoWMIc0UMrw0kyEP+QEE0nMFVMXY=;
        b=D23svdP9Ltx6TLLf0VP9RFdZKbfwpd8SdTZ/wHVttGghuE5v6fqZzLRUpo6B8SpuIa
         opjxnshJFzGM9JE4r2tMbCE8gJy/oo8sbmeBUXf+xI7ba5/XAk4izGjBU1WA3mUyok3D
         u+LraRzq/NWbPrf2TJOD5xtPCtrPYsmy/UPhbzr6Mgvy4KBm8N1pu28d5mGeQPqXMPzP
         Zt9AfGw5RX+92q3pWlj8l4xfF9N2AO2vwBWd5cb5NpmjJvYQ0lvjjTc3pMBiHphp8oHR
         0uS9+b1UOXwvHNO+fOrTEScvK7JToj23Qk+a4b3s49d5/IfyTXzZF8bc+5l5QBBbNXLd
         LTgQ==
X-Gm-Message-State: AOJu0Yw8LFACtYPdwI/2c72tF2I7uatQfJlp3OgoB6FxI4pNCeeZ3cco
        d9IbNBEQiGJPlDh3k1pHljk=
X-Google-Smtp-Source: AGHT+IE5qx6HN3EzbKUIwvWTv+TC582ScGTYgsPVwjueuwXYih+yxExY/typ39RJ86V4tTyBd6Kg8w==
X-Received: by 2002:a05:6a20:bf19:b0:17b:cd83:6555 with SMTP id gc25-20020a056a20bf1900b0017bcd836555mr2103715pzb.23.1698155873483;
        Tue, 24 Oct 2023 06:57:53 -0700 (PDT)
Received: from ?IPV6:2601:642:4c01:f978:8cc6:940d:123f:6f04? ([2601:642:4c01:f978:8cc6:940d:123f:6f04])
        by smtp.gmail.com with ESMTPSA id 23-20020a630f57000000b0059cc2f1b7basm7070593pgp.11.2023.10.24.06.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 06:57:53 -0700 (PDT)
Message-ID: <aa259295-1ec9-41e1-9527-409f3799e8df@acm.org>
Date:   Tue, 24 Oct 2023 06:57:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: blktests: running nvme and srp tests with real RDMA hardware
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Daniel Wagner <dwagner@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>
References: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 19:59, Shinichiro Kawasaki wrote:
> Hello blktests users,
> 
> As of today, software RDMA driver "siw" or "rdma_rxe" is used to run "nvme"
> group with nvme_trtype=rdma or "srp" (scsi rdma protocol) group. Now it is
> suggested to run the test groups with real RDMA hardware to run tests in
> more realistic conditions. A GitHub pull request is under review to support
> it [1]. If you are interested in, please take a look and comment.
> 
> [1] https://github.com/osandov/blktests/pull/86

When I wrote the SRP tests, my goal was to test the SRP initiator
driver, SRP target driver and dm-multipath drivers and also to allow
users who do not have RDMA hardware to run these tests. Running these
tests against a real RDMA adapter tests other functionality than block
layer code. I see this as a use case that falls outside the original
scope of the blktests test suite. Running NVMe tests against a real
storage array also falls outside the scope of testing block driver
functionality. I'm fine with adding this functionality but I hope that
it does not become a burden for blktests contributors who are not
interested in maintaining functionality that falls outside the original
scope of blktests.

Bart.

