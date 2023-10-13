Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B71CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 21:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjJMVU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 17:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjJMVU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 17:20:27 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D736595;
        Fri, 13 Oct 2023 14:20:25 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c9b1e3a809so19513475ad.2;
        Fri, 13 Oct 2023 14:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697232025; x=1697836825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVUFHAu/2sYouE1MxKgJ7Ed5BvhxAi40Dur2aHaRFxo=;
        b=OruRU4Ex0fSwyHNSI/LDbobXFQklHAltlctNI6AJ8bk/9HlTNAp529+3t5gCV2byTu
         1IDsbpMp2+evTLaw60gepJuIzI44BR755XKea8cg0qtD9vGh9JLvJJNdmGU4DMgGhw5Y
         B8dvQSWwyvflRbukz58VoasmwpqFgEYYs4He1ZVIngYlweY1q4n6QDcAOrecXisSk3af
         +riIDqdAFd6NJ0Jy4gceFBVyH6kf++j8bbBz/N4L6f01CSnHzJ2olR2RNyVlfvvg/+RS
         PMkSl9y/xzApELhsbFe3P86DDhE3ATJur3rSkQRBnfvk19rv/7oFLOYJWYffXxPA9zsL
         qfSw==
X-Gm-Message-State: AOJu0YwK8rw6oSXDWnZUFgDwQNgyoltn8b7S8uPH4AT2rCfwi2aDUqNf
        HqkCKEZz7/NL06XIdlxoSsE=
X-Google-Smtp-Source: AGHT+IGMaA51IPk0x7pCW8F4JdKMyqzT3Q+dPbD1hFblj4gUedpX4Qp42cPYMap9ZuK83w6URwX6Ww==
X-Received: by 2002:a17:902:e74b:b0:1bb:6875:5a73 with SMTP id p11-20020a170902e74b00b001bb68755a73mr32624279plf.2.1697232025201;
        Fri, 13 Oct 2023 14:20:25 -0700 (PDT)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902b78b00b001c5b8087fe5sm4308085pls.94.2023.10.13.14.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 14:20:24 -0700 (PDT)
Message-ID: <2f092612-eed0-4c4b-940f-48793b97b068@acm.org>
Date:   Fri, 13 Oct 2023 14:20:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <20231005194129.1882245-4-bvanassche@acm.org>
 <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
 <46c17c1b-29be-41a3-b799-79163851f972@acm.org>
 <b0b015bf-0a27-4e89-950a-597b9fed20fb@acm.org>
 <447f3095-66cb-417b-b48c-90005d37b5d3@kernel.org>
 <4fee2c56-7631-45d2-b709-2dadea057f52@acm.org>
 <2fa9ea51-c343-4cc2-b755-a5de024bb32f@kernel.org>
 <ZSkO8J9pD+IVaGPf@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZSkO8J9pD+IVaGPf@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/23 02:33, Niklas Cassel wrote:
> In commit c75e707fe1aa ("block: remove the per-bio/request write hint")
> this line from fs/direct-io.c was removed:
> -       bio->bi_write_hint = dio->iocb->ki_hint;
> 
> I'm not sure why this series does not readd a similar line to set the
> lifetime (using bio_set_data_lifetime()) also for fs/direct-io.c.

It depends on how we want the user to specify the data lifetime for
direct I/O. This assignment is not modified by this patch series and
copies the data lifetime information from the ioprio bitfield from user
space into the bio:

		bio->bi_ioprio = dio->iocb->ki_ioprio;

> I still don't understand what happens if one uses io_uring to write
> to a file on a f2fs filesystem using buffered-io, with both
> inode->i_write_hint set using fcntl F_SET_RW_HINT, and bits belonging
> to life time hints set in the io_uring SQE (sqe->ioprio).

Is the documentation of the whint_mode mount option in patch 5/15 of this
series sufficient to answer the above question?

Thanks,

Bart.

