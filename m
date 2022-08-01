Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F60C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 18:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbiHASMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiHASMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 14:12:22 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A573165BE
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 11:12:21 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id t22so3519432pjy.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 11:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PNXNA8TxxbGuK12us0UQ2S31lXjK2ZTUZr1Y2KB6Xww=;
        b=5nMC1OV80Ezp4/XiyByom8MWPsllMqGvgWl5hvHacyn9afQnsEqQbG+eiCcUVNYluT
         mm9J+305QTqKcE8SrZTie1eDrOtscIJw4iUcJw8FOyYn9aFdkFhs5A1l3KkY7xsJFPzo
         GFotXJ/HOX/8jjDeJ4IzW7DaeKuR4l7xxLKNT70v/3xGAEXjWtC4UGORjbr5ERNMRUXj
         ajvABNTkIYGrnIGwhzN9yIVuMr+a5kaV/u4o7UbVMVZVIZb907vXvU/nLF8Eb+T55PdN
         Sv4DUny8RnkE1IJmvbIMftR4uq5ov8i4ax9fJey1FoXrpaRIr6R5Zi47+y5zxFfJj7hh
         ocig==
X-Gm-Message-State: ACgBeo2w4B0DebyisgzlY8BIqsQwgabeyZWmvGSw/EGZNgCh6vz6XXyZ
        gMdlpAgb+CBIdKIQQPluRZ0=
X-Google-Smtp-Source: AA6agR6+KsrcstHZgvImeNkG4tJ+Z8XtfWVYeTX1KBNhtGQ6ivTNzKQ5l6LgcpIQYh4osBHZEKycAw==
X-Received: by 2002:a17:90a:d3cb:b0:1f1:82ca:3ba0 with SMTP id d11-20020a17090ad3cb00b001f182ca3ba0mr21009005pjw.236.1659377540953;
        Mon, 01 Aug 2022 11:12:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6496:b2a7:616f:954d? ([2620:15c:211:201:6496:b2a7:616f:954d])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b0016d9b101413sm9846668pla.200.2022.08.01.11.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 11:12:20 -0700 (PDT)
Message-ID: <ffa00837-5e3f-24fa-ac2c-7d4a505c848b@acm.org>
Date:   Mon, 1 Aug 2022 11:12:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <YugT7jfkMGGvH7hO@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YugT7jfkMGGvH7hO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/22 10:57, Christoph Hellwig wrote:
> Please fix up your wording.  A vendor can't do anything at all in Linux.
> A driver might be able to disable things for a specific device, though.

Agreed that the description should become more clear. I think Peter 
wanted to refer to the "vendor driver" where he wrote "vendor".

Bart.
