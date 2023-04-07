Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30E9C6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjDGUIs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjDGUIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:08:35 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D67BBA1;
        Fri,  7 Apr 2023 13:08:34 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id nh20-20020a17090b365400b0024496d637e1so5091429pjb.5;
        Fri, 07 Apr 2023 13:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898114; x=1683490114;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkZ9epVN8TkdRsJcbdQlduPOctGu1N9KX0JTrq0nz1g=;
        b=OgRf+qISMweawhphd8MFRNmo5JOJPw44VchvqAxLmBe2CLvB8o8FT1vImOEYv6697R
         Vab9MDpN6hhWE3q9baD8cmxAJmcPz1ldrQDeJluyATZOW7LoCDS/Bp1i9Y28OWiHRLsp
         b1TZUoKHPDtaiXfEoM+l0UbJe2cP2ojfzewxmC043mrzONzj8wxZgsbEhVsrn7UFcGsb
         jvfeJaCjLiD4NDOmq/KnyKUEwxo1k0nIejDyO6x4emtwmc0a7c/E3o0bp+r6Gg7RKoFn
         ZqSkPD+Ho/YMjFxdh4MzK8OOo24hqyGwS2Vmtvj70PSkwqCBidCdxxwg6Hf1yyLhmBRD
         Hz6A==
X-Gm-Message-State: AAQBX9cjD3li3rR7frGhmbKUVsUwoDzMT9FWdlAeZJYC4+xoDqQza/D+
        OkAzWgKl6rz5RmDKLWG7F3o=
X-Google-Smtp-Source: AKy350bkZ/dbg++B75vxCCybX1JJjWE1bjDcXVcXGtkaYO/su68D56optz/DjfTQFNhiuhs1ZBvehA==
X-Received: by 2002:a17:903:2309:b0:1a2:55c9:1808 with SMTP id d9-20020a170903230900b001a255c91808mr4182456plh.17.1680898113889;
        Fri, 07 Apr 2023 13:08:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:f2c:4ac2:6000:5900? ([2620:15c:211:201:f2c:4ac2:6000:5900])
        by smtp.gmail.com with ESMTPSA id ju20-20020a170903429400b0019aafc422fcsm3272871plb.240.2023.04.07.13.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 13:08:33 -0700 (PDT)
Message-ID: <0d7d40a3-bd58-03f2-5bf2-706ed2e6155f@acm.org>
Date:   Fri, 7 Apr 2023 13:08:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v6 04/18] scsi: Move sd_pr_type to scsi_common
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230407200551.12660-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 13:05, Mike Christie wrote:
> LIO is going to want to do the same block to/from SCSI pr types as sd.c
> so this moves the sd_pr_type helper to scsi_common and renames it. The
> next patch will then also add a helper to go from the SCSI value to the
> block one for use with PERSISTENT_RESERVE_IN commands.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

