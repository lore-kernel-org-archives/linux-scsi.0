Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149BDC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 21:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F246115C
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 21:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244687AbhJPVXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 17:23:52 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:40556 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbhJPVXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Oct 2021 17:23:49 -0400
Received: by mail-pf1-f174.google.com with SMTP id o133so11472902pfg.7;
        Sat, 16 Oct 2021 14:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pP45eXzz1JfHD3xUyRKD/lLddvhCQLEQjybOQXsKJZk=;
        b=spV28wBqRYQCuNjuzFlqG/D716dSPcWcub8LjEOjEdZb2ZQ84uvwO5D+J/55cP+N4G
         cfWN93Q3BjJggPUfGaWTICC94pN6fb7E6MXDXAOqYXjixLhf6RUdNWv7wPZagrTQnwdJ
         PJPsXxYRZsUzxUL1lgxbYmvdWjmfogKz5Zrfu2Ho5aaIHT2Hyv51kH0ndoYOF15bvMHJ
         eIiSCEM8fUSKIU5WEGqldOU/Fj/g30hvsld9AXjBRW7wOMUU6TIhVp4wv1Wc6o8rz4fe
         9spAvxyGYJuYBuFF85B4Ba997lbyRtBvimgdo1wGfDrNpVnjxyRmBxWOrwNE3sZJdIPV
         b/fg==
X-Gm-Message-State: AOAM533a/vheEriQYK4PVn09ns00kDO4XR4scM6/JPVst5eA98kHxERk
        tPD3NouOQzRDSppHgFmbEv0=
X-Google-Smtp-Source: ABdhPJzPTxj6WaG/HsuZwJMHGnDS0JgiG83KKopx8Ui7F+UjhcNXoTQQG+G0LUYmgeY01QR00i7skg==
X-Received: by 2002:a63:3481:: with SMTP id b123mr15521900pga.230.1634419300624;
        Sat, 16 Oct 2021 14:21:40 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:f0a3:eba0:b940:fc7c? ([2601:647:4000:d7:f0a3:eba0:b940:fc7c])
        by smtp.gmail.com with ESMTPSA id k3sm14836806pjg.43.2021.10.16.14.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 14:21:39 -0700 (PDT)
Message-ID: <a6354cfb-753a-8376-b96c-f35fda9b9b8a@acm.org>
Date:   Sat, 16 Oct 2021 14:21:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211015151412.3229037-4-bigeasy@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 08:14, Sebastian Andrzej Siewior wrote:
> +static inline void scsi_done(struct scsi_cmnd *scmd)
> +{
> +	scmd->scsi_done(scmd);
> +}

How about leaving out this function definition and open-coding it into 
its callers?

Additionally, please rebase this patch series on top of "[PATCH v3 
00/88] Call scsi_done() directly" 
(https://lore.kernel.org/linux-scsi/20211007202923.2174984-1-bvanassche@acm.org/ 
or https://github.com/bvanassche/linux/tree/scsi-remove-done-callback). 
Otherwise Linus will have to resolve a very complicated merge conflict.

Thank you,

Bart.
