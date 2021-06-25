Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7CFC2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 10:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04E8D61444
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 10:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhFYKj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbhFYKjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 06:39:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B09C061574
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:37:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id o11so1219383ejd.4
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ViTlD3TI/mu/ExFAhfb+I3j+O7BQEDA/3ZqLbbAaPzo=;
        b=cKxiFLvAsdfpuVf86x46K8mmZDky+Ui9cWKBzlythCA7UPIeBOhzebBEVdCB+6j0/w
         tSX65YP3OqKULu5ERRfT2q4h65YUxgfQp9M5BiQxJVOyZU570Ja9VJxXQj0SjW7jdizi
         yajglJpd387F0wrflbWKr0tjSwZmpKHyLSsZd/r73qdJuyl7Cg1iLl1G+ShE3sxBUbmi
         h/J+14MOnCybrQUNh3uMIq+Swgi8FS4qnUsXsxI7kS5/hhd7BxxNS3oHBIF34qOYrmPi
         k0cph5LZ64ct+mFmg108Q0aVmFc7gUUllKKZViCJVcE119Rm3dWCAwLsJ/lni7p6/rHo
         wBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ViTlD3TI/mu/ExFAhfb+I3j+O7BQEDA/3ZqLbbAaPzo=;
        b=gAgU2Zj7b292OzbBqhkyE+Jo+uoRKu5KgOl8MH57pWJwGlPTRW65l1v+fkk1aW75uq
         LfJIfy7jx8hYFV5vyfG6rae8Vky0S+Xi5wIS58nSnDBdv5Xl8tly/zmV1HYiCiYgbyEG
         GfJIzoKVajgNdKlvePlEFOxeNGa58Nc9vy3G5qt6LygoDCFexfPVdAcpjCtQ3oIv55LE
         oKq9qxmmMSqP0iUQ60N9ogFAfjWwvI2xqFr5aTTXBv0Z8nO5AF7ZAGyHBM5gewQHTp/x
         zZeb70OX/3x4kPPbs3HdxbTci77sxAGhTRBIqFqpNtjVEkxA/7mh0BuTQfsOs6MrnEtr
         scFg==
X-Gm-Message-State: AOAM532IF6Lu/+5pX731TpqF0zkIlHWB2GWHVJCPEUWiIjMNxSgHllAh
        w65QolDN2AoxOfaJUfm5JN4=
X-Google-Smtp-Source: ABdhPJwzgNsADtOcwrpoxRlCA1Xlrn86hqWy8Zx7hTOuX2McD68ODR2l9ShtcMjEGVfFYSkp0ku2Gw==
X-Received: by 2002:a17:907:6e7:: with SMTP id yh7mr10425518ejb.352.1624617421040;
        Fri, 25 Jun 2021 03:37:01 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id hg25sm2496732ejc.51.2021.06.25.03.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 03:37:00 -0700 (PDT)
Message-ID: <afd3f1c5a8193b147e75f473a3af0b9246a5b341.camel@gmail.com>
Subject: Re: [PATCH v2 2/3] ufs: Rename the second ufshcd_probe_hba()
 argument
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Fri, 25 Jun 2021 12:36:59 +0200
In-Reply-To: <20210624232957.6805-3-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
         <20210624232957.6805-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-24 at 16:29 -0700, Bart Van Assche wrote:
> Rename the second argument of ufshcd_probe_hba() such that the name
> of
> 
> that argument reflects its purpose instead of how the function is
> called.
> 
> See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba()
> based
> 
> on its called flow").
> 
> 
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> Cc: Bean Huo <beanhuo@micron.com>
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> 
> Cc: Can Guo <cang@codeaurora.org>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Thanks for change.

Reviewed-by: Bean Huo <beanhuo@micron.com>

