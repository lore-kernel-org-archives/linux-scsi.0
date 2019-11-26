Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC69C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2FE2084D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfKZU4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:56:10 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35363 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZU4K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 15:56:10 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so1124434pgk.2;
        Tue, 26 Nov 2019 12:56:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJmsMaZXM//nKOkYvgbY1yglgch9SDDjKC8xdeQu0wY=;
        b=LsE/g2ES5H1/vjk84mDAMZ+Wjyv35wIYLiypa+RyKin4hPtJyCdqbh9MujifeqdJqK
         GZoG9S2rNwSOYxcxMs4yOmlxx3G2eUezWw8Pqd1ulvKeX8gjh3VL4h5LDYiL4rZHXQad
         UXIAeuXJ5+ee80cXxHNTOVykzPc1hyeyhl9HNTNU2w9ShxDCtFjB3XKrotTKs8ZkQSHV
         L13gX6khILU72zA1nUyXY255NAL1hJXQ5Gmp7o2KKwPB9DCaCe1BJHA6CmklJBF60Rdi
         oYaRKv2wtIv7abCvdWRqMRNDC+FK2OOG6GsCbMARHrXq3NWCdd2n85TJ0bjrYC77FJ+n
         USuA==
X-Gm-Message-State: APjAAAWHuPJA5EmU/o/a4IcPhgkHvBLab8ZX8K+VkhON3ncGUZQ7ajNU
        y/4pHqvvhTXhTbsc1YaZGfI=
X-Google-Smtp-Source: APXvYqwbgzWZSwXuDrfDhKh3q5vuYkD8w4SQxF9g1Q/49XU5vKLfhwPaFwkunvE2KvKkXVuQ4+eR5g==
X-Received: by 2002:a63:ec09:: with SMTP id j9mr441737pgh.367.1574801769470;
        Tue, 26 Nov 2019 12:56:09 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e5sm3816843pjv.29.2019.11.26.12.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:56:08 -0800 (PST)
Subject: Re: [PATCH v3 04/13] scsi: qla2xxx: Drop superfluous INIT_WORK of
 del_work
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-5-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d8ed8672-ac41-16fc-d51c-a20f2dbd4f14@acm.org>
Date:   Tue, 26 Nov 2019 12:56:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125165702.1013-5-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> del_work is already initialized inside qla2x00_alloc_fcport, there's no
> need to overwrite it. Indeed, it might prevent complete traversal of
> workqueue list.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

