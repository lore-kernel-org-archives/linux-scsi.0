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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F5EC43214
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79CCC60FC4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhHBPDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhHBPDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 11:03:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C07C061760
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 08:03:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l18so21838566wrv.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 08:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WE9RZ8EViqOruvmvmQaOesEa5Oj7ey8baiG8B/DxXE4=;
        b=vhzXiLkLzhicx/HszJAMvTXZjeNFM1steK+OtufjWhjF4l30zQL5cVcTF4XgkoShIn
         /46S6Omsn7YSeJjB6F99z0UaPCzEHVcWI043zPA7uYFslKq5OK/X6FY+ECftkG8Tr7w+
         jGdDzqJeNvzw4XYGAjF7UuO2GhRazNmQZ5I9iQvLxTnJC4uQ7MR/MZeLfZLLNuhl2z9m
         ByR215XwWQSzjxf6d+qYWGlUuSpuJH4CXJlPXseEJqvMxp7QFAnShCC3GPkVS3uBeCaR
         Ay+hcbnYoOhbOPCZAPLG7ELVbaMIeE5EYAs9Xfjp/wob4N13O7bxO7SfTolXC1988EZq
         6VvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WE9RZ8EViqOruvmvmQaOesEa5Oj7ey8baiG8B/DxXE4=;
        b=i9Ca0IdcIxEg8/0vP0uYK9GgPIXBdKJVX/MKkYnkE2ExhRPVO25SY7b/tDaS8nKDXv
         rx0SHUm/tkDW/9LsJ/2oMPFWNvppzi7wHkTZPZLivWIptlrukE8OJSuhvLIPpG38j2nL
         lC2NxQgFBt4eQhekLHtP8rcdc0OusYyRK1Zv3vmEuDOLY5Qa38RWBbyc7Va+7Mwbefqk
         BzxPCUSW8UJWD0pKXqfgL0su70Gswksz5eoznf9aVmSHZwEtyrlxVp5xMkvyhZopJZLh
         Ln94CN9f0R9jBtX2ewnhAYko7QD4e9P5eB+VhzMg3i0z5FurPKMLCXmXYkTN82RqNwrJ
         ypbQ==
X-Gm-Message-State: AOAM533GJ+RzsxHtMH9xgeZFUzPjbTJb84O/8ZND1R9sqPnmzeBDSXJY
        nKFw5pJcaj+ouGUxRjMTHmY=
X-Google-Smtp-Source: ABdhPJwkAaISo5DYLP/oj0Z/M3PW23Sdc8ah6ZY3Xf42QnRoN7nE9GrfVJZCKxC/NmKB1Nglr1AaNA==
X-Received: by 2002:adf:fe44:: with SMTP id m4mr10375469wrs.133.1627916589654;
        Mon, 02 Aug 2021 08:03:09 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id b20sm8719509wmj.48.2021.08.02.08.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:03:09 -0700 (PDT)
Message-ID: <5522bfc504d0bae76830ccbc479a6e6d5e3c586b.camel@gmail.com>
Subject: Re: [PATCH v3 17/18] scsi: ufs: Retry aborted SCSI commands instead
 of completing these successfully
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
        Bean Huo <beanhuo@micron.com>
Date:   Mon, 02 Aug 2021 17:03:08 +0200
In-Reply-To: <20210722033439.26550-18-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-18-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Neither SAM nor the UFS standard require that the UFS controller
> fills in
> 
> the completion status of commands that have been aborted (LUN RESET
> aborts
> 
> pending commands). Hence do not rely on the completion status
> provided by
> 
> the UFS controller for aborted commands but instead ask the SCSI core
> to
> 
> retry SCSI commands that have been aborted.
> 
> 
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Cc: Can Guo <cang@codeaurora.org>
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> 
> Cc: Avri Altman <avri.altman@wdc.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> ---

Reviewed-by: Bean Huo <beanhuo@micron.com>

