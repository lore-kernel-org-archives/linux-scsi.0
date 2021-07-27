Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929ACC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 20:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A8E60F9C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 20:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhG0UgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0UgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 16:36:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B5BC061760
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 13:36:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n10so17697163plf.4
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 13:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J1LJxkty0T+2EG5N6tILevoveGNVp9XddCSVMQAbiNc=;
        b=HanxQaA3KFqulGyQuPg5+keLF/F8BdeoflHnlVP4oJ1z1uToyOC4IwuzZJYkmF2fZR
         3goZ39Fq9GqO04J80uYLEq5O/Kzktz9JX6qTSNGF0Bd6w5C8psE+V6CbZXCzOiYRAaRr
         HSH5khop0FdPImoXpnGBxdP3bQbz5fRyeSc5ZYTTWcgZ4Sd/Dnqbh1LHwrZHBg22uIOh
         DDotUXcElGgSyD3dECL/pgbTOSm5W88r1ODleGT1YnmE9zU0qJKhUSMwgOvme+Z5S0Wn
         gFG0B5+za0hNpb4udBSFYEsQpzI+sZC+0s/qy0ByupgvNVPv3zSRpRcx5ptVJliz3f1n
         Qsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J1LJxkty0T+2EG5N6tILevoveGNVp9XddCSVMQAbiNc=;
        b=LWxWoKIHHmIQB2j8lhOJtHlUPoro+XjDXhVS8S0lLfpZuUfk/zCPFz4Z2+QIJ5R5dO
         5ieHDS+M0dMIiFdF4I3YVBXwv66UPv0s49grhfGAGui9+MDGjYueHsv5aA1Ee6jqemcQ
         gP88kfuoPWN3GkEdQafvV0PuJG09jjn0PuopJ1RCt/3r3PmwaY7YCJT0fnzL9HUNcPB/
         KeEHvwinm3WCJ28uA06ZmtKjEDDmrKx7FpgQ4RxvPEa7mjQ29H1xT2BFUgRLrDbeH0vz
         h6y8LvLr9zGsVyWrqOl3DMwEOQEtqsBL/JBWFFVBpkbMR0cNjb/TT+Kh7fBHt6z13j9e
         mkSg==
X-Gm-Message-State: AOAM5330BusaapchcUBupxFvoshkHi9ro8Swa7SAOVHlVVoheL0IM3bx
        aVXTQvO4ePEyRlr0Rk/tvVTeUrr/f+o=
X-Google-Smtp-Source: ABdhPJwq5EFqXSn+A0LmUPdM7Cj2NzWTU4XIb40g5XyUjlt8KeFXAKyJEdUElPVlAizfzdLg4PTLiA==
X-Received: by 2002:a17:902:9006:b029:107:394a:387 with SMTP id a6-20020a1709029006b0290107394a0387mr20532408plp.35.1627418182873;
        Tue, 27 Jul 2021 13:36:22 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w23sm3910518pjn.16.2021.07.27.13.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 13:36:22 -0700 (PDT)
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.0.0.0
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210722221721.74388-1-jsmart2021@gmail.com>
 <yq1czr4sbr9.fsf@ca-mkp.ca.oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <ef275f8f-9e86-c746-c112-37ce4bee1845@gmail.com>
Date:   Tue, 27 Jul 2021 13:36:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <yq1czr4sbr9.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/2021 7:59 PM, Martin K. Petersen wrote:
> 
> James,
> 
>> Update lpfc to revision 14.0.0.0
> 
> Applied to 5.15/scsi-staging, thanks!
> 

Hey Martin,

Thanks for keeping us rolling.. :)

-- james

