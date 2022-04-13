Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D868C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 03:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiDMDW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 23:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiDMDW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 23:22:29 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D418920F4F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 20:20:04 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d15so801467pll.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 20:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iHQkxuyxXAoJBLyHY81G6WCzK88+DhjjYdaB6A4N5WM=;
        b=sdVfwdHAdrnUSnrW+hIBJJ2BFACUArDDu2qjXGYMOyeo29v+btUQfwkjgWLUiJ8sAL
         2TuQpCSHDGFSlzjqZZHBsc5mM73YO7EkjBUfpCJyLXkaauvVTfHDndBYVNkV/qeUZ2Hg
         BGo1g+zVhT0TceRbHAxR1uWsZCKjTPvTSbbopI0qIJbYd26HgxewIBfrOJoKDSzfomoe
         eHptK9gVSMxRtno0DXgBUEWxXJyEdRybtYH868p8JQhenxYLcU4gbGFOAONtoF9Wiu8X
         GqyuLB/cdC3PkEKfI/2EMpF5+RlKwetVHHcH/IopKudYjzG7aZCUGQ2tipcbj3mm0lYk
         NNRw==
X-Gm-Message-State: AOAM5319WgDnsfRCY4SUAYayL3VPGh5NYMn0vPavPJD3GRCqPTZgk/B2
        qqyMMtJZu5USq2b93eAym2Q=
X-Google-Smtp-Source: ABdhPJyYW//eSJua79tnBfi79QF0kZSgXYg/c5cAHSxgWamaXJNikZNMJupVoLjI/xja06Xmg/djjw==
X-Received: by 2002:a17:902:b703:b0:158:2667:7447 with SMTP id d3-20020a170902b70300b0015826677447mr23034182pls.92.1649820004212;
        Tue, 12 Apr 2022 20:20:04 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm4350141pga.38.2022.04.12.20.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 20:20:03 -0700 (PDT)
Message-ID: <e946d403-8bf9-5c88-d502-353faf50c6b7@acm.org>
Date:   Tue, 12 Apr 2022 20:20:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 04/29] scsi: ufs: Simplify statements that return a
 boolean
Content-Language: en-US
To:     keosung.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
References: <20220412181853.3715080-5-bvanassche@acm.org>
 <20220412181853.3715080-1-bvanassche@acm.org>
 <CGME20220412181947epcas2p18ab1ae9013aeb1f261fb46cb60881263@epcms2p4>
 <1889248251.21649817605815.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1889248251.21649817605815.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/22 19:33, Keoseong Park wrote:
> Hi Bart,
> 
>> Convert "if (expr) return true; else return false;" into "return expr;"
>> if either 'expr' is a boolean expression or the return type of the
>> function is 'bool'.
> 
> How about adding ufshcd_is_pwr_mode_restore_needed()?

Hi Keoseong,

I'd like to keep that function as-is because it has three return 
statements instead of two.

Thanks,

Bart.
