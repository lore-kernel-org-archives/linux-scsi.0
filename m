Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82BCC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 17:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDEA260FBF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 17:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhHQRhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 13:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhHQRhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 13:37:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F671C061764
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 10:36:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bo18so325446pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 10:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TeRaJER16oAValHzJCwzMcfjYBsSJhIdIhqlazTmkEU=;
        b=EcjuP5druQJZpYZLSsYW10u3vVKioEP+qLKNZPle9JHcSJSbuaqSeR5S4tIID+APqY
         sZtKdPVhheZNNuiI42v/RGfcW+tnP+C4y8RHvTV4jIEi8OAZat05n9+bXoSlGULZ1ZYU
         n3frWi+DAGrOrgMzpRFcokuOsmjM98uD38xK9hRxQP34mmXMJcxbMXkvPeuATBgJ+B7b
         7D88Fa00kJUcdA+TBwcoJ0j5V8CI17hmPIieKB+a4ZSIEC+FPnAjHS9FzPkMfm35vnTz
         iMrWmVrdzJBFaigGUQNA2MNSYlnEhlvibWdYTBdVRDYtD1ica4QKnwKm5jzeVebMbMqk
         X74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TeRaJER16oAValHzJCwzMcfjYBsSJhIdIhqlazTmkEU=;
        b=LyRGWN7xqzR5ALGJD0lrDrTWWgh3jWq2XoIH6wXrN/N4e7WsGhxtysUNmcABCju+dx
         INnZ8O1g8gjXIqnyVNJQbTBVKE5Y4SF4mt5VjJHDBMzyLyOD7Qa9gLOsjRj/6lUUQUng
         h0tz15wOqzsq4RXt6TqrwM4JdrkTRtgbrtGY+TbtqfwAz0ysvwaABqRoLaQFuB49zNWL
         FYFEilut5yE0OgHbZZakTLYXhHsfznSzo6vTMvDwbNeqLdwJWPkBvkxQS9m0ibtypc6g
         WtnTANOUuFjW828TRyJWxOJMA0hmm+kRuE9FxsJBLYr5Ma7yRorDAtR+hnLjn7gbpGc4
         cR4w==
X-Gm-Message-State: AOAM5302wm2WQ3/FPU22vid5H6ZWu1yU0dVg1hGAiAPTfeBwcDZ6IjD3
        SWzPEPuaTqpIw77dfQbGFrE=
X-Google-Smtp-Source: ABdhPJy/hzhDAVf6ibw/RmfE1If+fJJJe5Qqkzb3ADWH1S8GUve089tqRxTyDjSf1gs5dntEu2LTrA==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr4841736pjb.210.1629221790454;
        Tue, 17 Aug 2021 10:36:30 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 31sm3991270pgy.26.2021.08.17.10.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 10:36:30 -0700 (PDT)
Subject: Re: [PATCH 02/51] lpfc: drop lpfc_no_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-3-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <aecc4964-d14f-6ea3-3eb9-7a2700c358a9@gmail.com>
Date:   Tue, 17 Aug 2021 10:36:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> The default SCSI EH action for a non-existing EH callback is to
> return FAILED, so having a callback just returning FAILED is pointless.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 10 ----------
>   1 file changed, 10 deletions(-)
> 

Looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
