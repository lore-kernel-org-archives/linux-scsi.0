Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A5FC77B7A
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 20:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbjFFUd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 16:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbjFFUd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 16:33:57 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9507B1A7;
        Tue,  6 Jun 2023 13:33:56 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-256931ec244so5687966a91.3;
        Tue, 06 Jun 2023 13:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686083636; x=1688675636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MgJp+orwk1NKxueTZD2IplILXAWARVtQ9HQ4gN8T56w=;
        b=UeLbdlSvBGqlOFJlTSI3vhBZ93+qSLbefLqPhyy4PrZreXgcMrF3KvaYwWekrBOnN9
         Oq9CsEdImWHqlOQekGdbffRPY8I8U9BEJzyNH8O6G8MSdLA7yCFC388B4baBin4QUNDK
         C41lFfJtroAJYiuwxrydnnceBwDZCOdX3JHOouEznCtkAM1SrMMxcJSUZ6pBwifBIw0u
         JeFTNYwRKfRDhdfZ2qRF6Cet9FySP2gFyLy+93Sf3sYuGq4NZSFD+GYCe6Qr3RDqIuk8
         ZzEEm1hoFhWYJpyFbMeGpTw6omN4Gget2qzhxZIOMSUKqCiDQ3zOHy0uHM0h14rRiJEB
         Vvwg==
X-Gm-Message-State: AC+VfDz9xb1OvrvepG6YscwHM1APuYlzWonkNjTzBo93p3HhcMRk+jiu
        8zyLgpKnfGNiqux/QwBNMhM=
X-Google-Smtp-Source: ACHHUZ54ZXhppPBlZio1a0xCAdGhS7743bczBArw4DhbAmwgKbH4ZpB5w23QwGVm1a0qzsRA08VCUg==
X-Received: by 2002:a17:902:f683:b0:1af:b92d:b5fe with SMTP id l3-20020a170902f68300b001afb92db5femr4114616plg.0.1686083635869;
        Tue, 06 Jun 2023 13:33:55 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902bd9000b001a64011899asm8899148pls.25.2023.06.06.13.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 13:33:55 -0700 (PDT)
Message-ID: <3c9414d7-fd6d-f6fd-31c0-16fadb5bb574@acm.org>
Date:   Tue, 6 Jun 2023 13:33:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/3] scsi: fixes for targets with many LUNs
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230606193845.9627-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230606193845.9627-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/6/23 12:38, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This patch series addresses some issues we saw in a test setup
> with a large number of SCSI LUNs. The first two patches simply
> increase the number of available sg and bsg devices. The last one
> fixes an large delay we encountered between blocking a Fibre Channel
> remote port and the dev_loss_tmo.
> 
> Changes v1 -> v2:
>   - call blk_mq_wait_quiesce_done() from scsi_target_block() to
>     cover the case where BLK_MQ_F_BLOCKING is set (Bart van Assche)

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
