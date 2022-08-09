Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D299C25B06
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiHIT0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345947AbiHIT0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:26:22 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DB29FCB;
        Tue,  9 Aug 2022 12:26:21 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id c24so7407478pgg.11;
        Tue, 09 Aug 2022 12:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+xNHl7PxIkebq0wdnJhmzor8UqQwWVZACiymdJlxbdU=;
        b=5hksvFLzpYzseZvUJ/CEVIWVnCB7G3NmLdSOPGrRUTnxeGlH81QEUPOmcI+gTxTW0n
         iWpzc6VQbpPEgekVHc3RfWgSltKuDf8t7fJDPfobPHrV0obJ8LxO+tXNVUA6BWHz/EYn
         GBhsv5ihMFUlr/9KGljSkc8qBSw7/r7zDbMbBN4V/5Mba0rOzNGtJ0bpxc80EFE7DnBs
         r5lbqSAWHuT3tIzs8wlPymrnQuGxSuSSINkLocHqxuYbzdb/inHNh0CErrrUGkkGwhwS
         OOpt2+ifJkSJFF6mrsit+rCM40WV5NDmUmURO5X7aWHjGyDfvEoaKFSQmkcoh3jRprbD
         j6GQ==
X-Gm-Message-State: ACgBeo1/VkEgdhd09rol7Mifv+ptVF0E+s7DSc+/RZwX1UpkjoY1aR2V
        Hhp2UauX3xjz23gTyzAgrMY=
X-Google-Smtp-Source: AA6agR5+riNI8OSebOu0oK1S+2g9jxFt9EqMM52CmaUet8riLT+K1RsKhbZTtmktwZP+gN3LNaDlCw==
X-Received: by 2002:a65:6d98:0:b0:41d:d9:a338 with SMTP id bc24-20020a656d98000000b0041d00d9a338mr17501281pgb.421.1660073181028;
        Tue, 09 Aug 2022 12:26:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b0016a3f9e4865sm11221917pln.148.2022.08.09.12.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:26:20 -0700 (PDT)
Message-ID: <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
Date:   Tue, 9 Aug 2022 12:26:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 04/20] scsi: Add support for block PR read
 keys/reservation.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220809000419.10674-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/22 17:04, Mike Christie wrote:
> +static int sd_pr_in_command(struct block_device *bdev, u8 sa,
> +			    unsigned char *data, int data_len)
> +{
> +	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
> +	struct scsi_device *sdev = sdkp->device;
> +	struct scsi_sense_hdr sshdr;
> +	u8 cmd[10] = { 0, };
> +	int result;

Isn't "{ }" instead of "{ 0, }" the preferred way to zero-initialize a 
data structure?

> +
> +	cmd[0] = PERSISTENT_RESERVE_IN;
> +	cmd[1] = sa;

Can the above two assignments be moved into the initializer of cmd[]?

Thanks,

Bart.
