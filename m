Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C088DC05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 09:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjAWJuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 04:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjAWJup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 04:50:45 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156001714D;
        Mon, 23 Jan 2023 01:50:44 -0800 (PST)
Received: by mail-wr1-f43.google.com with SMTP id e3so10181009wru.13;
        Mon, 23 Jan 2023 01:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdp/1kl49OpEQPVXjbylSGt1OHJLOfgsmX092gPMo8c=;
        b=vaVseHgVKABEMpdZ28ZXZYntrW+czRwz88/4AlLpFCQ7qKW45/IpxuGiebO8Cy6KDp
         WAigE1p6CjJZrQOKq71wQzlWu5K5gN+LsO+IHIENxrergO/CK/oQAuBGl6radXY+ka5H
         /skOMwaRKGeKYtCo+SgTG0rWbM6gWqmu667xAaO/sCYrRa/TIyOGp9xne32auGXS7+Ss
         u1pIdUoJedtjVLdcyp9zbxtc7BqSxmaX4qQckCF519stQnB97HphrPZdEQDMadQKVdvN
         OCk6yYkjckT7o6krVzGBJytWFMEAacrTrrO3nkrEpth8QATQOYZXuviF15OgRC+6F8OJ
         Qeew==
X-Gm-Message-State: AFqh2kqn2hg/hbifO7RKHlL7yiZnRJ9btD00+WooIxTF5P4XWiQ/7KlM
        b/hnR1jzP3KDoMb1EQPZTy4=
X-Google-Smtp-Source: AMrXdXunXSTJYGlcWrpbaLFFvJQ+kyJ0td+2xQoPxIDqTLcUbCFyQI2yZXnVKiZIUlcjGGsp08JWHQ==
X-Received: by 2002:adf:f8c4:0:b0:2be:34f:4fc4 with SMTP id f4-20020adff8c4000000b002be034f4fc4mr21533842wrq.13.1674467442637;
        Mon, 23 Jan 2023 01:50:42 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id by12-20020a056000098c00b002bdd8f12effsm26728438wrb.30.2023.01.23.01.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:50:42 -0800 (PST)
Message-ID: <5ee36ee8-b455-4e82-7a20-c6e0c1df6b61@grimberg.me>
Date:   Mon, 23 Jan 2023 11:50:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 13/13] IB/isert: Fix hang in target_wait_for_cmds
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mlombard@redhat.com,
        martin.petersen@oracle.com, mgurtovoy@nvidia.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-14-michael.christie@oracle.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230112030832.110143-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

Mike aren't you also missing a fix with isert_put_unsol_pending_cmds
due to the mis-clearing of write_data_done  in isert_rdma_read_done ?
