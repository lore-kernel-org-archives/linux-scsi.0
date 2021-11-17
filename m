Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10A8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 04:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE3B61101
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 04:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhKQFCA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 00:02:00 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:35515 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhKQFB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 00:01:59 -0500
Received: by mail-pf1-f170.google.com with SMTP id c4so1519014pfj.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 20:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gO/bcFntL6bvRVJ5sEV4wzjFRayBuWMuLN+o6PVqets=;
        b=Ewgn9GQvuBJrUqzl/blHerUYa7aDPR5iHrz4zA0osfBbUhaP07KN/+670lZqH6Zl4d
         Pnpqpf5BJLTUsqcDMp4fXUpMVQxmzF7LKBQSoXnIt0gH7J29eykEqDusv5GVrB1r/LXU
         SHMlRKHprit5oCDeIZMMIqnrQYCWscTZY0X7c4rr18CzrWtfqzijqS09hshN5vNawy/J
         qwjnJFWaHEc6jxxeAUBBFJZy39oWKxu4wbGL8ai38YlVnViiCH1Gt0jmrFrAYQCn3XvQ
         eQekj9Cy4jTIkzrr/SRm+lrvIgwwBoqpmisdbF0yxSUxIDAuVo2+QNN1Uk6prZgXQ4Yv
         920g==
X-Gm-Message-State: AOAM531Q3cE2sKfwNLimXezk3xEJyvs/I2+POpaosHKTB0U/MNT+7kzj
        PtFyZ1PB7ePEfUYkekSvh8M=
X-Google-Smtp-Source: ABdhPJxq1zijFOQ5oswWnm1mbxuIkbNbffB/2xAhk9blxDi1muo4dydKm5U9JsLDwgooT0YzrERHQA==
X-Received: by 2002:a63:de48:: with SMTP id y8mr3217508pgi.255.1637125141536;
        Tue, 16 Nov 2021 20:59:01 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o6sm3686797pfh.70.2021.11.16.20.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 20:59:00 -0800 (PST)
Subject: Re: [PATCH 03/15] scsi/block PM: Always set request queue runtime
 active in blk_post_runtime_resume()
To:     chenxiang <chenxiang66@hisilicon.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        john.garry@huawei.com, Alan Stern <stern@rowland.harvard.edu>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-4-git-send-email-chenxiang66@hisilicon.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <99d9acbe-b7d1-cf28-3b41-75c21af389e5@acm.org>
Date:   Tue, 16 Nov 2021 20:58:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-4-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 6:44 PM, chenxiang wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> John Garry reported a deadlock that occurs when trying to access a
> runtime-suspended SATA device.  For obscure reasons, the rescan
> procedure causes the link to be hard-reset, which disconnects the
> device.
> 
> The rescan tries to carry out a runtime resume when accessing the
> device.  scsi_rescan_device() holds the SCSI device lock and won't
> release it until it can put commands onto the device's block queue.
> This can't happen until the queue is successfully runtime-resumed or
> the device is unregistered.  But the runtime resume fails because the
> device is disconnected, and __scsi_remove_device() can't do the
> unregistration because it can't get the device lock.
> 
> The best way to resolve this deadlock appears to be to allow the block
> queue to start running again even after an unsuccessful runtime
> resume.  The idea is that the driver or the SCSI error handler will
> need to be able to use the queue to resolve the runtime resume
> failure.
> 
> This patch removes the err argument to blk_post_runtime_resume() and
> makes the routine act as though the resume was successful always.
> This fixes the deadlock.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
