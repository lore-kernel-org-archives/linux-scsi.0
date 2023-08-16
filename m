Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C48C25B5E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 20:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbjHPUAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346010AbjHPUAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 16:00:12 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AD62723;
        Wed, 16 Aug 2023 12:59:39 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68872cadc7cso1484091b3a.1;
        Wed, 16 Aug 2023 12:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215979; x=1692820779;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=65Mdgm4WER59to5SbeAOKm3C5GVy9HF+hlTLIfszzno=;
        b=lYTmGXpgy20qom+TUvbxZyP5AtPnSnnLc9SRCuJq0ZwzKcLB2/9AHGT6shCbAjRqSy
         pIdccHvDEbRZsXpGi2GpKJu2oM0xQ2cOUdLIE88jOX2GitLqi6Nd5HSSs87excVeGvx8
         0e+Q/FYjCstdDZ6K24U0qK1cfFJuYJWidHTDqDybCaFIbRvtwD3pfkUVzVPX2YPNpt8X
         mjXFyap2pBe5juFItV9RhFu3UGnWz1sL5fe0+usrSCv917noZ6f7cXLdWfDbxV1U/5op
         Z87W6G2cvpXY3t4ZybNTluNWueEagjaeESe6fc6KbTAbd4fka2U59jgGAolO5kYH0PKG
         gwrg==
X-Gm-Message-State: AOJu0YxxzJ1ZqI48zeobIpUm6slGI/MTHJyxdY3bSAJmgUzDpJTDSTO5
        3SWCg34WSySNc2nLmzSFhRE=
X-Google-Smtp-Source: AGHT+IG74EGF3uJEyolMnBjBwfmah4nRkxVLtCSkKXpS88/y0pMDt6EcxN7FWtuujJFiSo/Q54vIhA==
X-Received: by 2002:a05:6a00:992:b0:67e:4313:811e with SMTP id u18-20020a056a00099200b0067e4313811emr3387870pfg.0.1692215978631;
        Wed, 16 Aug 2023 12:59:38 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7141:e456:f574:7de0? ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id d12-20020aa78e4c000000b006884844dfcdsm3106548pfr.55.2023.08.16.12.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 12:59:38 -0700 (PDT)
Message-ID: <07a5ecbc-7b56-676f-2615-361319a302dc@acm.org>
Date:   Wed, 16 Aug 2023 12:59:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 5/9] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-6-bvanassche@acm.org>
 <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
 <3161926c-b1cb-9617-bf71-73b8711e86de@acm.org>
 <2b73497c-0c0c-6eeb-91ca-000884a9898c@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2b73497c-0c0c-6eeb-91ca-000884a9898c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/23 18:13, Damien Le Moal wrote:
> I still think that added the test for use_zone_write_lock in
> blk_req_needs_zone_write_lock() is needed though, for consistency of all
> functions related to zone locking.

This has been implemented in v9 of this patch series. v9 has just been 
posted.

Thanks,

Bart.
