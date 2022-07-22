Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6C4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 18:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiGVSER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 14:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiGVSEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 14:04:12 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B419813F93
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 11:04:11 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id z3so5201488plb.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 11:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0G9IXPR6Tw9u4K90d7Qyi37Gnq89rkjK88M8sdp4wcE=;
        b=7Id97OmaD+dpXHke+VC9S08W2/HGXgkXAHXX18lp8lUMHY6kfqde70k7GL+aI+Ac7Z
         3hR18lgkmHAHUIV7qCtDB9/TinqEoEycJrr5NpXnRbkBlySJAPMhDr61pSCaq0Z7g5E2
         iUbbEOI3xYT1b/Xi3k/VRgsIhJgpJYskS3fYK0y3AlRm5KPSbLcrLyaTd96uymZM4yGW
         PnkIYZnNCyiQcIFJy0vJQb0uDwwiUwcgCGtvkGDKfuyOXMjtEOPJ2ZarbeYmNOUAMuYO
         upRwXwW3UIua9Mw5+Unza6yeBT/Ck6DwDaBNDZwosfxLdf3RHaG8hwNVOJCe8UG5VZkO
         p90w==
X-Gm-Message-State: AJIora9WmmKQf+J3B8fOLnq1Yo/N9u7ostVNXJLYuc61DFrRewpsv9iH
        axQ+qktLeJI2BXvx1+8b+y4=
X-Google-Smtp-Source: AGRyM1tyRlpOkC9LR1tUTjXTsRZQTZG0ZPjBQfuTav4mfXobli6INpnif5GO02jqRhEpYNzQEGR3dQ==
X-Received: by 2002:a17:90b:4ac1:b0:1ef:c1ba:e73e with SMTP id mh1-20020a17090b4ac100b001efc1bae73emr18674775pjb.47.1658513051184;
        Fri, 22 Jul 2022 11:04:11 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cf6:7e29:d977:6fc7? ([2620:15c:211:201:9cf6:7e29:d977:6fc7])
        by smtp.gmail.com with ESMTPSA id a142-20020a621a94000000b0052b433aa45asm4247935pfa.159.2022.07.22.11.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 11:04:10 -0700 (PDT)
Message-ID: <54727af0-dc4b-fadb-5193-13ff4ecc48ef@acm.org>
Date:   Fri, 22 Jul 2022 11:04:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] scsi: ufs: correct ufshcd_shutdown flow
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220719130208.29032-1-peter.wang@mediatek.com>
 <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
 <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 21:30, Peter Wang wrote:
> On 7/21/22 5:40 AM, Bart Van Assche wrote:
>> On 7/19/22 06:02, peter.wang@mediatek.com wrote:
>>> From: Peter Wang <peter.wang@mediatek.com>
>>> Also remove pm_runtime_get_sync because it is unnecessary.
>>
>> Please explain in the patch description why the pm_runtime_get_sync() 
>> call is not necessary.
> 
> Because shutdown is focus on turn off clock/power, we don't need turn 
> on(resume) and turn off, right?
Hi Peter,

I think that removing the pm_runtime_get_sync() call is safe because the 
device driver core already performs a runtime resume before the UFS 
driver shutdown callback function is called. From drivers/base/core.c:

		/* Don't allow any more runtime suspends */
		pm_runtime_get_noresume(dev);
		pm_runtime_barrier(dev);

Thanks,

Bart.
