Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38488CA9ECF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C7302086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 15:40:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="rL3t4OUb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfJaPk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 11:40:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36162 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfJaPkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 11:40:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id g9so2865148plp.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 08:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CPn8+AM71kxDq+noLelhU/Esf/1a31+wm1HsPiI7Wg8=;
        b=rL3t4OUbghkpGPan7eqOEONagf+/5t4476ZA4Xk1AZR6/3xeuzl0ivlVyAdcl/HJRl
         r2byD5PWK00dg3Or+AjtCGy+15vk90iXcQX1yZuK1PmY1obTcDl8OZE5khB/6IijbT9D
         2P0eIDa0R3XaiDfloAOgjzyTwEj5UwSHKbgayZwbagRSyl2TJXvIUagb0WrquOCAIDax
         +0T/WUtN5SWJ0ibC+BeF9+czbM4HN1CJ5eA2du++7XaqLHxi+kCLSx5RfnwE3v8IeJip
         LXaYH03GCmxwdwcfE4f5NPHDM08DgSqobHhYGFXQ3Zjos+aU4wNA0x7BoQUNxaUx8rOp
         pfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CPn8+AM71kxDq+noLelhU/Esf/1a31+wm1HsPiI7Wg8=;
        b=LJjdjo0//BAgLKmffx0T6wcKCFFAoXGs82S6nC+8odZPuDP8b9mSHb9FSQdDVm2+d7
         inHcIG2tFodxgIv/scTjxDuy2EVL+lJjTqW6gum+o7A8IIMz3CZFSwLm/eKqnpa74J/u
         MDigGWw8bgBByMYphnDSTKoq3xabFuAqvRu9mWMMYPO9phR4APrdxWwQNfkWXKlW0GBI
         r38ZKxoKFrulLny5YH+u/MTyTUJjItgFICyE1Tc5JFpvK8m4SJedRA0gtu97UXI7l7UO
         8ZQ1HbLfnrXBYlatxooiREWMSKovFvvTuX4wPlp1fklLvbam6d+wOxDseVvR+DZHG6aM
         8KAw==
X-Gm-Message-State: APjAAAVFKncJO0wiYLPu1DP4HlictPll0pFBWfCdHSllRCLeoLuGYhts
        EPDCEXsqZJFe+Ep19B0qbG4I9A==
X-Google-Smtp-Source: APXvYqyAGIf+apPbcxeHIW8+Vv7iwJFzopZRGuCbfnSwa9z+ghg+qF0oGYtBvfa0+3g1ydffdNjyYA==
X-Received: by 2002:a17:902:a70b:: with SMTP id w11mr7236143plq.214.1572536423473;
        Thu, 31 Oct 2019 08:40:23 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id z62sm4363035pfz.135.2019.10.31.08.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 08:40:22 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
From:   Mark Salyzyn <salyzyn@android.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
 <1572318655-28772-2-git-send-email-cang@codeaurora.org>
 <fd78538f-8e5f-2e5f-0107-a8bc284d037d@android.com>
Message-ID: <6bda63c6-4bcf-b7ad-f552-4c72ba0b9024@android.com>
Date:   Thu, 31 Oct 2019 08:40:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fd78538f-8e5f-2e5f-0107-a8bc284d037d@android.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 8:20 AM, Mark Salyzyn wrote:
> On 10/28/19 8:10 PM, Can Guo wrote:
>> Host sends MODE_SENSE_10 with caching mode page, to check if the device
>> supports the cache feature.
>> UFS JEDEC standards require DBD field to be set to 1.
>>
>> This patch allows LLD to define the setting of DBD if required.
>>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>   drivers/scsi/sd.c        | 6 +++++-
>>   include/scsi/scsi_host.h | 6 ++++++
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index aab4ed8..6d8194f 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2629,6 +2629,7 @@ static int sd_try_rc16_first(struct scsi_device 
>> *sdp)
>>   {
>>       int len = 0, res;
>>       struct scsi_device *sdp = sdkp->device;
>> +    struct Scsi_Host *host = sdp->host;
> variable locality
>>       int dbd;
>>       int modepage;
>> @@ -2660,7 +2661,10 @@ static int sd_try_rc16_first(struct 
>> scsi_device *sdp)
>>           dbd = 8;
>>       } else {
>>           modepage = 8;
>> -        dbd = 0;
>> +        if (host->set_dbd_for_caching)
>> +            dbd = 8;
>> +        else
>> +            dbd = 0;
>>       }
>
> This simplifies to:
>
> -   } else if (sdp->type == TYPE_RBC) {
>
> +    } else if (sdp->type == TYPE_RBC || sdp->host->set_dbd_for_caching) {

IDK what happened with my mailer sending out an older infant copy (blame 
on fumble fingers). My final copy was instead the simplification:

+    dbd = sdp->host->set_dbd_for_caching ? 8 : 0;

