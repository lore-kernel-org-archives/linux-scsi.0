Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E866C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 18:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjBBSJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 13:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjBBSJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 13:09:14 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D52779218
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 10:09:13 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id r8so2705544pls.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 10:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bgZyVB3QCYCJT/2vYugJQwJCmYRrTX0QsgJxtyJC7qA=;
        b=Nr9MKb289egW+WEDPp5sFqzLcdrSQqIMG1Cqn4su6X1bIA/rHBKeE5f46kW/w04QkC
         ry4iCvXRJvYqnLsbrhme1AktyKz+7Ft8MbyknSwlIOGefFbhbUJIxrEErVV/Qad6CR9S
         AHpY71MrJhyrncKC/4mx4e2/uRiDRMe95cGTb4M2YmCPqec/4rJ0DsrDY1mYPqGCSkpI
         B2IcYxIbfZ0lIH0D6jJozC2eJWAqujbsTvWgnmnOHuf1QJNEL4so3/b+8TrctmFAlf1b
         QLd6+HvsKfVr0+OYUp2Vr+53GnJzE4FQ2WNMnGj04SczKjZLMy6gL7GJNoqS8mNH3ZHo
         R54A==
X-Gm-Message-State: AO0yUKUzyGS4nbQXrs+yVIY6tbjojVD69O5jj/2z/Mhid81zgOqhZ4Wy
        W4sXLbfnR9fXxUWb1A7VTDneJQMit5Q=
X-Google-Smtp-Source: AK7set/LLFu7dg+o9kReXZUy5ytu1VEnHerBhGNI8iM3cO95nJiiB35l0EceQ7ah00W//lN5meovCg==
X-Received: by 2002:a17:902:f682:b0:196:3f75:1e9c with SMTP id l2-20020a170902f68200b001963f751e9cmr9707017plg.52.1675361352605;
        Thu, 02 Feb 2023 10:09:12 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09? ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709027c0500b00198b0fd363bsm3610263pll.45.2023.02.02.10.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 10:09:11 -0800 (PST)
Message-ID: <941ac8ba-8814-f3d5-ddc7-712058ea91ef@acm.org>
Date:   Thu, 2 Feb 2023 10:09:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230201180637.2102556-1-bvanassche@acm.org>
 <20230201180637.2102556-3-bvanassche@acm.org>
 <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/23 23:52, Adrian Hunter wrote:
> On 1/02/23 20:06, Bart Van Assche wrote:
>> UFS devices perform better when using SYNCHRONIZE CACHE command
>> instead of the FUA flag. Hence this patch.
> 
> It would be nice to get some clarification on what is
> going on for this case.
> 
> This includes with Data Reliability enabled?
> 
> In theory, WRITE+FUA should be at least as fast as
> WRITE+SYNCHRONIZE CACHE, right?
> 
> Do we have any explanation for why that would not
> be true?
> 
> In particular, is SYNCHRONIZE CACHE faster because
> it is not, in fact, providing Reliable Writes?
  Hi Adrian,

Setting the FUA bit in a WRITE command is functionally equivalent to 
submitting a WRITE command without FUA and submitting a SYNCHRONIZE 
CACHE command afterwards. For both sequences the storage device has to 
guarantee that the written data will survive a sudden power loss event.

It is not clear to me why WRITE + SYNCHRONIZE CACHE is faster than WRITE 
+ FUA. All I know is that this behavior has been observed for multiple 
UFS devices from multiple vendors. I hope that one of the UFS vendors 
can provide more information.

Bart.
