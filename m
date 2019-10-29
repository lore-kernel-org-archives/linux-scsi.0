Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB26CA9EC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 19:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD262087F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 19:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="oZJBSaUp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfJ2TVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 15:21:00 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45472 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfJ2TVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 15:21:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id x21so4695306qto.12
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 12:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VLkdCW6fO/kdWcmvO5mZyGXLIND8hrF7Fib2pxaeHqE=;
        b=oZJBSaUpNctcJF1KPdB1q8131m6M3DuwlLqWAJBVS6+GtrrEUnTJ1YGxdkS3laLv/O
         jbUP78t8eppIZnsu1Oii9SJoWBXa0OBhG36OFp7u51/3lGHXsn+VQYbT6kOR2sO+QwXd
         tjsQb41gUyoRm4bK1vv7btWy9MQFDDhEeF4izUxUvtT2UIEk7nyefrLIBkskCqYHAElq
         Rq8H1CE0ostW9lFtEZ5Jw2639tSC9ud5q/I2QwJdHgG/2KVwqQwPQ+jzM/SSmNvnK2Ap
         cf5ZIf7AfPFt4Gt7sZX/DFr4WIrjyQnY+nr7XuMq9q8L4G2k2YgdWpWihZNFr4HIDqFQ
         Uhhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VLkdCW6fO/kdWcmvO5mZyGXLIND8hrF7Fib2pxaeHqE=;
        b=WUKFXscdbxivBgALpPRh+0WDELtfvMOpCfcSuqVC/KPgz5TqSTFQNxKDxh6Io+2fi8
         yXXATzErPR6gDMK4icorEakovdog1K3JA7ZTpN2sThlAVLqpBQg3sBo5N1EQX0KejFn6
         SgO8rVYldaBu+QE6uzjEKdRA/665zec0DxLi9LIgzjWMlA9YAne46FqgF4xEhGkkv5+M
         KgPIU6e5boxEKR3QgbjEpm+TY7YRrrPnpVk3iI3cnJPR5pxqeTD7KHG9V78sZJQJXIXr
         B6gcdndvqTuW5CahoyT2j4fn3VxfUPAvd0VpH+pU/6usSZ0BIBn+ua8/a49QQGyzwyo3
         YKuA==
X-Gm-Message-State: APjAAAVBcvSPOjYqbC6XP1y+rYkBOEZ5CoJ6rmaE3UWsIOqaq1u3SpM0
        V+Nac4UnqU6GcT3e6C4Go17kgA==
X-Google-Smtp-Source: APXvYqw9LzxzmjdLYLHltS5J607RC70qGlqUtWazEs9u72lKOb9c3az5HfcxcKJrFLefSp5tx8dDpg==
X-Received: by 2002:ac8:2476:: with SMTP id d51mr752878qtd.378.1572376859018;
        Tue, 29 Oct 2019 12:20:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id a6sm7311724qth.74.2019.10.29.12.20.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Oct 2019 12:20:58 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iPX33-0003g8-W0; Tue, 29 Oct 2019 16:20:57 -0300
Date:   Tue, 29 Oct 2019 16:20:57 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] iser: explicitly set shost max_segment_size if non
 virtual boundary devices
Message-ID: <20191029192057.GA11679@ziepe.ca>
References: <20190607012914.2328-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607012914.2328-1-sagi@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 06, 2019 at 06:29:14PM -0700, Sagi Grimberg wrote:
> if the rdma device supports sg gaps, we don't need to set a virtual
> boundary but we then need to explicitly set the max_segment_size, otherwise
> scsi takes BLK_MAX_SEGMENT_SIZE and sets it using dma_set_max_seg_size()
> and this affects all the rdma device consumers.
> 
> Fix it by setting shost max_segment_size according to the device
> capability if SG_GAPS are not supported.
> 
> Reported-by: Jason Gunthorpe <jgg@ziepe.ca>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
> Changes from v1:
> - set max_segment_size only for non virtual boundary devices
> 
>  drivers/infiniband/ulp/iser/iscsi_iser.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Sagi, are you respinning this or ??

https://patchwork.kernel.org/patch/10980657/

Jason
