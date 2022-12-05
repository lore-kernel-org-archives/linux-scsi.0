Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D82C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 18:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiLESYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 13:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiLESYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 13:24:05 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55381D67
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 10:24:04 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id w37so11218449pga.5
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 10:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MiaU0h+bdhLcyz46u9rPXY7SBRUUk1LjjV2sWNv5RLY=;
        b=UBAKgIuuOhTG3tpp18QArd1BLiZIqIsmrc+4/lD5AsoySzR1qItFUrsUCuFBWW+V7W
         NN2KIHP7x2TpFYLEpDAVnAYN+9qZ+/AX/nXjLFuLwIwASDZ5TCrrY6Icl9kLCXsJnFp2
         2nI8qClHrISNzrvTysGS6mWOe77CE/lEituW6eRdhOSEvyhqLcQtgnSDhdmtwzRZq3H3
         t9gh6367wtD+fMwzVdZQHcjkEtEIZUGmsUbF+1sZ059635xeS4MW7dzCg2dwPJ9UAzdV
         UHJpkdFPOBH9kWrxNGtG9EH15d6tA7E5U5gRClOLHJ2QLOn49p6zl6y4+YgaYg17wO/n
         Dyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MiaU0h+bdhLcyz46u9rPXY7SBRUUk1LjjV2sWNv5RLY=;
        b=EH8zzYY/aLuw0tWvFGqr6MSt6P2bw1E29wSs0epqycFiICep2iEaX7fsHJ3oDD8J/M
         GnerausAVYh5ThA1KPgBcIyC2hbhkBoB+0ud75ZuWNUrQ3WONC4VNZprUWIw8TMP2XOh
         K3ivLqsCLCmRihYRk/qfP07e9Iaa82XYRUubLjvN3QQtS7X4zRLcFu9hpQJDVUleRzJ+
         wNnH+FuMh91D5e5b6RfOPg2ju4eR0T16ul3/M6piME+vN/YHrfZcjw133DyYQOH3j6F3
         OsQproVN4M+0ViFNxJFnrSdyc/5dzcAppUiOC9eWMu1z7vplOuyFThug1myl7LJFwz+z
         EPlQ==
X-Gm-Message-State: ANoB5pmB3kZGzFXnaNh1imfAYj3fDGLVdb6/OxeU2petpIuCoaPW8WUs
        KDjg7+kEqR1DvggFGJbG017XbcXAmrZc2ERF
X-Google-Smtp-Source: AA0mqf6jZL7CMm0mQFuDdI6JgmGYYwGjfVoJPowXsYQWIx6DQ5YO6ZYAjPvSltOjb7zYJtxe7LeLEA==
X-Received: by 2002:a05:6a00:2396:b0:56c:318a:f808 with SMTP id f22-20020a056a00239600b0056c318af808mr68347160pfc.11.1670264643685;
        Mon, 05 Dec 2022 10:24:03 -0800 (PST)
Received: from ?IPV6:2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a? ([2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a])
        by smtp.gmail.com with ESMTPSA id 72-20020a62154b000000b0056283e2bdbdsm4726356pfv.138.2022.12.05.10.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 10:24:03 -0800 (PST)
Message-ID: <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
Date:   Mon, 5 Dec 2022 11:24:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Content-Language: en-US
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/5/22 9:20 AM, Alvaro Karsz wrote:
> Implement the VIRTIO_BLK_F_LIFETIME feature for VirtIO block devices.
> 
> This commit introduces a new ioctl command, VBLK_LIFETIME.
> 
> VBLK_LIFETIME ioctl asks for the block device to provide lifetime
> information by sending a VIRTIO_BLK_T_GET_LIFETIME command to the device.
> 
> lifetime information fields:
> 
> - pre_eol_info: specifies the percentage of reserved blocks that are
> 		consumed.
> 		optional values following virtio spec:
> 		*) 0 - undefined.
> 		*) 1 - normal, < 80% of reserved blocks are consumed.
> 		*) 2 - warning, 80% of reserved blocks are consumed.
> 		*) 3 - urgent, 90% of reserved blocks are consumed.
> 
> - device_lifetime_est_typ_a: this field refers to wear of SLC cells and
> 			     is provided in increments of 10used, and so
> 			     on, thru to 11 meaning estimated lifetime
> 			     exceeded. All values above 11 are reserved.
> 
> - device_lifetime_est_typ_b: this field refers to wear of MLC cells and is
> 			     provided with the same semantics as
> 			     device_lifetime_est_typ_a.
> 
> The data received from the device will be sent as is to the user.
> No data check/decode is done by virtblk.

Is this based on some spec? Because it looks pretty odd to me. There
can be a pretty wide range of two/three/etc level cells with wildly
different ranges of durability. And there's really not a lot of slc
for generic devices these days, if any.

-- 
Jens Axboe


