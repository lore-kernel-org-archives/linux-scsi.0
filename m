Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE16C3A59E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 15:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C87252339F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 15:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfHUPU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:20:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34561 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729958AbfHUPU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2019 11:20:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so1516817plr.1;
        Wed, 21 Aug 2019 08:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3MUq+62+q1BeUoRQx7zO7y16Wzsx2TMcCZIVUVIU9eY=;
        b=sO1S5EA5j0t+D7clETxg7G+8UTnGgsYoQ7eFOh7/ZjshHnHibLdfWLL+NCMD3mS0Gd
         ksTC6MMnSu3z5wdNlpgNupPC+G+/SyplDTlvD4olT7m2/aoLsogZBEeNiDKmfckgtqnH
         TWbE8M/PdoRIux6hSXXPOtFpDUWt/MTd27+33LL3Q1jtnRpJWKIN7y55ClEkuVxZYtMv
         ZiDj7w1GUB4lhaYd3YsPn6nx/tfVrFoqGNzYdIPAb+ailB3/rOGz3wFKXwvP5pGVA21M
         JROmiCcE+UA5O/G/StE0U8zTeHhiW9wGUzKgBPRMsaafu89xxYtOfXyXy6vO+QMuO61H
         D5yA==
X-Gm-Message-State: APjAAAVjA/cbGLTJnhKdMBYocXgKkebWPrfbXiYZw4Z8jhD7C+j+1a/C
        cHoR6+DHLbuYqGrvf674H7LmEjZO
X-Google-Smtp-Source: APXvYqx6VTY8SvYnIPYD7H96skDVbqUBUIX20kmnwYVW6I6VpfiIPm7l7ctI4G1jHo6dMIyND4saiQ==
X-Received: by 2002:a17:902:543:: with SMTP id 61mr34273025plf.20.1566400826268;
        Wed, 21 Aug 2019 08:20:26 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s72sm31859475pgc.92.2019.08.21.08.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2019 08:20:25 -0700 (PDT)
Subject: Re: [PATCH V5 0/9] block: use right accessor to read nr_sects
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, linux-scsi@vger.kernel.org
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1aaf1d56-c1a2-957c-28b6-048f9965f412@acm.org>
Date:   Wed, 21 Aug 2019 08:20:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/20/19 11:14 PM, Chaitanya Kulkarni wrote:
> In the blk-zoned, bcache, f2fs, target-pscsi, xen and blktrace
> implementation block device->hd_part->number of sectors field is
> accessed directly without any appropriate locking or accessor function.
> There is an existing accessor function present in the in
> include/linux/genhd.h which should be used to read the
> bdev->hd_part->nr_sects.

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
