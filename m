Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9518EC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 04:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiHBEMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 00:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiHBEMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 00:12:20 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049EC18B0D
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 21:12:19 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id j63so21896793ybb.13
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 21:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB9h8G9LJF8fW8nHybI8e5Iuu0xEFlrhVdl6RtAPL58=;
        b=D8xqF6gqVwgRmjc6T7IFge/nqYPeDWoinA/3nld8iU+Rg3OvO70iE2v1rzUIrG8MZj
         qGhIBy760M2U1mdG2ZYlat0wTNl05qOXhSP6ELrth4M0ansXNj/qv8lRqp1J5FwCrZVv
         TJiUTFnl3jsOxN0b9vuw3V48OlVC0QBVetP5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB9h8G9LJF8fW8nHybI8e5Iuu0xEFlrhVdl6RtAPL58=;
        b=pnuyyEpR+UFNf/fxs8Y3wiLhQGfKC7a+Vxo6jnU2PU7JsR11DGbXrykeiHhzXOH+QQ
         AEO6MPIEUPfi8IO/jAwC7veEvfh1Qf3fPPAEq9fmIApczFQqJ0tGsKFxI09bTQsSc11r
         PMz1oSqPCPX2nyoJ4JNV7F+mgSRkImSfooqNzvR/U9HkJ4HMJTbfLkaN1kXR2+llP/bf
         dWUGwKBiNGlmJz/k8YQhqNztBXQKJuEyxSmlHaMD1oiuRdQ5vK2/03vx48dThcwBMQWy
         96D+/R9Vh52D1QgOsOE3KTpOpZxllPUAJa01WGUwKI9I/kwSFVymv6gjdOb9IQu/bCFL
         2BHg==
X-Gm-Message-State: ACgBeo18iCqXbBU71D6LEYSts7kpTml1A0EXA+j3OB/cR6N9uyguNxYX
        idJns3Dmt2f4uGVLNytDQ3I8coAjLOb5kmxndD6Z8A==
X-Google-Smtp-Source: AA6agR4jGk7db6YnblMvl6gotI+dOcEvoOeEMq6XPSBgfWTyVIX+RKhIFBiQKVY7fmHKWFKz/7SAl7l1eDzedE16O98=
X-Received: by 2002:a25:7cc2:0:b0:677:5a84:9f79 with SMTP id
 x185-20020a257cc2000000b006775a849f79mr4233940ybc.518.1659413538291; Mon, 01
 Aug 2022 21:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220802103643.v5.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <c4acb34f-7bba-336f-ddfc-a9c098f2c95f@acm.org> <CAONX=-cAW5UX__xu5y7NdtHkZq-YWmh_k=iFa5witdxw3xXkYA@mail.gmail.com>
 <d06d9625-8ef9-f385-a9c9-75c306a959ed@acm.org>
In-Reply-To: <d06d9625-8ef9-f385-a9c9-75c306a959ed@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Tue, 2 Aug 2022 14:12:07 +1000
Message-ID: <CAONX=-fpMBSgMzdY9AnV3iJftv2+0UTiruMiR+Dt_dfwKEd6gA@mail.gmail.com>
Subject: Re: [PATCH v5] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Calling this the effective capabilities of the controller-device pair
> sounds good to me. But please do not refer to hba->caps. I'd like to
> rework hba->caps such that it only includes controller capabilities and
> no information related to the WriteBooster. Additionally, several UFS
> device capabilities that may be exported in the future are not
> represented in hba->caps.
So can you clarify where specifically do you want me to mention that?
Should I name the directory "effective_capabilities" or the commit
message?
Thanks,
--Daniil
