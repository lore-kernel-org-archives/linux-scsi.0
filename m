Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED51C00528
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 18:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjG0SaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjG0SaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 14:30:17 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438393582
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 11:30:03 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b8ad356fe4so8080755ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 11:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690482603; x=1691087403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wULpH0G2lvjN5ChbZ9ztzjGDpBI2rxnZKeZ85aSgPmY=;
        b=RxkJgNgwvPl2gKsDqYGDk3EzEbwmlEkNQRFT9rpWFfz16njljlZ8B4VEq1XgUDJP5t
         wxor2LKbMmbuIUupcBPgQdJX9lVB9wjgzD1+tik5tw9xmlFnShjSZEUJLHo/Chi/qcIb
         FX5TIHjv2ibS3u3b+QD1t1o0wfAzS63fj4OGjr1zkiQOldlg6Mu9eF90YegcgQScCsIf
         1bqI3j4PKwDK+YwMoLWYaX/LHsMSkK2PdhHu8I6ibrldnXgCMaaHM81/j584j5saCVVy
         ksGuwd33gn0eOgLBu9kiceAXHTThBiJJeqKcuyJl1kwnELakMYiwEhHClEu+efwRAxhR
         FkTg==
X-Gm-Message-State: ABy/qLZhFcKPzCJ4jlhh+pWoagZV/vcMYlT8/AodXlVTrC2/1JWx1e9i
        zTwrxyYaYoAcUTqZWa1E2do=
X-Google-Smtp-Source: APBJJlGNNgeXN+u2huRmoFv8b7Lv3WvqpFCFCwnbDz66g1SUShYdXdk0HcB+2yyxH4QwlpTdhcgAYw==
X-Received: by 2002:a17:903:454:b0:1bb:b91b:2b2d with SMTP id iw20-20020a170903045400b001bbb91b2b2dmr163437plb.0.1690482602632;
        Thu, 27 Jul 2023 11:30:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:32d2:d535:b137:7ba3? ([2620:15c:211:201:32d2:d535:b137:7ba3])
        by smtp.gmail.com with ESMTPSA id y7-20020a170902b48700b001b8b1f6619asm1979202plr.75.2023.07.27.11.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 11:30:02 -0700 (PDT)
Message-ID: <947d6c80-c66c-e507-22bf-bad91010da5a@acm.org>
Date:   Thu, 27 Jul 2023 11:30:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 12/12] scsi: ufs: Simplify response header parsing
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-13-bvanassche@acm.org>
 <DM6PR04MB657583428E0DE64160EDB314FC01A@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657583428E0DE64160EDB314FC01A@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/23 01:37, Avri Altman wrote:
>> Make the code that parses UTP transfer request headers easier to read by
>> using u8 instead of __be32 where appropriate.
>>
> Not sure, but there seems to be few more places where you can utilize the new struct,
> e.g. in any other place that uses header.dword_x.
> and in QUERY_OSF_SIZE as well.

Thanks for the review. I will send out a new version that includes the 
suggested changes.

Bart.

