Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3807C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951DD206F4
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgEPDvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 23:51:01 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38280 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgEPDvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 23:51:01 -0400
Received: by mail-pj1-f67.google.com with SMTP id t40so1910965pjb.3;
        Fri, 15 May 2020 20:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q+vxzCyXrz5qeW3ovRsPKQt/8P97ZITgNdo4auHh/lA=;
        b=JDDvMylWAkZ7wcP+qo0Ikifl8Fx9LGe/7zeRV2tyBsZNyTeoRNgPKwkb/buZbuDXGS
         tyXWBcnOQ5jyjI584JINUn8ZENqX5t3hbiohJyJjWkN8Lygqsm+e9aQEiK11EC3lRavN
         bwslv12qAxSDaxMYaZvjWopsx1xc8fIGVKTgnv/reMS4IJiYqWnLdIutuGMKXKDPP6c9
         DHMW+40kskIbNi5SSkTaEnFwyxkQfcc42dVVoAy7DhTG/JFAtzveY+2Tcv/6CGu3fC3+
         3TaaO89qdgGz5Yvxhl1YoN97vR3DuvXuUXJtLKqjLrlSQxl4Hq3XqulfxSxqsAwlbktu
         NHvA==
X-Gm-Message-State: AOAM530ytNV3zFfxEso0wrIKr5UnlJTnu9EiJLxVh0T7wrqpFkMaUA+6
        eXTxNjIDpeMh6ivv7rZ5wes=
X-Google-Smtp-Source: ABdhPJzvFLNv1oe7qZ0uS1ZuSzwKLa7ut8pFY9gp0BfsTBaw4x3tm5rR0VnKA5Yv0oMVp/OrrxaBGg==
X-Received: by 2002:a17:90a:3ea5:: with SMTP id k34mr368625pjc.7.1589601060026;
        Fri, 15 May 2020 20:51:00 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id d195sm3127267pfd.52.2020.05.15.20.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 20:50:59 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] scsi: ufs: Add HPB Support
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
Date:   Fri, 15 May 2020 20:50:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> NAND flash-based storage devices, needs to translate the logical
> addresses of the IO requests to its corresponding physical addresses of
> the flash storage.  As the internal SRAM of the storage device cannot
> accommodate the entire L2P mapping table, the device can only partially
> load the L2P data it needs based on the incoming LBAs. As a result,
> cache misses - which are more frequent in random read access, can result
> in serious performance degradation.  To remedy the above, UFS3.1 offers
> the Host Performance Booster (HPB) feature, which uses the host’s system
> memory as a cache for L2P map data. The basic concept of HPB is to
> cache L2P mapping entries in host system memory so that both physical
> block address (PBA) and logical block address (LBA) can be delivered in
> HPB read command.  Not to be confused with host-managed-FTL, HPB is
> merely about NAND flash cost reduction.
> 
> HPB, by its nature, imposes an interesting question regarding the proper
> location of its components across the storage stack. On Init it requires
> to detect the HPB capabilities and parameters, which can be only done
> from the LLD level.  On the other hand, it requires to send scsi
> commands as part of its cache management, which preferably should be
> done from scsi mid-layer,  and compose the "HPB_READ" command, which
> should be done as part of scsi command setup path.
> Therefore, we came up with a 2 module layout: ufshpb in the ufs driver,
> and scsi_dh_ufshpb under scsi device handler.
> 
> The ufshpb module bear 2 main duties. During initialization, it reads
> the hpb configuration from the device. Later on, during the scan host
> phase, it attaches the scsi device and activates the scsi hpb device
> handler.  The second duty mainly concern supporting the HPB cache
> management. The scsi hpb device handler will perform the cache
> management and send the HPB_READ command. The modules will communicate
> via the standard device handler API: the handler_data opaque pointer,
> and the set_params op-mode.
> 
> This series has borrowed heavily from a HPB implementation that was
> published as part of the pixel3 code, authored by:
> Yongmyung Lee <ymhungry.lee@samsung.com> and
> Jinyoung Choi <j-young.choi@samsung.com>.
> 
> We kept some of its design and implementation details. We made some
> minor modifications to adopt the latest spec changes (HPB1.0 was not
> close when the driver initially published), and also divide the
> implementation between the scsi handler and the ufs modules, instead of
> a single module in the original driver, which simplified the
> implementation to a great deal and resulted in far less code. One more
> big difference is that the Pixel3 driver support device managed mode,
> while we are supporting host managed mode, which reflect heavily on the
> cache management decision process.

Hi Avri,

Thank you for having taken the time to publish your work. The way this
series has been split into individual patches makes reviewing easy.
Additionally, the cover letter and patch descriptions are very
informative, insightful and well written. However, I'm concerned about a
key aspect of the implementation, namely relying on a device handler to
alter the meaning of a block layer request. My concern about this
approach is that at most one device handler can be associated with a
SCSI LLD. If in the future more functionality would be added to the UFS
spec and if it would be desirable to implement that functionality as a
new kernel module, it won't be possible to implement that functionality
as a new device handler. So I think that not relying on the device
handler infrastructure is more future proof because that removes the
restrictions we have to deal with when using the device handler framework.
 Thanks,

Bart.
