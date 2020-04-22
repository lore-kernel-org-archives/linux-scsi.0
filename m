Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0D0C54FCB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 15:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E8E206CD
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 15:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgDVPGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 11:06:23 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40406 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgDVPGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 11:06:22 -0400
Received: by mail-pj1-f49.google.com with SMTP id fu13so501594pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 08:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pe+B80ccCzmfy+zZW9aWMyygmYU06yDYDif82Lx+nb8=;
        b=TIwUzADLRWH+YPCwSnTfnjhUCPWx/NeRM1oyNl3QNFcMETHMLfP93vM4gmk1djjmX3
         OoiBGmT+eXmqUOmFg2QTXn6XWAAyQcmsDNQwanMn/xnGloQ52eQc4/c/bKkQr+E0Hrjc
         aHBDXk0FGgn5bmp6VrRtuUm+IxmOtDeNZthBeBLy6aHzAK5LTy+FWadJuaaHyRNuzfTL
         AJa9JnSzCk+RFw2kp+r/dMVtfW8lv89CpfreltU53aaQt0M3E8fGJAl9NfCmuoS4sD8o
         gdhEcoxdIXs2S3HRGy4JBVEOsK+ur3IwY2lCcDgj4a0oCsaZcVqN02eqDdxyglTHr6Ao
         PvHQ==
X-Gm-Message-State: AGi0PuaT/MYLW4W+AZ8PtfXETGJHaETolsA6sY4R8DYEvLNjYNW4Vv6F
        zc0sFojXMPRqr6n/cwsfB00=
X-Google-Smtp-Source: APiQypJCQhMm0YuO4DThEqu0Zmk+iBpC7H6vD+oTAufitR4e+ITY1lOtiTNxmGBdIYWGkwHP7wNkzA==
X-Received: by 2002:a17:902:b097:: with SMTP id p23mr27099192plr.263.1587567981597;
        Wed, 22 Apr 2020 08:06:21 -0700 (PDT)
Received: from [100.124.11.187] ([104.129.198.219])
        by smtp.gmail.com with ESMTPSA id o15sm5415113pgj.60.2020.04.22.08.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 08:06:20 -0700 (PDT)
Subject: Re: [PATCH] scsi: avoid to run synchronize_rcu for each device in
 scsi_host_block
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
References: <20200422101433.321581-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6022db12-064b-bd63-391e-6bacc8742f1a@acm.org>
Date:   Wed, 22 Apr 2020 08:06:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422101433.321581-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/20 3:14 AM, Ming Lei wrote:
> So use scsi_internal_device_block() to implement scsi_host_block(),
> and just run once synchronize_rcu() because scsi never supports
> tagset of BLK_MQ_F_BLOCKING.

Please add a reference to BLK_MQ_F_BLOCKING as a comment in the modified 
code.

Thanks,

Bart.
