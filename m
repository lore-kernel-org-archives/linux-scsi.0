Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608BEC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbjFLSDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjFLSDq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:03:46 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FDFE64;
        Mon, 12 Jun 2023 11:03:45 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-665a18f5643so627524b3a.0;
        Mon, 12 Jun 2023 11:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686593025; x=1689185025;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7Hvd/j6ap38R3OUkFPIU5qPYCVnDh30Uj4FqSHhAg8=;
        b=AGW2iFiFqcjeuUQbJJmgM06Skbv0h3PjU1Q9j/KcW6JNNUykbsNPSFKU9A0RKjqpaO
         LDeYdv9IhuH4EFGfHSsdFZmQODLTt8mWBD3mKUlwyrCc1smxi1pRgNpUKY6l9feNvedo
         rtgVXKDbnJ307kd4IIaui2OqKMGNUCzJlsoigsrWivJgkqXO2geM4gMiSFk+oiJ8yA5W
         Vo/Y8FRbrvC0B4cqH/rHYhi08bvjs5oZbt7bnHW+v/eUbOSbFz/bX/6mASLStnyTGxZQ
         NErnptc19P2EmDY06IJr7AIk8Bdk10j/avLGYVtd5Cjowj5E5opDAujXENgRzelVGMPl
         VGRQ==
X-Gm-Message-State: AC+VfDxHy+Q1ezuEPTABBhyyemz7OVkwtxi+wzHFGt/QBgpn4EL15HE5
        W6N5NNbN3jL3AGygAEi3Mpo=
X-Google-Smtp-Source: ACHHUZ5Qf2y+y/rWwdMvqX22rUG+i9BqGp6US4HBPAI2o7XXUCbTO8zxubyx4qFDFvE1KLeZdSltIg==
X-Received: by 2002:a05:6a20:748c:b0:110:b7fb:2c92 with SMTP id p12-20020a056a20748c00b00110b7fb2c92mr11477228pzd.11.1686593024316;
        Mon, 12 Jun 2023 11:03:44 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id fe15-20020a056a002f0f00b0065055ad5754sm7188819pfb.64.2023.06.12.11.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:03:43 -0700 (PDT)
Message-ID: <7c8d74e6-dc28-8441-242c-1ea0135c31c9@acm.org>
Date:   Mon, 12 Jun 2023 11:03:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 5/7] scsi: don't wait for quiesce in
 scsi_device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-6-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612165049.29440-6-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 09:50, mwilck@suse.com wrote:
> scsi_device_block() is only called from scsi_target_block(), which
> calls it repeatedly for every child device. For targets with many devices,
> waiting for every queue to quiesce may cause a substantial delay
> (we measured more than 100s delay for blocking a FC rport with 2048 LUNs).
> 
> Just call blk_mq_wait_quiesce_done() once from scsi_target_block() after
> stopping all queues.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
