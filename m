Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ADDEE49AE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 08:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjHWIKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 04:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjHWIF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 04:05:56 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148861721
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 01:04:34 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-d77a4e30e97so995671276.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 01:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692777873; x=1693382673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4x18HgxcXuVIfqokI9MrmvgHbYOVzb20sqxbnbY2CMg=;
        b=BHPJJYWgI3y8TP+PbXbXHe9EoUB31NFYFuLKGqC5SqPy+mO00AhzDYg37HhppnIFo/
         SgZQ76lABeqqefWejNA8ZYtuNbl4+Jti7DDluHO3AdrC089eSQ7E0sQ8fO3c01iULqQe
         +HPiFlsQiTi72puH++Rr3EHGb/gykt/ga28g3Ed48yIX9X3yf3APdqmO+ZpB6au+26e9
         4Jq1uAwaTcoua7wJzglFidCTg03+QAN3H/A0wXe1BdIdY1dCpP+HY9KUJCDhjVGPeW+h
         ElbRVjE3M6iDP/2zT3WjFNr3GZc/lBkpl72tSCK61cxQqfJqTeIXP1H7FurNxCVco1KL
         vg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692777873; x=1693382673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4x18HgxcXuVIfqokI9MrmvgHbYOVzb20sqxbnbY2CMg=;
        b=c8NdeE5J37p6x12IyiNpRntJhF5G7BUnQ2D3GYyeDQqEuheH6INfI073Kf5qOLbqIL
         CC4LZV/jojK7g3tFKDLCrWqQV3aXvItnLUPuDsY2eU5SLKlHA38cbVmSsVb5N4hZmF3J
         HXWbeLZVNhJBLoSphHMEGN8kk/EyScytvD3rC8fJ9gkp/i6vEbxZKVsNTR14MbdEyMTh
         vR7QrInTcc3fQbij7eseXvmdEEFPzpYKwpEk4g/GkgZy6p2XyJjMdjd1XzARJyqd7Qn/
         b/rHlPxfrctacESe8EtLHai0iJ9TZ4/G5SCg5TpESjMid09uCdMpxWj+RXjGQVjAuG91
         RWvg==
X-Gm-Message-State: AOJu0YwYuzoLzjeUVyFtqhmW2c+tviiBN8Whppooj6iXoqeQaCvw7f8r
        sKO92hxT/aEQ748u6A3J8c9RO/KJzzF1Xb9/ApsaAg==
X-Google-Smtp-Source: AGHT+IGrOMMEwVtHryHwU0XzgH5J6pb+GFBjuvEmvNHq8LAg555gZ6ClRom7dtM4aWc9Doh+9kYdPlPZ/Q8JzX59BZQ=
X-Received: by 2002:a25:aa26:0:b0:d56:7556:93f1 with SMTP id
 s35-20020a25aa26000000b00d56755693f1mr12580669ybi.29.1692777873522; Wed, 23
 Aug 2023 01:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230722014037.42647-1-shyamsaini@linux.microsoft.com>
 <20230722014037.42647-2-shyamsaini@linux.microsoft.com> <CAPDyKFoBC+GaGerGDEAjg9q4ayV9mMBKkfFk3nO-zcQzOZ_H6Q@mail.gmail.com>
 <b875892c-1777-d84a-987e-1b0d5ac29df@linux.microsoft.com> <94728786-b41b-1467-63c1-8e2d5acfa5e4@linaro.org>
 <CAFA6WYNPViMs=3cbNsEdhqnjNOUCsHE_8uqiDTzwCKDNNiDkCw@mail.gmail.com>
 <CAHUa44Ek0k2b-igA6Gd1ZXVzibTh2sNDMnE-weQwFFKEZ_1jOA@mail.gmail.com>
 <CAC_iWjKKap47PhiCi=BfPZC_wJhVDB10WSf9oWMgdwSgWCfO_A@mail.gmail.com>
 <CAFA6WYMPsBUutjKrm+6qTNHpVr80K2GcSLoYa+MFE3CfLSo8ew@mail.gmail.com> <226aa02d-1247-a42c-123d-1c86b6b43d9f@linux.microsoft.com>
In-Reply-To: <226aa02d-1247-a42c-123d-1c86b6b43d9f@linux.microsoft.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 23 Aug 2023 10:04:20 +0200
Message-ID: <CACRpkdb=AnJXG2J_DRsN-RUEh=7_eAs8+_CxPYuueVM0c=DP3Q@mail.gmail.com>
Subject: Re: [RFC, PATCH 1/1] rpmb: add Replay Protected Memory Block (RPMB) driver
To:     Shyam Saini <shyamsaini@linux.microsoft.com>
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, linux-scsi@vger.kernel.org,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Tyler Hicks <code@tyhicks.com>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Paul Moore <paul@paul-moore.com>,
        Allen Pais <apais@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 22, 2023 at 9:07=E2=80=AFPM Shyam Saini
<shyamsaini@linux.microsoft.com> wrote:

> do we plan to disable access to RPMB devices, once we have this RPMB
> driver in place. User space tools like mmc-utils/nvme/ufs utils
> can still access RPMB and programme the key and should
> RPMB driver deny access to RPMB ?

We don't break userspace. Just not. This is not an option.

The RPMB subsystem simply has to provide the rpmb character
device the same way the MMC subsystem did, or provide an
in-kernel backend to the MMC subsystem so that it can provide
the same device. Whatever solution is best.

No deprecation and deletion and breaking userspace. Ever.

Yours,
Linus Walleij
