Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C069EECE58C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 957A52190F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJIQOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:14:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38663 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731626AbfJIQOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 12:14:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id w8so1276393plq.5
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2019 09:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q8UUtSwD4Ge2E7y2l4PAoEGhp6rAeMWVIXkHn1/AF8M=;
        b=k8d/hJLeK3wYasCbkPy+tfq4ubN1nNmTIMtbi2z0BSZdAmkS2ew7YPVUhwGuomf3wE
         YVa3cQNY24hvsWEnMUsQZH30L/AiQO8pEC5vBXEV9i6nCMQUcWuh9EX1pnhHBhVXLncI
         7SGuJTlN4GyD/YypLiveJY8p91zgNnfy3WF477ZYjfOdRjnPrJ50KLNzw41UdFvwkLwA
         0POjVkm78qnv3XaljTd6KyPjQ27NiCi2DG+haqc2Tc+zrRTdUqNmwDcIHSz3raO34NUE
         nF0IXSCINM/1cDgix/uXRw/Dg+zVHgPZXjjZRkhF8YyTtbj9Ia/iO5RdvxqE2hqeKqYa
         IEkQ==
X-Gm-Message-State: APjAAAWSjwOdPHwnnZtOuUfQl3ZZ/1rd8oKxl2lAjnZkM6TncRD1jP5+
        8C7Y8HA9PTNmHdbD9L7PZV8=
X-Google-Smtp-Source: APXvYqz5IKyJoS9f5tvilQESUa4lZZwqO8CI++KA7oaY5qHeqXevY5v2bZ/w3s/2g/HDZfNNdsn4cQ==
X-Received: by 2002:a17:902:6b05:: with SMTP id o5mr3946193plk.33.1570637688972;
        Wed, 09 Oct 2019 09:14:48 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 22sm2807532pfo.131.2019.10.09.09.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 09:14:48 -0700 (PDT)
Subject: Re: [PATCH V4 1/2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-2-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <55c68a97-4393-fa63-e2da-d41a48237f96@acm.org>
Date:   Wed, 9 Oct 2019 09:14:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191009093241.21481-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/19 2:32 AM, Ming Lei wrote:
> Cc: Bart Van Assche <bart.vanassche@wdc.com>

As one can see in the .mailmap file in the kernel tree I use my @acm.org 
email address for kernel contributions. The above email address is no 
longer valid since I left WDC more than a year ago.

Otherwise this patch looks fine to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
