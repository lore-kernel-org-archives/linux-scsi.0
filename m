Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DD7C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 22:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiKVWKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiKVWKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 17:10:07 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD1EDFEB
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:10:06 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id j12so14964328plj.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 14:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpUWncPrkxRED0kjUWwnWz/YMW6WZIYUdOW7J8ThgLI=;
        b=lKhDooy4Hok5SqZ3on1b/G6D6RkM9D/eewysbuy7vcrW7nIHC+x93JguGCMY2AdLC7
         ZvaqFSq0dlXlvAeArs7naA6OGTRcwI9f0qyi8VmhCbxEDjdx+JXbK1a73YXlRyBXsIHn
         FIVHTcresCaSQbPu/awlyDMKAPhPKFopU2TcYA5JAfZaLpmQxMWBewMdTk6Aj4uZSi4G
         OFBbhe4pVgD2JIqaufvNRi/9FRrTw6Mi39JVthgSWeu7EPYaKRwxZGavdazkcRbJmP+o
         ushznoNbaBhFDvuNyM5rbSi8UzE45hPI9rcByJLxwyIm65Q9EE6EIWVn5x4LoWteNqoD
         Z6IA==
X-Gm-Message-State: ANoB5pn9Olj4UwNZ24ThM5pnFj2AR5Rm8Y3v56C/9RsRTg/2jMWT4pnr
        TaQzP2r5FnqMk1VxK/s/WUw=
X-Google-Smtp-Source: AA0mqf42a/dsJwts89Ff4JJTje96PCBXKGKjfQF9HwFefN1sDA4jmooLNYFLCGo4w745iNSeypfShA==
X-Received: by 2002:a17:903:26cb:b0:188:8dc6:4eae with SMTP id jg11-20020a17090326cb00b001888dc64eaemr18678263plb.2.1669155006008;
        Tue, 22 Nov 2022 14:10:06 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3c88:9479:e09c:9acb? ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id g28-20020aa79f1c000000b0056da2bf607csm10974742pfr.214.2022.11.22.14.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 14:10:05 -0800 (PST)
Message-ID: <f9798da3-b7b6-fc89-7a45-5682c15fcd0b@acm.org>
Date:   Tue, 22 Nov 2022 14:10:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 4/5] scsi: ufs: Add suspend/resume SCSI command
 processing support
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-5-bvanassche@acm.org>
 <DM6PR04MB6575C7BA448A45E6A386EF46FC019@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575C7BA448A45E6A386EF46FC019@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 03:07, Avri Altman wrote:
> I guess that you are planning to upstream the code that uses it [ ... ]

The code that uses these functions will be sent upstream by Linaro. 
Linaro has been asked to do the majority of the work of upstreaming the 
Pixel 6 kernel code. My goal with this patch series is to minimize the 
differences between the AOSP UFS code and the upstream UFS code.

Thanks,

Bart.
