Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7FEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiCIEkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCIEkg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:40:36 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628455BD22;
        Tue,  8 Mar 2022 20:39:37 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id z16so1234910pfh.3;
        Tue, 08 Mar 2022 20:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pMLNJB/4468ZsqY5DnERYcm+/wqS41bas/FdTHPTMJs=;
        b=CF+l6+iRIqxI/4QimRAEpEIAhvbGyc8/JXjXc8pHw2x4mSm50DEgjGH5ehKa5xFg3w
         0Ed+o9fRVsmSI3OY9LsuIVS7nAbowqlLNbY4arqZ2wfspqUtIDeSnO8SYbMrm8D3xjY7
         PPLuyFhVb+0glWXsJRmXOvBHOMPl204L5eTG9TrMZd3FDnSVcDflnW55VckiuXhKDI3m
         ehncUnOtkHo3DmuVBmWYEcV8ow9UKmx6HgOee0otY1Rf6tDl12CgSwq5Y8Oa5pCWga9j
         CteTy/vEAW9RPS+8PoWNL8DQcLDrG1RYizqTFhp+dOdlaznv+vNYD+b3P+n/IPCVBdU0
         2gKA==
X-Gm-Message-State: AOAM5302xGPxUCwQKEp2O2QoETGOLtab6lHpszBOM1dpN0u74AhcljMO
        gqwGcAnYcig4b/b/Rts407w=
X-Google-Smtp-Source: ABdhPJxlZhoUaEEgF2z6Dpe8w+Fzu5UxmXHXaPSWFMMu6Dt0gLcvS65D4K/Y6PcduBi0N7liTyYNRw==
X-Received: by 2002:a05:6a00:2168:b0:4f6:eb64:71dd with SMTP id r8-20020a056a00216800b004f6eb6471ddmr17960799pff.40.1646800776704;
        Tue, 08 Mar 2022 20:39:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004f6ff260c9dsm799985pfk.154.2022.03.08.20.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 20:39:36 -0800 (PST)
Message-ID: <809e3df8-60e7-131c-955f-c72ae6ededa8@acm.org>
Date:   Tue, 8 Mar 2022 20:39:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 07/14] sd: implement ->free_disk to simplify refcounting
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220308055200.735835-1-hch@lst.de>
 <20220308055200.735835-8-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220308055200.735835-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 21:51, Christoph Hellwig wrote:
> Implement the ->free_disk method to to put struct scsi_disk when the last
> gendisk reference count goes away.  This removes the need to clear
> ->private_data and thus freeze the queue on unbind.

Nice work!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
