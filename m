Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDA6C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A4B32076E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHApn/9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgDVEUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726396AbgDVEUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 00:20:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6CC061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:20:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id q18so438760pgm.11
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ioJ4MC6xHJ0fCU398jhksPmwZhmWGWEo7ea1JuhIsS0=;
        b=WHApn/9OuOxwsvBZ7egFY9+nVZ7kQr6CSWVBSCTSLV/N0On8V+j6MvWsVu8/qFdXYs
         qg+rfoCNG1rk5oWjWbi7y9DjYb0gIjW3ZK3gB3NorgAwHs6fUlY1b50/653OJpivM9T8
         k80xJ5Mb5P5xPQyRHYtARWP2iWx7+fv/Thh2vN8AKij3ET67vhHmkxkyl7r0j1qjl79j
         LkhitW1mdLoeuIcx9zYtSzvNj73bJMkKK4VMaXX6+hr3Sh1n9EOC/KvT/kWNtFyQV3NP
         4WNqPvbuGrXiKFXBLr/nYO8g5lQE7jvE0gknVcPtphvZpKxHa7EYu7r/LCi2FdFx3R1v
         yGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ioJ4MC6xHJ0fCU398jhksPmwZhmWGWEo7ea1JuhIsS0=;
        b=JTj+ebL1xOUmvsu1G9rn9TWrIFPTr1wBDsHV0MKUhPf1GOTKiCYbzsoRT6cB7YNadC
         rqyg9kTgR7GQu3Ml3LSvPm+tdGplPAcbNvlEQZ4atU6DriRi/Dv3w6VWDJVxf3Cft631
         ta2CFjuFvbcvYeZZVwf9WOkMz0gUYVUCeZhf92O6cZnfyojBmcYkRZ/sxzVUO4gf1U4h
         jTZkIC9E03FVdO1M0b4WlwR+HAgOyGU18rNkZGFR5KzVdGIg7tolnKl9Z9Cx6mQrPLfg
         AXBO9jA+JQNLKXdGo8nnDbNmdmGvtxTgVwfS/E0Xhw5b0/dMc//28TyNuIbGnmFMf5qg
         xYRw==
X-Gm-Message-State: AGi0PuYaGqy/37LjT1k2cbgc2Vunywe1PNMlsJT+FWaocAt1V2ldjV3B
        Ml0fJWzQAk1tDfqQ46dO2cE=
X-Google-Smtp-Source: APiQypIZu2/FMl5JHcjCKlcJC7JZqNpqWJthp+6rd3yHu1tD7rX7IfPKoO0O/7oxnI4u3/4rq/oBZw==
X-Received: by 2002:a63:7884:: with SMTP id t126mr4736615pgc.45.1587529217182;
        Tue, 21 Apr 2020 21:20:17 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w66sm4004316pfw.50.2020.04.21.21.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 21:20:16 -0700 (PDT)
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
 <20200416123425.lj2clovshk5yxz6g@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <af55ebbe-c747-d95b-2d1d-4be0fcb51834@gmail.com>
Date:   Tue, 21 Apr 2020 21:20:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416123425.lj2clovshk5yxz6g@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 5:34 AM, Daniel Wagner wrote:
> On Sat, Apr 11, 2020 at 08:32:56PM -0700, James Smart wrote:
>> This patch continues the efct driver population.
>>
>> This patch adds driver definitions for:
>> LIO backend template registration and template functions.
>>
>> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
>> Signed-off-by: James Smart <jsmart2021@gmail.com>
>>
>> ---
>> v3:
>>    Fixed as per the review comments.
>>    Removed vport pend list. Pending list is tracked based on the sport
>>      assigned to vport.
>> ---

Agree with your comments and will revise.

Thanks

-- james

