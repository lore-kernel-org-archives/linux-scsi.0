Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E409EC11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 22:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B305961476
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 22:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhF3WKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 18:10:44 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:33526 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhF3WKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2021 18:10:43 -0400
Received: by mail-pj1-f52.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so4665836pjb.0;
        Wed, 30 Jun 2021 15:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=itel9TJ+NQ61h1BnfnOgz6HA8ahL/K/rKSKzUsDI3HM=;
        b=LHolUMjwvcNxDY6Yye2sjB+ESSRFIpC8fuk++BHyhnApICCTt1hMeTYmj+46qdnnKb
         YIq6rfj3mgSscWR9rjb4VpgsS9W2cl0z5dWxJgb0oiaDW34OVwWELsKCtBKrolaxZpNz
         wSTXjfY1ecPOOe/2PskFGZUfuI6xvo6+7FkMfdEyQi8khigSMF5e5lbfyyde69cGQDOY
         VbAFjI/dmbLFZs5vpVr9UTa9ukHDi424S5qHi7HaPPgp/toGYbdNEqNQX2luNlUGa4Wc
         cfszQ2yKhKUNV87MkadRbuHQQTWOC1jRtIVeW3/ke/1OMpUjirwYn/m1awRyDCvqvi3z
         fSIw==
X-Gm-Message-State: AOAM532/5stmpL92CN2CQv0laBKFGazZifu4fWuWiJTsapvpQCRjsb8Z
        y6JbDNfREZ4F84xThjh1+R8=
X-Google-Smtp-Source: ABdhPJzkLCHPYFnnLC8fI4RqIsJPvxZ1rPwxyDzUQpapeaJ9De1uI/RJiqNalFcrBqZceBenrDJPHA==
X-Received: by 2002:a17:90b:4c4b:: with SMTP id np11mr6453051pjb.125.1625090894303;
        Wed, 30 Jun 2021 15:08:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a64c:e202:83eb:cd? ([2601:647:4000:d7:a64c:e202:83eb:cd])
        by smtp.gmail.com with ESMTPSA id t7sm22433442pfe.201.2021.06.30.15.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 15:08:13 -0700 (PDT)
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
To:     Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
References: <20210628095210.26249-1-mwilck@suse.com>
 <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
 <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
 <20210629125909.GB14372@lst.de>
 <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
 <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
 <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
 <YNyVafnX09cOIZPe@redhat.com>
 <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
Date:   Wed, 30 Jun 2021 15:08:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/21 9:54 AM, Martin Wilck wrote:
> @Martin, @Bart, do you have a suggestion for me?

The code in block/scsi_ioctl.c exists in the block layer since until
recently most of it was used by both the IDE and SCSI code. Now that
drivers/ide is gone (thanks Christoph!), how about moving block/bsg.c
and block/scsi_ioctl.c to drivers/scsi/? As far as I can see the BSG
code is only used by SCSI drivers:

$ git grep -nH BLK_DEV_BSG | grep /Kconfig
block/Kconfig:38:config BLK_DEV_BSG
block/Kconfig:57:config BLK_DEV_BSGLIB
block/Kconfig:59:	select BLK_DEV_BSG
drivers/scsi/Kconfig:231:	select BLK_DEV_BSGLIB
drivers/scsi/Kconfig:241:	select BLK_DEV_BSGLIB
drivers/scsi/Kconfig:250:	select BLK_DEV_BSGLIB
drivers/scsi/libsas/Kconfig:13:	select BLK_DEV_BSGLIB
drivers/scsi/ufs/Kconfig:150:	select BLK_DEV_BSGLIB

The block/scsi_ioctl.c code is used more widely however:

$ git grep -nH BLK_SCSI_REQUEST | grep /Kconfig
block/Kconfig:32:config BLK_SCSI_REQUEST
block/Kconfig:41:	select BLK_SCSI_REQUEST
block/Kconfig:60:	select BLK_SCSI_REQUEST
drivers/block/Kconfig:77:	select BLK_SCSI_REQUEST
drivers/block/Kconfig:309:	select BLK_SCSI_REQUEST
drivers/block/paride/Kconfig:30:	select BLK_SCSI_REQUEST
drivers/scsi/Kconfig:22:	select BLK_SCSI_REQUEST
drivers/target/Kconfig:8:	select BLK_SCSI_REQUEST
fs/nfsd/Kconfig:112:	select BLK_SCSI_REQUEST

Bart.
