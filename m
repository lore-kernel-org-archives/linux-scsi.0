Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3889DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 17:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiCGRxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 12:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiCGRxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 12:53:17 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9C6D387
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 09:52:23 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id n15so4565139plh.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 09:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DwprjYwNE5LcdqrWbAc8Ni1ALn/1vHszc3TMMAI/bKY=;
        b=JzeA0Tc06Lvo4C1UFPRRUBLqIQKFuwR5aw/TprorUu1Hb4qAW3/Yvq7EYEOt0gKB97
         +1+bd++N+/J6WKHBD51XCulJMGblR3NGoxYsgknGCQ7l8cvPksevQJJPyE70DgMPkQIG
         OPgEc7WCAE0IJN0rCujrzjZzklcTTy2YDpau7gBvL/wotXH9WWb+hkqtylBTYSL+Pmnz
         7cV5XjSa6wFtiQcFSFbJzzga2j5xA6/6Xx8DxnFGPctwx+QWC0LQDLA3i6vbHL8EzAr3
         LIZ+nl0Yr19bQwJVYZlpX8NBGoT7gubcfiRH9bdz/SxDRtYxjpiP7Q17akDdaKYo6OFf
         /jKQ==
X-Gm-Message-State: AOAM53336rArD/eFDd+eRk7r0P0hOR9EWHBUTRDfYFiRMe7SBuqP8jMU
        l9ySuTi38jSNrpFP13CH57M=
X-Google-Smtp-Source: ABdhPJy7/vQEF/R2zXFSBVgPpq7S1lU/2A3Z2FmPOFHEXpsOmmhHUuvouFaAa0cHtZ/rNQQEq36uuQ==
X-Received: by 2002:a17:902:b210:b0:14f:d0ff:46bb with SMTP id t16-20020a170902b21000b0014fd0ff46bbmr13174842plr.47.1646675542435;
        Mon, 07 Mar 2022 09:52:22 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm17889091pfu.144.2022.03.07.09.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 09:52:22 -0800 (PST)
Message-ID: <19ad4174-0435-85b2-0762-1fae5e0b5f9e@acm.org>
Date:   Mon, 7 Mar 2022 09:52:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, mikebi@micron.com,
        beanhuo@micron.com
References: <20220307111752.10465-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220307111752.10465-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 03:17, peter.wang@mediatek.com wrote:
> When ufs init without scmd->device->sector_size set,
> scsi_get_lba will get a wrong shift number and ubsan error.
> shift exponent 4294967286 is too large for 64-bit type
> 'sector_t' (aka 'unsigned long long')
> Call scsi_get_lba only when opcode is READ_10/WRITE_10/UNMAP.

Hmm ... how can it happen that sector_size has not been set? I think 
that can only happen for LUNs of type SCSI DISK if sd_read_capacity() 
fails? If sd_read_capacity() fails I think the sd driver is expected to 
set the capacity to zero?

rq->__sector == -1 for flush requests and the type of that member 
(sector_t) is unsigned. I think that it is allowed for a shift left of 
an unsigned type to overflow. From the C standard: "The result of E1 << 
E2 is E1 left-shifted E2 bit positions; vacated bits are filled with
zeros. If E1 has an unsigned type, the value of the result is E1 × 2E2 , 
reduced modulo one more than the maximum value representable in the 
result type."

Thanks,

Bart.
