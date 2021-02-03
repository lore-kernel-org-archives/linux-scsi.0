Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1FCC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA4C64F68
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhBCI0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhBCI0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:26:43 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE577C061573;
        Wed,  3 Feb 2021 00:26:02 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id df22so9871496edb.1;
        Wed, 03 Feb 2021 00:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkUQDZpVbfxnFaN4l3OLU7yirmVfzAanKG3Z2wgHBvM=;
        b=JSGTtH/wxc9WGsK/YVkO/k4JJjnjhrlSVktaCaqdAVr8ElAh72G9ONhEuK59CMAPEf
         E+UTUTsO5DT5lKdYcjLITsj8k5i/9vXXXJ88wEb9mN/sBCs1RjCKNUBryxmRTD3ZbcST
         B6zwow5S5KeyXL19nUYJckTTTjBH+WW/PM7nXetBYHwS7zyZ1IIYDOnFLq6388vzqyq1
         0fB3BKm4VZ4yOde7yVqe/kiMpAavE5stpVcWrrnGflvFQJFaXh+1sQe00J5L1mUNJaRy
         XGoJZhvF0Og4smvHqjdGSO5xthxXPFQoQAmmkSuS7/u3u9tI31hwuCeDTRpPZp9B/iZR
         VorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkUQDZpVbfxnFaN4l3OLU7yirmVfzAanKG3Z2wgHBvM=;
        b=t4y9+Td9RP53fXbbQJNqIjksW7b1gefkcrUMWy/jWqWrdCKD/7qi4z5k3JvCvzMdE1
         0CNIv8SnMwroZmNgYM0FsmieNfnXe39PgyXCLHhdb47YgP0TaAGnhsnPXlZEUxnJrrrv
         zG/ShRqyyOuEUcDPbMbDlWACiw2XFg2aMshI9NLTe5dpvLlqy7eAcXWkB3tgItVFYsl3
         bC43t7y2mU4qCWa8huOVrcSkWw4hYrwg6+T4XODMTfT06wZargXsrayAC/6ApxFx47Tn
         mofmeD+2bo1T2BNqzgPd0pYXRvpo40TdvEyB8l8IVONNZ9uD7TOp1vj+gAO16qkNUMBu
         0IBg==
X-Gm-Message-State: AOAM530n/cBVgB+ZS9EstZq4qLTw92qoBkANnQHu/q6jzj+Yx7b6uAXI
        3n01FNB+2jKiz9zdciEL4Rs=
X-Google-Smtp-Source: ABdhPJxGs8xk305nQ3+LiTJBqzpao0500W0opVAcOtfcT4PANfeF33k7xAzFavCP2fJptcJnjS7eSw==
X-Received: by 2002:a05:6402:4ce:: with SMTP id n14mr1806580edw.309.1612340761618;
        Wed, 03 Feb 2021 00:26:01 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id k3sm633363ejv.121.2021.02.03.00.26.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 00:26:01 -0800 (PST)
Message-ID: <4d160868dbe924e3109ce7f74c478a83f2a42502.camel@gmail.com>
Subject: Re: [PATCH 2/4] scsi: ufs: Add exception event definitions
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 03 Feb 2021 09:25:59 +0100
In-Reply-To: <20210119141542.3808-3-adrian.hunter@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
         <20210119141542.3808-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 16:15 +0200, Adrian Hunter wrote:
> For readability and completeness, add exception event definitions.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

