Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833F4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 16:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJCQpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 12:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJCQps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 12:45:48 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164692ED79
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 09:45:48 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so11719728pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2022 09:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UPnIHwZ0BuzlD0m/9VYTcTGpkPwOtEv5q+vtV1bzey4=;
        b=Tf2g5qE3Czx8A2cXGinWiHI6b8as55r+GEzGAYNq28waRrpnOKOiYp43lgDgEYd20v
         vKttMr8gSCp6XUB7kgM2z1mto2+EcotlD//9ujfj9Tp+53+JgypxragIgrpl0kXJBvil
         V9WtpB+f/7JTa4z7DisU4eryuGU/H3MDJ3ocheYD1ZWR4ZS9cN9N/kvYSUMe2hspIZQ4
         PBGe2SXxH5XWihAZzOQuuISqW5ptHCX6CE4xuf+u7shUKTSx8j9iCjDpp0a5qE5ZrRNG
         OWdHSUkJVcMzoSdmp0/KtPSDEpen+B1PDpG6EbBhj7Br+Jk/cpLyUvzEdtDjSwAIE6mT
         kGyQ==
X-Gm-Message-State: ACrzQf1Ieq90R6l3vgDbmNphx5yqxJTCf/irU5szMmyBgQO0hhhuQfeJ
        2bnfKim0Ii6StXahJx+zhnI=
X-Google-Smtp-Source: AMsMyM5R1jeDYKoT7yo4ie5pAyNc8s4h4uH0AMur98aRDX0Av7Wk9yRZ2SRF8aSAmRzXujRqTx8zKQ==
X-Received: by 2002:a17:90b:33d1:b0:203:7b4b:ba1e with SMTP id lk17-20020a17090b33d100b002037b4bba1emr13056721pjb.128.1664815547449;
        Mon, 03 Oct 2022 09:45:47 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902b49100b00172951ddb12sm7419291plr.42.2022.10.03.09.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 09:45:46 -0700 (PDT)
Message-ID: <5f7ad30c-59b4-ae6e-3d14-f56da22d093b@acm.org>
Date:   Mon, 3 Oct 2022 09:45:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-9-bvanassche@acm.org>
 <888e39e3-4c0e-2fcb-aee8-39ae2ace0da1@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <888e39e3-4c0e-2fcb-aee8-39ae2ace0da1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/22 23:18, Adrian Hunter wrote:
> This is OK for now, but ufshcd_link_recovery() doesn't check for errors
> *after* reset, and retry error handling - in which case it might need also
> the error handling that ufshcd_err_handler() does.
> 
> It might be better to have only 1 error handling function.

Hi Adrian,

I'm fine with sharing code between error handling contexts but I'm not 
sure a single error handling function is the best solution. Having a 
single error handling function and calling it from the timeout function 
would require to add so many if-tests into ufshcd_err_handler() that it 
would make that function unreadable.

Thanks,

Bart.

