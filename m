Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737ECC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 16:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E66C206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 16:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732183AbhAUQQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 11:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732040AbhAUQQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 11:16:18 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB560C061756;
        Thu, 21 Jan 2021 08:15:37 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so3422773ejc.1;
        Thu, 21 Jan 2021 08:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l5RECMC/UZiLa9CjXR39r8x2ssvcHHs78h5TJlU06LQ=;
        b=BficDcR+oe8bQAmTHSDQoDle1d8W2bEMWN6b/69rK5ZsV51D3sAauEztEVQoQYw4XP
         ExVaI16sp18UvwTht1H6GFNF5YortjsdH3rfDCFdGeJ8eUWo3h08lDgHlWyNEAHe7cbC
         Uz1KDBzSRohwcpKvZFyqP73mBaA0BA3BrCyFK1sv7vifVDHTSuf9zRjoQFC7X9BfsPrx
         PWzQGQPZmTWk10lVBC18aSeeJ+/mazmqmHXQ48lBuyZ5c/JwWYbTfDwKrYdUu6mvVi1F
         ALLREr2+lnuvMnKdlOsciO0q3a+7CgOgfHQmG7QJlj8BU8gJPZrmJxwT2riYddkUhNpJ
         4csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l5RECMC/UZiLa9CjXR39r8x2ssvcHHs78h5TJlU06LQ=;
        b=PXpN7+Ad0dBaB2CrbdiU4vCptYEt186+56ndmSN9Mpy/mlWCgOFuR338f6DUeYPC0p
         zL5yNt06tawLW1e8uETsC0z28dM27Kitz3VwQkugkxOguWc+vb1VShvIEpWhqDCMPCA+
         UN1Cn6/BW3wJw1a3G8N7n9W79duiR4MF+lhyY8Hv9JDtXL6jhaUHONVtJEb9zm6p2ULd
         PQIVYPF11fa4HaHx5gIIrZTL2vDWmcshleJ0wWkoh1NcCj//5osrZLdqrpJhOQYdd+4F
         wLl4an5BbULsHMTTk1edQGWmw951yiyU7b0bYuwix7CRwkZ2O5DmEJ62reiW0lESXgD1
         qNQg==
X-Gm-Message-State: AOAM53361yQm+C7g/WS/q9LreGvbAJsxJmnKdYd3IXxPDWXtgLtbW5GK
        ElrV9JjnXLN1vN4jUqYXwSo=
X-Google-Smtp-Source: ABdhPJxOjMAb78L405u1aCIm/2XrgwQPxT5WMpvhSefgJo6zY5WPweEkO4xvnjz3zPNxxtSoyGnLnw==
X-Received: by 2002:a17:906:690:: with SMTP id u16mr168733ejb.186.1611245736490;
        Thu, 21 Jan 2021 08:15:36 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id w17sm2382919ejk.124.2021.01.21.08.15.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Jan 2021 08:15:36 -0800 (PST)
Message-ID: <151f95faf537717ec480d9a256ba2d62b2c9aa44.camel@gmail.com>
Subject: Re: [PATCH v7 0/6] Several changes for UFS WriteBooster
From:   Bean Huo <huobean@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        stanley.chu@mediatek.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 21 Jan 2021 17:15:33 +0100
In-Reply-To: <yq14kjbgey8.fsf@ca-mkp.ca.oracle.com>
References: <20210119163847.20165-1-huobean@gmail.com>
         <yq14kjbgey8.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-20 at 22:15 -0500, Martin K. Petersen wrote:
> Bean,
> 
> > Bean Huo (6):
> >    scsi: ufs: Add "wb_on" sysfs node to control WB on/off
> >    docs: ABI: Add wb_on documentation for new entry wb_on
> >    scsi: ufs: Changes comment in the function ufshcd_wb_probe()
> >    scsi: ufs: Remove two WB related fields from struct ufs_dev_info
> >    scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
> >    scsi: ufs: Cleanup WB buffer flush toggle implementation
> 
> Applied patches 1-5 to 5.12/scsi-staging. Patch 6 didn't apply,
> please
> resubmit.
> 
> Also, I had to fix up your sysfs ABI documentation indentation.

Martin,
thanks.  I will update patch 6 later.

Thanks,
Bean

