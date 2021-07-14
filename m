Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F493C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEBF611C0
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhGNSMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:12:15 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39757 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhGNSMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:12:15 -0400
Received: by mail-pg1-f179.google.com with SMTP id a2so3319630pgi.6;
        Wed, 14 Jul 2021 11:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LIzD3a4Y0Ejr+434x3kFvkLLT9Fc2hxKYkwrbGXVjSY=;
        b=enqIO1V/DfyIEJFQR86o+piWXwL4Ut323CcN7t9BSZkB4QtHUPQipbrILyqSCZbPO6
         fkE3apmIc7rzYSEwglk6hhdtsaYUEqNWaxYZ+rNBRn71oViLc+ZSz5Uj4T4rxhHhb0uK
         tzb3/tK2XoXMaDfdSJXJrgr1uFfcwYNI8uemM8mWn9VOPxuR8Oe2uHQ0E5H/alirItnL
         qiB40yr/EHlkLgb9YRmnqENXS7hBHEel79UMpTbnoxCtmP+JIHa0D26dCS1kMc01RuBB
         Ar9Zosq0eYNYfE7fOUIz9Tf1NmuFZyvcnUpaUUF/G6M+K9u3Mki58FdkhpXcX2lZdKM5
         Ossg==
X-Gm-Message-State: AOAM5322m2GsCN0EgVvYe+NXGa81o5D9mQkymxBNNmGc1hsEKl3ltDLp
        Ja/NKctCvKALJ73AAGHkUMk=
X-Google-Smtp-Source: ABdhPJx9teTmAtYN19Yd/nQG8C6ZbdsPelnS5mxH8YBC7VR+v8bydqlC8BZSICOe/VSBsiH69KOoAw==
X-Received: by 2002:a63:e26:: with SMTP id d38mr5923790pgl.42.1626286163206;
        Wed, 14 Jul 2021 11:09:23 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:91cc:a7b9:6739:15bc? ([2620:0:1000:2004:91cc:a7b9:6739:15bc])
        by smtp.gmail.com with ESMTPSA id q17sm2787438pjd.42.2021.07.14.11.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 11:09:22 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
To:     Bean Huo <huobean@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
 <38432018-e8bf-f9f3-00bf-cd4b81c95c88@acm.org>
 <69b367bc44084f901d0d71fb8f9633ea7e5df36b.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b0cd26d0-6ebc-b633-8669-a558597cc91d@acm.org>
Date:   Wed, 14 Jul 2021 11:09:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <69b367bc44084f901d0d71fb8f9633ea7e5df36b.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 12:45 PM, Bean Huo wrote:
> This change only impacts on the Samsung exynos platform. and Can's
> optimization patch is to optimise the host_lock,, and removed
> host_lock, now add back in this function makes sense to me.
> but I am thinking how about hba->host_sem?

Hi Bean,

Calls of exynos_ufs_specify_nexus_t_xfer_req() must be serialized, hence 
Jaegeuks' patch. This function is called from the I/O submission path so 
performance matters. My understanding is that spinlocks have less 
overhead than semaphores. Hence the choice for a spinlock.

Thanks,

Bart.
