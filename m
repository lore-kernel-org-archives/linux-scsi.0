Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A275C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 17:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDLRbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 13:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDLRbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 13:31:46 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE15A3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 10:31:45 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id g3so13524725pja.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 10:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681320705; x=1683912705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgmbl+XK15YzbbDoL2O/rxxGSj5WtgWdjUy0jIPur4Q=;
        b=DOBRwrUXIkcmTqpmI4ud18AIjBKP99qbl1dSzr3n9Wk+BmmHfkOxSvjpo/oVAeAHC5
         nZXxRuMWBtgHbcY0wQqisIHfqHQNnPGJpgiCdRXwIZbMkbaSJXX/HwPVw+eZe4jbVEZu
         dbjw/SYGA4D4jgEYUDnn+7A1i6abbqERMcijJaL8anFBlEmOAv0mWhBen1OvkSS45naU
         lHW0BtBV0wsQNGZw33GfZkSz0f14CzQCir/NC1Og3bT9yqVduPOS55e2NmBX6QmEj7BR
         RAgL9K77CPRIlDxa4R+cahKTo+hEzUbTEhGWYeKmRtc6Jv1j1Bd27GV/BYCbvgrR8QPt
         iZ4g==
X-Gm-Message-State: AAQBX9dyedeRt33XaE+avgONyD42cEUmAqWTKNw+0xQvi/nboQuVCzi/
        06GWTkNK30y7htLXWFtKQlc=
X-Google-Smtp-Source: AKy350YMkgnQsIdfaLyk5tqcWAMo4LRBeYSiHEdgBYpHu9/7L6rMUHQaWPPKYUhjAN5mmZnrvfmOrQ==
X-Received: by 2002:a17:902:d501:b0:19f:8ad5:4331 with SMTP id b1-20020a170902d50100b0019f8ad54331mr4091394plg.38.1681320705080;
        Wed, 12 Apr 2023 10:31:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d89d:35dd:5938:1993? ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id f7-20020a63e307000000b004fc1d91e695sm10578397pgh.79.2023.04.12.10.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 10:31:44 -0700 (PDT)
Message-ID: <e195646b-ab46-469c-7eef-c24399512502@acm.org>
Date:   Wed, 12 Apr 2023 10:31:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
 <17217146-9c07-3963-fd32-02704632330d@intel.com>
 <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
 <a71dc651-a306-eebe-968e-0d9e56f44a76@intel.com>
 <ce0794e1-45d5-c76a-9835-7285353e786c@acm.org>
 <3e669a6d-9fe9-81f2-2991-d7a02be5d7b1@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3e669a6d-9fe9-81f2-2991-d7a02be5d7b1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/23 10:24, Adrian Hunter wrote:
> Wouldn't that only work if commit dcd5b7637c6d had a Fixes tag too.

Hi Adrian,

I will add a second Fixes tag and repost this patch.

Thanks,

Bart.


