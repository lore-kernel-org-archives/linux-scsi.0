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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11854C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0CB611CA
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhEaHQJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 03:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhEaHQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 03:16:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3143DC061574;
        Mon, 31 May 2021 00:14:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j10so12277885edw.8;
        Mon, 31 May 2021 00:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4alPr4aCYdFYOJLKUzVCw2klrG4dXqnW+51h2XwmbBo=;
        b=GTSdOCEAwZD/eEtGeREenY8E/QdMdMkE/USpAiE5DpzC6cktk+CaczsBknNhztswGh
         ylVcN5KPv4UWKU0c/7y7gcKqtg7a5gaKq8QglXFnlqEmbggH3SaDxHymydy78UecYCDb
         ON7/Vx8NGRFJEjZXxuL99WtpSfcxOug4BKTrAGAWP09emsMQUEEbqw/oNL5FA6IchSmR
         yO+xFSVzVYLjQ5pwoqwvzN5sQJuQkeEmwDdnlAW4WJ0d9aM5+Wj6gKVtK/pP83Snd+L6
         cr+h4FCLckjgCxmC0vb+GBkvcBHSIJIRiP49IB5l682FV0kPoIv1ffdXpG7O/gg/2I6P
         cHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4alPr4aCYdFYOJLKUzVCw2klrG4dXqnW+51h2XwmbBo=;
        b=Lh8RjbaSBbpD09I7N4vKuJBx0Tx60/NGRTM6YFTxwWm6Q8BAnLbuk8GE7zyYDWIrEh
         EqOK1WFzZ50YCozosFJCWgKtjeJQ7S2j48FJRPolV6z+iVx2jJZLX3hubMC0r1azFSFw
         2N6W22JIbpJWe7gwzxTfKcaaXRznDDUMGkcdh0Ta8MRFP21wxTlKNnAlM9vlrg/+d/TS
         xCpkjAXG8erl+vd9Dpv8or0KKmJNsYSW8vcaEx2Po03h7hcFNqFYT+a0AX9auK5+XSzw
         h+allMHSjgeBxyrFJr/jt3M3zMn/7kxb091GhhJo+eGc0eVNJAo6s9zfSGeO+6tpVt+N
         AQoQ==
X-Gm-Message-State: AOAM5317CPQi6siodgcK/p0S/eWevKfefotpfkhHm88ggp+Ji4moOdLW
        JWyGDX34KNvOkJab3G4nvK8=
X-Google-Smtp-Source: ABdhPJy+XQYjbO6F2NZGzw4FxMGef2/V+VXJ+gT+G04SVk6UPcikixpZv45ut3Wz8nk4Ra4HFRigZw==
X-Received: by 2002:aa7:d6cc:: with SMTP id x12mr107265edr.55.1622445266838;
        Mon, 31 May 2021 00:14:26 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id n15sm2161065ejz.36.2021.05.31.00.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:14:26 -0700 (PDT)
Message-ID: <b0307fa0b5a0f27149a7b7e480088f1a5c67719e.camel@gmail.com>
Subject: Re: [PATCH v1 1/3] scsi: ufs: Remove a redundant command completion
 logic in error handler
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 31 May 2021 09:14:25 +0200
In-Reply-To: <1621845419-14194-2-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-05-24 at 01:36 -0700, Can Guo wrote:
> ufshcd_host_reset_and_restore() anyways completes all pending
> requests
> 
> before starts re-probing, so there is no need to complete the command
> on
> 
> the highest bit in tr_doorbell in advance.
> 
> 
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>

Looks good to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>

