Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A5CC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B31206DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="veJO5soM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgHNJwk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNJwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 05:52:39 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1331C061383;
        Fri, 14 Aug 2020 02:52:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id jp10so9318964ejb.0;
        Fri, 14 Aug 2020 02:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q89Nhvzqh9ouigzKas+ORgHK2MsQFLb+FCxJtzugDlU=;
        b=veJO5soMj6SyqX2k+JA4jUhOsWHXHPvgXjVPKS/VAsiR2zK5g9v4YY6gPYX7FEccOh
         eTxArXcOnpMjdCR2Oq6M6Er29q7PGD9/P744wJKWH/48CdQ/UiaxAvmtLYCVvjzdnqTm
         og20kHAwBQ9Y4nFpuWPBfNI7wENfrOdDlWMORLqo29DEXGHJXi+f2OZNXheuiMz/lChO
         xbnMbBQAJKlw4lPjggeTsz7SVXOpyiNZUKLqlKiREcwk0l/2bfLBxuQuMOFGgeG9aJvo
         8KAGrxtcjMYlENeak6N4CeN9SasZTDlnLPyX5b8YIdg2a+c662f92yEoMFrhXnmXu6+e
         7OpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q89Nhvzqh9ouigzKas+ORgHK2MsQFLb+FCxJtzugDlU=;
        b=lWH/QkelQ0EEB/wyBUGYto3GK7SZVH48IHqzW3L9pGpflyJvaugrx+rVffffjzMvwp
         igm71qzUGJyAIoX4c+jsG7D5bscCxvsHAJjfglf2w8abQRVzrw7wWB4Ri5vcfdwE57cj
         K7CC9BchLiaTamGADrsxPXjHSL6OSSChg1SXysjfBZ8sfT3uFqB7LH3XeW6lkfE/Zi/v
         wfcWJaLeSC/yWKapVPb33HgLntzQQlz4lRncIvsIrWqbHDDlFF6RhWcBooM4HHOPFNhp
         QE13YKFDXEPBlTMsaWwnD3yBMK1rv5nVk+d1zFboVjVXgFGwMgPO+7YnOdfBY0/5OK2x
         LHHA==
X-Gm-Message-State: AOAM533TpBiy8FVZcPRfI13uCbwkYySulTF8NKwQb4vtqSCv68zOrICL
        Gen8qVTviDmz63NCjHND2ZE=
X-Google-Smtp-Source: ABdhPJyhvkaeaFxAv8DJIq/UyPMsA/RO6Ve1cXYNtNWX+7rNPZR8MpAQw79nF/u6aCLePqFv0/AJTQ==
X-Received: by 2002:a17:906:9609:: with SMTP id s9mr1578598ejx.232.1597398757694;
        Fri, 14 Aug 2020 02:52:37 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:8980:3d37:44c:d55b:5f94:2fc4])
        by smtp.googlemail.com with ESMTPSA id c20sm5874702edy.40.2020.08.14.02.52.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Aug 2020 02:52:37 -0700 (PDT)
Message-ID: <5ba762dc8d3879e49b1636413cba795f60ea696a.camel@gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: remove several redundant goto
 statements
From:   Bean Huo <huobean@gmail.com>
To:     Asutosh Das <asutoshd@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 14 Aug 2020 11:52:29 +0200
In-Reply-To: <20200813155203.GA25655@asutoshd-linux1.qualcomm.com>
References: <20200812143704.30245-1-huobean@gmail.com>
         <20200812143704.30245-3-huobean@gmail.com>
         <20200813155203.GA25655@asutoshd-linux1.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-13 at 08:52 -0700, Asutosh Das wrote:
> > @@ -8036,7 +8021,6 @@ static int ufshcd_set_dev_pwr_mode(struct
> > ufs_hba *hba,
> >        }
> > 
> >        cmd[4] = pwr_mode << 4;
> > -
> 
> Change LGTM;
> Nit-pick, line removed here by mistake, perhaps?

Hi Asutosh
thanks for your review. I add that empty line back, you can check.

thanks,
Bean

