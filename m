Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDE8C11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 20:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3576144E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 20:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhF3UTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 16:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233847AbhF3UTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 16:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625084242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jlLRKLtyRMSelG0PIFc0olA0mWZEHQGqQXwE6AaozSE=;
        b=V4U7A4Mg/0nPFnN4MF2RdP1qJHn/2JFPhzbPvmCTr9E5kxHGLEwUkUCXEqqhWVa3iExII2
        ul2MqVOTvNK4y+T5zMOr2uuwofE4AmdIACocyxO7pCTv8gSmlKBo+LG7af2DaJ/8WcoRtC
        HoDxMNSY2x8eR2woFasBZXuWM9piX+o=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-cxU8NRhLMrmuc5UNlrNxUw-1; Wed, 30 Jun 2021 16:17:20 -0400
X-MC-Unique: cxU8NRhLMrmuc5UNlrNxUw-1
Received: by mail-ed1-f72.google.com with SMTP id r15-20020aa7da0f0000b02903946a530334so1775553eds.22
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2021 13:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=jlLRKLtyRMSelG0PIFc0olA0mWZEHQGqQXwE6AaozSE=;
        b=M1Ab+qf0wS42UT7vCpi/1ixvNF5dDKxgjODblbqNW+nlh88dRcB3DXNMBsYjJaeS9q
         zb1NGqOAOiEXi9KyRis+AN238JfY0DO5ZXY6CzhDqBhgXZGKwmczzSjcG95Mdf2GY2P6
         Yd5rlSS6K8/xP00VV9WodAJqLeRgiUreoPaQuHalt2/a1lMiyHoK0qyDs1FEYLhbqCBn
         oafD7pBrr/VSQQQEo/9DMYjNp1a3/DTJ2nzXOYdKYcsXLsFxstklT7lLxA6A1oPXiPE5
         x+9sGoeQroJKUNWmr0quDs3lFyjoMNc1YeGybfAZjg+ZfT3LJYW7oonMXBhdnuxeA6Mx
         iiSw==
X-Gm-Message-State: AOAM533e1gFVazztkO4P1ds3i5qa7ixe9fKLwpWsTW+wNmhhjKD6azqP
        36f1nVF/65oEbifhlBziNEHgxNHUx8mNlq91PmJMgsDyQmAk+oZ8wMsax0E3vkaX4NPF7crPddC
        XNVCznSdJdiKnUsDu9PCbziLX5pMfVBSZSeeQZv4sV2qRWVAOK1mSPGQLwtsWHL9rUcwcz9c3
X-Received: by 2002:a17:906:eca1:: with SMTP id qh1mr13729898ejb.287.1625084238852;
        Wed, 30 Jun 2021 13:17:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwc5NXVuzUPqzo6+lrh8I3tW3qBl1H1vOxuPBXKMXektcx1eRQV5MDkzKBitPIEsj9SWuXoHQ==
X-Received: by 2002:a17:906:eca1:: with SMTP id qh1mr13729884ejb.287.1625084238618;
        Wed, 30 Jun 2021 13:17:18 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id q5sm9780746ejc.117.2021.06.30.13.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:17:18 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org
Subject: smartpqi cannot change IRQ smp_affinity
Message-ID: <c8ed244c-61d0-eead-8ec3-fe8f2e239d71@redhat.com>
Date:   Wed, 30 Jun 2021 22:17:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hellwig and Don,


On driver smartpqi I cannot change smp_affinity and smp_affinity_list 
entries.

It was suppose to be fixed by this patch: 
https://patchwork.kernel.org/project/linux-scsi/patch/154422179851.1218.10349207247849277036.stgit@brunhilda/

I can see that Hellwig added back PCI_IRQ_AFFINITY flag in commit 
5219822687be ("scsi: smartpqi: switch to pci_alloc_irq_vectors").


Is there another way I can control which CPU that process IRQs from the 
disk controller?

--Jesper

(lspci output below)

b2:00.0 Serial Attached SCSI controller: Adaptec Smart Storage PQI SAS 
(rev 01)

         Kernel driver in use: smartpqi
         Kernel modules: smartpqi


