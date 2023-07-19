Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A6CC001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 19:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjGSTxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjGSTxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 15:53:07 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68359D
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 12:53:06 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-55b22f82ac8so840966a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 12:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796386; x=1692388386;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pi80sYm3gBYK8pErGZKSZVS3/aw34cq8gwdXfkTlg9Q=;
        b=NvexWaluVC8zes/aPMZs21IxmKNDocRHdy/fsoznLg/Q/FRSO0yMK/umfJILYivBFj
         b9izqeu2lhDK257jQJ4uV4UB/o/VfTEh8Ve6GvR/CIP7Y1HKd5EoeCDJOHuRwA0O90AD
         w2wxKgnBUtle4SXd1rWHJ5gKhUSHCj+6vC38Q63kJRt38CpO+DLk5Y2fXEWLbM+/yxq5
         7FyJbee30eovYhaBk9iPudAkbyzlntPx84Yq+Zw6m8eoZgUlbivCxwjZ/1ktObq030Z7
         rLVnTN/CGEfxas5bnF2q/QoMSAEyBP5iCoBEqr66ErF3HIFOAJFpbfPHY1TEJYIFAFu4
         0fuw==
X-Gm-Message-State: ABy/qLayw45HFFGWi56+6Xoc7b1IUCVwRa9GCEfX+ajPTXMMayUFfVQj
        CrrbFjqzTsidOec49H5H4u8=
X-Google-Smtp-Source: APBJJlE8aBqml+Wt57ZnuVWfNYGVUsKbbGMiISca41kjRgFkeRL9mgH0M1ZnQ+U4jX0/MqXyYIZLcA==
X-Received: by 2002:a17:90a:6fc4:b0:262:ea3e:e248 with SMTP id e62-20020a17090a6fc400b00262ea3ee248mr4372671pjk.7.1689796386035;
        Wed, 19 Jul 2023 12:53:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090a380500b0025e7f7b46c3sm1630292pjb.25.2023.07.19.12.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 12:53:05 -0700 (PDT)
Message-ID: <425ad337-365a-fab3-cfc6-a102400ff7aa@acm.org>
Date:   Wed, 19 Jul 2023 12:53:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 10/33] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-11-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
> we retried specifically on a UA and also if scsi_status_is_good returned
> failed which would happen for all check conditions. In this patch we use
> SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
> when scsi_status_is_good returns false. This will cover all CCs including
> UAs so there is no explicit failures arrary entry for UAs.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
