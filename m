Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91ACC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 16:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C7161B95
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 16:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhKOQEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 11:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhKOQEH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 11:04:07 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E4BC061570
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 08:01:08 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id y196so14395762wmc.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 08:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=97DjxfNBTnBivNmR0TiqJIAkj3u8N/LwjWPjt8GnWlE=;
        b=nE5K4HGVQUdPsQ5OLCVMiCUReOY3gcNjTCmgCv/o6B4s1hZEVkm2ku8tw/JvNAEh8m
         LFFh71fEqDuOEMWShLtlKa48w4l9yab5ladI4+ZJ09XTBTEzpP1Y75TcOeL42uyZN8Zh
         y0UmA4YwhKMGWVblzNwIsc9GPOXIAURpHdKNJGY5skabxFaseajBu63TPOwI8iquFK6C
         BKYs99n8Hy7nuRy5hzZNh26KE2MMpcnwAajtsf2yLn1KGPwWBYo8O+LR4gMHOCgzTMwN
         5xJcDXMm73Rdld6dtEOfSz4rA5VWa7ZTwIp5+vPnV/QaD15CDHIyEpjXxvpNtg3PSX7V
         yWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=97DjxfNBTnBivNmR0TiqJIAkj3u8N/LwjWPjt8GnWlE=;
        b=EKl2n77rwwjUudc9Pv8Ij4StpetK+hr4djT+xw5MHxPuFYoiBaHTmq29aTCygg/fRZ
         4EA4Q0SVmEFLVS6W0aOtZTN5C02SQmdeIuJWv/OwMsdME3aGQacge4UwWklpPe9VPhRQ
         nBExIJWtLwK5KMQ8albMrVQ5j36HQlVBPNepFggiQSCxuTzP5deA+VivDB8TrM+qqDfd
         mLMliVcbO69aDTcs7g4MWC5urwOsigmwPDMVZ9DxelTZhCPv7I5v9x/1E+C9Kj3n9NU3
         Cr+/9KQvUkNa8I3NcTSCNQyiiIb6pRlzoV34A5ND7bb367wNTHDdYlIrRU8cY9rmoqqG
         cBJQ==
X-Gm-Message-State: AOAM532ywBAxuLJ7uPAVKlILc/gEL5ZCC6Lgqr1SEyGadPrNb24zbpRW
        dnnMKrkw73Zug9ygKSjNwO4=
X-Google-Smtp-Source: ABdhPJwM4rNXVgxQIW81huy4rW6c91zoAc/BzcvW1qJsgrydKJP8c13gdMvQcvvroTWp3HoHBpXopg==
X-Received: by 2002:a05:600c:4793:: with SMTP id k19mr62863476wmo.72.1636992067304;
        Mon, 15 Nov 2021 08:01:07 -0800 (PST)
Received: from p200300e94719c9aa08ae94a3b71b78ed.dip0.t-ipconnect.de (p200300e94719c9aa08ae94a3b71b78ed.dip0.t-ipconnect.de. [2003:e9:4719:c9aa:8ae:94a3:b71b:78ed])
        by smtp.googlemail.com with ESMTPSA id a12sm14631202wrm.62.2021.11.15.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:01:07 -0800 (PST)
Message-ID: <7bb965c714115deb612c25726235cd0c14b21ec9.camel@gmail.com>
Subject: Re: [PATCH 04/11] scsi: ufs: Remove dead code
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Mon, 15 Nov 2021 17:01:06 +0100
In-Reply-To: <20211110004440.3389311-5-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
         <20211110004440.3389311-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-09 at 16:44 -0800, Bart Van Assche wrote:
> Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating
> tag
> 
> conflicts") guarantees that 'tag' is not in use by any SCSI command.
> 
> Remove the check that returns early if a conflict occurs.
> 
> 
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Ignore my previous email.

Reviewed-by: Bean Huo <beanhuo@micron.com>

