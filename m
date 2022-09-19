Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6402C6FA8E
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 23:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiISXTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 19:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiISXSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 19:18:22 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93464DB6B
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 16:18:00 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so8921907pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 16:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IKz4AzsmtIxg3bISKsa+2ov8z8KN45FYHmxPcgPwIwo=;
        b=GLPx5IHUdsvMqK0C1VoftHkjYPXdh1f4jjO2u2738Bq6EWyEwId0CEcyonnUJw7kgY
         76bH/iQ6+9UYLwtF+KASULlVJJosQ4qTbInCpkn05EQlGmbIjIS5FWpYH42XwKf8NFQP
         ROhKXQfusnCLYKvYOUG8QQc08D4BqIa5s2/ju0jV4v7DzHK9J4TbVgMYb2Boqw855ZvI
         VITFUeiOG1G/l2iZ7xlUFyDlGRutIuy6ZEN0zOVUXzbgpJUl9u8DB+fHtRC98mLojnXz
         C3x4Fax4uyVmpqJx5iUaMx6wG8eq75WdjnJ2l/1ZOA30eMyZCN1IpycXdpbyFS8Wjg/Y
         vLrA==
X-Gm-Message-State: ACrzQf2/Lpho84M+CCjv4RVMPt18TipXr+U/aGlX4nRNpzZKD0h1A15I
        l1OLISkZZ607QobiCO3XodY=
X-Google-Smtp-Source: AMsMyM5PsUcZfnzZzw1EZ35svyL5aHHb4gZ1amUaQEjkHzc5oLbtkbnHVWNDfATIPG+thYCZpSL3lQ==
X-Received: by 2002:a17:902:e54b:b0:177:e29e:a0c0 with SMTP id n11-20020a170902e54b00b00177e29ea0c0mr2094742plf.66.1663629479760;
        Mon, 19 Sep 2022 16:17:59 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:520:42c6:2cee:67ae? ([2620:15c:211:201:520:42c6:2cee:67ae])
        by smtp.gmail.com with ESMTPSA id rv11-20020a17090b2c0b00b001fb3522d53asm7269271pjb.34.2022.09.19.16.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 16:17:58 -0700 (PDT)
Message-ID: <f75c75e2-b2eb-abc1-c600-86c6ee235fda@acm.org>
Date:   Mon, 19 Sep 2022 16:17:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: ufs: Fix deadlocks between power management and
 error handler
Content-Language: en-US
To:     "Asutosh Das (asd)" <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        dh0421.hwang@samsung.com, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220916184220.867535-1-bvanassche@acm.org>
 <2be5b57f-f367-2e28-c317-e0daedcfb3a4@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2be5b57f-f367-2e28-c317-e0daedcfb3a4@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/22 20:10, Asutosh Das (asd) wrote:
> Say, there's a PWR_FATAL error in ufshcd_wl_suspend().
> Wouldn't there be a scenario in which the suspend and error handler may 
> run simultaneously?

This is something I need to look further into.

> Do you see issues when that happens? How about when shutdown runs 
> simultaneously with error handler?

Hmm ... I don't think that my patch changes the interaction between the 
shutdown handler and the error handler?

Thanks,

Bart.
