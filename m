Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE86FC00140
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jul 2022 13:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiGaNBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jul 2022 09:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiGaNB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jul 2022 09:01:29 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7CCDFFA;
        Sun, 31 Jul 2022 06:01:28 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bq11so8326629lfb.5;
        Sun, 31 Jul 2022 06:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+tmjMLoMIYtn6om1wY76vLolbl0sT7KL/dsfYbObgpw=;
        b=PBXSmwYq/8QviqsMXDaaFnLlWQFdJL37oiQnprCVNcIIAK2mpVavGMqjex6TZVTQM8
         uouAWmkEQDnmdYvON6FX9LMH01+gE17rPk5mXXZYzJhXFcYXkILH7Sf/HdQJy/ZLZHCz
         GPQzK668cWrTgsTEhWP3KTkX19PRGSKp5vSOdNYW4kFvSzY4Ls1WyxbewRxvhIrj+nb0
         SjSSNso/htU3wG4vUNGudETm7xOqXT9tfAKh49iE94OnmYRr2MbNHriMmDUAGrXRcbJv
         AI1kfqlbiSLNZbW2dRoSdmRi7v1vgA1yMPYrxdP1FDBJfie/MfIKN3YNrSSiz+D8aeUg
         oSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+tmjMLoMIYtn6om1wY76vLolbl0sT7KL/dsfYbObgpw=;
        b=BKscHqkxR6RRlikQEgNcnHMpt+s+gvt6NdpuuRjmYKhIj8jENQQF/qx7YNjvSluJu6
         ZMkfuk6RxZ+8QJDlFvAucp4BgM2hRYmfV0ChHbl0oC05sUCTnyKOtwAlDBz58lmy2+Jy
         Rqy3mOJ0Ia3hGcZi0TJBqa70Pkr7i3Wdf8ZxIl67f+AzgKx4ktALvDy9Fz+lVycGAg5W
         5260yGkbnqswlUXan8T/VlN+GgmNO+5YDhEVg9Jn1r5Wvq3RfAROlMRfCQKwsrC1UCoY
         K5c4nsuDeKsrhcZulayUe2S/Hk8dAjccQWxzmXu5TyEJMa/0OGfR9UKaNacgJaD3npdp
         LOKQ==
X-Gm-Message-State: ACgBeo0x0Pc7tdSIRZgeigzVWr1qUhIqa97dDno0Inrx+fbiKSiEMbz/
        qQYJ0+Hry9+UbVzThJL2x8UzMZR7XTtpHDvznQ==
X-Google-Smtp-Source: AA6agR4IBcjuhEdwuKRYdEbyzszbIojxjrY34nF+Ib+havuxZaKmlGvIyFFDOqXE0gwplsU1EovhC0QUStW07WiuBA0=
X-Received: by 2002:a05:6512:1292:b0:48a:e693:9da3 with SMTP id
 u18-20020a056512129200b0048ae6939da3mr3482567lfs.328.1659272486661; Sun, 31
 Jul 2022 06:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368@epcms2p7>
 <20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368@epcms2p8> <20220729045252epcms2p7fee5c1cdca5e4bef02a833e40f80649b@epcms2p7>
In-Reply-To: <20220729045252epcms2p7fee5c1cdca5e4bef02a833e40f80649b@epcms2p7>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Sun, 31 Jul 2022 21:01:13 +0800
Message-ID: <CAGaU9a8SWCGnWQrDvnJ35mjA4hv=3k0YVMqxBypcaDBkB0q2yg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] scsi: ufs: wb: Change wb_enabled condition test
To:     j-young.choi@samsung.com
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 29, 2022 at 12:54 PM Jinyoung CHOI <j-young.choi@samsung.com> wrote:
>
> Changed to improve readability.
> As implemented in ufshcd_wb_togle_flush(), the conditional test is
> modified in the same way.
>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Jinyoung Choi <j-young.choi@samsung.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
