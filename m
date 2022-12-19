Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9924C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 14:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbiLSOjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiLSOjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 09:39:19 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F2198
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 06:39:18 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id bx10so8903143wrb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 06:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGMLsH8dgzcahtBgx80OpxckreFvsodbzajyjupc3Ck=;
        b=VT1BFOOZBN2F54VOA5DbCEiDLjMvyAoExiqGeHO3SWZgE1VGL1FR7HaceCyrlMNcpt
         oO/xHErMVV4ixh2giC0zjgvauQbju6Sf5hHRubr7AZIBkNcywFmNr6MEdlyYtrKtxaNL
         Js5ZJJfQ5QZkJfmtTQzLzK+Rbc7aVRuG+7URjn9EgR05H8CvulGE9ROW6umO7cCDMdFW
         gZOkvE2J9xveWWbz/aitCcw7UjKFAF5mUmJ3cYOgGIA8tfNvTcmE+PQFn0ETqRNSmybm
         8z2/KHe4XbPhd3FAUP5qe2eDTeiGKu9FUaXgOPbHMCTf03oJczu9VW8q0d0rIg/1KBZk
         1JxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGMLsH8dgzcahtBgx80OpxckreFvsodbzajyjupc3Ck=;
        b=nFudNnkshpYYqbZaStH5zlJLgfNfndZ9kCzB6oN5Pt1AcpIjCW1QeM3QxWhjZLYd1s
         CPPNVQo/O15u/tgoTGN85AsTsuEgwVDi8YUo1rdPtxweK7K5sQhUXrvW/VZxBEfHj3iY
         lPgDyiUWLgudITHoH7wCBq/6DjvbnuGWkAITb+BPmIsr/wKVgEe5swTtRvOHuqyxIO5g
         05+uX1xYi7g7D13ixdj7RzaP79VRW239KFU4oXjmQtL5foWZmwPCJRxXeFM0zzvhFK0O
         EiRyfWgAQP1558uRUYIADqxRmWVEcPgcoPYip+ISFyjlZbUUPe/d3bnbDygs2YoYFqk9
         N6wA==
X-Gm-Message-State: ANoB5pnSHpaNWg9/755jnyN1Uww8+tQe1CiUOkrXZQmLehQqjSYjmf5H
        XqD6hQVixPXXrRgNh3Ka0GkB+g==
X-Google-Smtp-Source: AA0mqf5/VyOUBf9M76A2ciHOjRS4N/9IXTIhrdBesQDhgDxyOax74woFyxZrsxJtJgKa1C/SuM19qQ==
X-Received: by 2002:a5d:4242:0:b0:242:5ed6:a09f with SMTP id s2-20020a5d4242000000b002425ed6a09fmr25001217wrr.44.1671460757191;
        Mon, 19 Dec 2022 06:39:17 -0800 (PST)
Received: from [10.94.1.166] ([185.109.18.135])
        by smtp.gmail.com with ESMTPSA id y1-20020adfd081000000b002421a8f4fa6sm10246190wrh.92.2022.12.19.06.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 06:39:16 -0800 (PST)
Message-ID: <da4f53f3-4e13-1259-b0a6-cc28160be23b@arrikto.com>
Date:   Mon, 19 Dec 2022 16:39:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
To:     Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
 <Y5Dc66mOzBfBhUGY@infradead.org>
Content-Language: en-US
From:   Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <Y5Dc66mOzBfBhUGY@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/22 20:35, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 12:29:56PM -0600, Mike Christie wrote:
>> I think you need to make this configurable.
>>
>> If you use loop with pscsi, then the sgl that loop now gets might be too
>> big for the backend device so we now fail in:
>>
>> pscsi_map_sg -> blk_rq_append_bio -> ll_back_merge_fn
>>
>> So some users might be relying on the smaller limit.
> 
> Note that this could happen even now, you just need sufficiently
> horrible hardware to pass through for it.  But yes, for pscsi
> this needs to look at the underlying device, and increasing the
> limit might be a good point to do that.  I'm not sure it's worth
> to add user configuration, though.

Thanks for the feedback.

What should I do? Change pscsi to look at the underlying device limits?

Nikos
