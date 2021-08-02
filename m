Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9429FC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 14:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DAE460F51
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 14:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhHBOZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbhHBOZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 10:25:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7EBC0619CD
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 07:24:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c9so1436711wri.8
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cRjjWg/mWYijYBQxH9somoLlXnUOB5FQM1XApkQdmuU=;
        b=sQnxkI4oOKLx2yeazySxbdu45qzpcUXP3Lvl+kjwHg9qAcv7nRH6K5TX1T9v+iYB/V
         Yo2TDRvJUmS7Q5RXWE0OuOWLM7oRLUe5vDnLawxrIpP+11ElAcNaIy6sx++/wdnNa6C7
         ezsrkRv5AtI4nlWroIuUwp5Hw74PAhvsxpXgaj9ejsL9GwrDYJkqxUho8kGGnBaeSwtj
         /fYxyORjLTdRnQU9qizsFrWksHCTCBTekRYQG1otez3M/7JR1NEJliTNuhaMAn6/iIZB
         KlmKtDrOvWYVWkZjZQhEJWZDcVV/3VStSlf4+tvDliEhZxwDY48C+z15kptNcf2TZDfF
         gZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cRjjWg/mWYijYBQxH9somoLlXnUOB5FQM1XApkQdmuU=;
        b=ora5CqRLaZ8GWVKw4PSfzXLNLee0R1v7tRudIp3d5g77tvO2rGWhzJ5MJ7GDlltSLn
         SXrcLJAw+Exdu9fHRQYN2/QC7F2zS4ybSUmdJh0E6iU/kodmhgF7vQBqJjeablOcKiKt
         8HVxv6tkwztGEoQABAaEjUKMcIWdeI3HrroIp+nEUaVap3yLD+qusq2o13yBWGJI9Icn
         r35D3vWCUQ8UEXI181fUGbUDNrxLBhdN9s5kXbMSJtSaJJn51bcLi/qVM1E5vUziIXjA
         EOVj45Pnz7eahbteP6PQXvNy2PTndeQIq/QOS5HjkjcIMDJhIaE7xCEgJFWXeIr1dhxi
         4uWg==
X-Gm-Message-State: AOAM530jCiT2LncBsMtHzvjzCChZbhQlPs2oWM2uKEnNeRucTQqLVlvQ
        HDz0aY8Q+GmqQzKfeqbfe4Y=
X-Google-Smtp-Source: ABdhPJyu5gH0YwmbyPE+gc9JEcdp7+UQZZc4ijsLLwddljKO8oMXxpxkeJ/72uaJtH289MfPXMABXw==
X-Received: by 2002:adf:f081:: with SMTP id n1mr18397915wro.235.1627914262620;
        Mon, 02 Aug 2021 07:24:22 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id l5sm12983089wrc.90.2021.08.02.07.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:24:22 -0700 (PDT)
Message-ID: <29c9d9024018d05c0bc51d87187627a4d04983e0.camel@gmail.com>
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Date:   Mon, 02 Aug 2021 16:24:21 +0200
In-Reply-To: <20210722033439.26550-17-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-17-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Use the SCSI error handler instead of a custom error handling
> strategy.
> This change reduces the number of potential races in the UFS drivers
> since
> the UFS error handler and the SCSI error handler no longer run
> concurrently.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>

