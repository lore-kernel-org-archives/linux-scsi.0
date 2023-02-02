Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9A6C636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 19:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjBBTA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 14:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjBBTA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 14:00:26 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81596D054
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 11:00:21 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id 5so2852727plo.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 11:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ThW3OBGXPUWUlyjo6LvO6sLA9MlSlkab+M/PHASbFU=;
        b=23IRhCd6BKKGtIoO9R8P3wJOzIAoHkgKl9VqdVOl5CaPREgrvHIIHeltcPJTIvPFCH
         6JsequeKSE9MNPVK5FuihbKdhMz3zH9o8ckVlEtTFb2OLHeVGVJQyvAHCJrx4Yio9KOB
         ih9eN7dMIxkBu3jFppHi3+HZ+zGYRGqbwnEgocgUC56HQlMfpz7/HRVU4VnfUCQFALc7
         2eGG8CabrwSWHoBo+CryNHEknaMsith8vQrq3/TlcWwbAC0nDDl3pqEydynngxBJcqTZ
         hSIuhvPNCAbLduUQ3b4iGXj7ajTGEjBsQLsZ9bQv+JGQgRYUhL9Thn+koAONjuA2roF9
         dM/w==
X-Gm-Message-State: AO0yUKVe1CagZnQIMpGWlBIJohvtfa+OaHr8w74QurVxKgP1uLNQgjhG
        bOtOKiDZL4PhgRgdQHLHf3A=
X-Google-Smtp-Source: AK7set8UG9ecDsdYshaYgwaoeKhHx77O+ujoxO+sgt5h49VppV3zXWyFeDgLDa2Vo7NZsgpY+hsJ6Q==
X-Received: by 2002:a17:90b:1c01:b0:22c:6a2:99ae with SMTP id oc1-20020a17090b1c0100b0022c06a299aemr7974000pjb.15.1675364421296;
        Thu, 02 Feb 2023 11:00:21 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09? ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id i24-20020a17090a7e1800b0021904307a53sm223496pjl.19.2023.02.02.11.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 11:00:20 -0800 (PST)
Message-ID: <89a59589-a8b6-21cd-9f77-a595216974dc@acm.org>
Date:   Thu, 2 Feb 2023 11:00:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Content-Language: en-US
To:     jejb@linux.ibm.com, Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230201180637.2102556-1-bvanassche@acm.org>
 <20230201180637.2102556-3-bvanassche@acm.org>
 <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
 <941ac8ba-8814-f3d5-ddc7-712058ea91ef@acm.org>
 <9d784606dfd75feefe653694d920b15e9dfcaff0.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9d784606dfd75feefe653694d920b15e9dfcaff0.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 10:46, James Bottomley wrote:
> Well, that may not be true in all situations.  Semantically FUA is a
> barrier: it can be implemented such that it destages only the current
> write plus the cache writes that occurred before the write with the
> FUA.  It could also be implemented as you suggest above, which simply
> destages the entire cache, but it doesn't have to be.  One of the
> reasons for FUA to exist is the potential difference between the two.

Hi James,

Although support for the barrier concept has been removed from the block 
layer, would it be possible to tell me in which T10 document I can find 
more information about the barrier semantics? All I found in the latest 
SBC-5 draft (revision 4; 2023-01-24) about FUA is the following (section 
5.40 WRITE (10)):

"A force unit access (FUA) bit set to one specifies that the device 
server shall write the logical blocks to:
a) the non-volatile cache, if any; or
b) the medium.
An FUA bit set to zero specifies that the device server shall write the 
logical blocks to:
a) volatile cache, if any;
b) non-volatile cache, if any; or
c) the medium."

To me the description of FUA in the SBC-3 draft from 11 November 2013 
seems identical to the above text.

Thanks,

Bart.

