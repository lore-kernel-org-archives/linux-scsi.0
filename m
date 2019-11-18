Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2CAC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 15:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC6F20898
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 15:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="vLpgu5v+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKRPdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:33:12 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44314 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKRPdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 10:33:12 -0500
Received: by mail-il1-f196.google.com with SMTP id i6so6962634ilr.11
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 07:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YS184bGN6J9aePOBe16ozqbDzE/B0ihMCWCOanLvA5g=;
        b=vLpgu5v+D2olah9Wi43FZ6HK8MhA2Y5rf8HIDP/s70aP9Efbrd3heTA6s4ZlNIKs0n
         ISkSRgR1l9H9wH/43ehcjXj+w70RoyMQAXC0w2YEgZm5mOifEXGN/tzKyx82wGIuCyZ3
         L0BoWn/J9hW+h3sL+pKDbyk9J0HjIFBfir1gt6y/LWvik3ojjsSo9NysNFfNB0SL2OAu
         mlma09eTHtOtokmu0DyHw6mHxQnlZWHr7UxcJOmXH0VK4KTtSur4B5+Y2D5WjXxlUISJ
         3SFUNXvZNnyXedpAm5by+A9KzSpew63ijEEdTBWbNN0fMvWU3BUTjD3MvIR5aC9IoE5F
         Rr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YS184bGN6J9aePOBe16ozqbDzE/B0ihMCWCOanLvA5g=;
        b=o1C8KYYoviODXUpUj+0zwp2voQvt8fvvbTxa09RMAG9xWR/liFBziLh6wYxgV2f1Xq
         e+jOl34p6kf1TeETv9XK57lQHI/t/gZWYSVPPR5tv/Lh9F1gZ+xaXZNqMMgg/fwjkD3n
         seDpO2OoNS+ZSO8p6LqhUwFxUHzlabIx0WXy8SgROUm4/BiH/0cS3NsFsHsFOpE9Vsp2
         FIQz3JRE8YyY2t8WjJK0LoTp9rBVziPFKpiz6FsQoRCxl8pMKEzb2eCnBqjy8Rznf5fr
         DzbzM2l35IU3wspmKiw8LKzpk8MyglqIRTI96TOM67Fkr+b6hfedo+ZaKXmcyiFC6u1G
         NDtQ==
X-Gm-Message-State: APjAAAXiLmQPxP88qI5a9gL0yPPG9EkPTacXddB+gNYWxcvIkaqT9aWq
        /rszGLtAyNDnK85R6eY0IrCsFA==
X-Google-Smtp-Source: APXvYqzwsBX5JB5z9XzVfjupL4dDEpkaqvxBhu+HScemh7bwuROVhXdNmpSWX/fjlI/hINiwDg/PcA==
X-Received: by 2002:a05:6e02:d92:: with SMTP id i18mr15984126ilj.20.1574091191085;
        Mon, 18 Nov 2019 07:33:11 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z69sm4547097ilc.30.2019.11.18.07.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 07:33:10 -0800 (PST)
Subject: Re: [PATCH -next] scsi: sd_zbc: Remove set but not used variable
 'buflen'
To:     YueHaibing <yuehaibing@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20191115131829.162946-1-yuehaibing@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <321d25d4-2216-dae2-268b-ca225c5e5caa@kernel.dk>
Date:   Mon, 18 Nov 2019 08:33:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115131829.162946-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/19 6:18 AM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/scsi/sd_zbc.c: In function 'sd_zbc_check_zones':
> drivers/scsi/sd_zbc.c:341:9: warning:
>   variable 'buflen' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit d9dd73087a8b ("block: Enhance
> blk_revalidate_disk_zones()")

Applied, thanks.

-- 
Jens Axboe

