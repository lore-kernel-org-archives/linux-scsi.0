Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80284C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 15:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiI3PD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 11:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiI3PDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 11:03:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154E460F3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 08:03:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r18so9605365eja.11
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=v6K6/zg5ajUnLtl/DvWZXKe8DPRpoYDcFR343TCXQy8=;
        b=arxsywWSf2dDq1PMyz3YCcgShWHcG0PCIm3LXgdKHN9Q7z1eVau18557gRW89fz+mJ
         CwiA7swvlJ9f2MdVHtcbOlun+PkEIxH1V6HHggElSCKbVjBuQLNEOuLYPjTrWxjZsCzX
         9fCUQmZ3jgikiy/uE0rQLK+nmoXive6ZnsYP0S5k5K1EfkPPYfDHoXnhbAAeZ61+1v/9
         phHjAWWtC0MXXl+fN7Gtc5Y0bK5wG0BA6AX2y60yOHo/d6bHSbCXO7M1VmD+u9BMLVrj
         vJFYPmU/G1NQZjdKtUNYyHkpZ/5tcCydG8VWKWJesQItAed2/Ea1dmnNvh3wSSE4hQ5f
         87Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=v6K6/zg5ajUnLtl/DvWZXKe8DPRpoYDcFR343TCXQy8=;
        b=fe4kfTzfqNyCjFcj1CnWjq3ylr/hvRU0+AdjqzBul9lB9hJVDZkD/RVdAjfmXAQWt9
         d/uQHHvU+UOLROJw5X4GeN8e5wNBF3h0GZx525FRgombUxGcxZBy5oNq7732Rgz8vm+w
         PtMs4ue/QvLe6UgDD8qffAw/oi1LRIwl8gpQ/UsYSc0zDtU2CPJWXwhh1XVFcRokAV8v
         lTfCiA5AEXDToULTntXQ9Fti6YgBAloi3K/mKNNlt0KNMdG9ibkYne//GXhVVXKjSLys
         9uw2hSPMYIAdSeTlDNKFdQFRaGp2k346+99RRfE9Tffor8mCiY/q0fN+vSwE6gcgWhBs
         6Cxw==
X-Gm-Message-State: ACrzQf3kn2eAIApOjicSlb+RrotN7u6hBkg6o9zXMasWhdX58IiRvkCX
        71ZXDmVNUoe2qCU/OKTk700=
X-Google-Smtp-Source: AMsMyM6oKyO7GgpKnDLP4+SjRTBPCk6COtnI3ffV2G52bjzD+x24vEzflbGgL+mB85Y/vOvczC+l1A==
X-Received: by 2002:a17:907:2721:b0:77f:d471:47b3 with SMTP id d1-20020a170907272100b0077fd47147b3mr6769331ejl.591.1664550228445;
        Fri, 30 Sep 2022 08:03:48 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id k5-20020a17090632c500b0077f324979absm1315828ejk.67.2022.09.30.08.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:03:47 -0700 (PDT)
Message-ID: <67bfe4a2175da74b686a4990a6ebe0b91017599f.camel@gmail.com>
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the
 SCSI error handler
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Fri, 30 Sep 2022 17:03:46 +0200
In-Reply-To: <20220929220021.247097-9-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
         <20220929220021.247097-9-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-09-29 at 15:00 -0700, Bart Van Assche wrote:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_link_recovery(hba);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_info(hba->dev, "%s() finis=
hed; outstanding_tasks =3D
> %#lx.\n",
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 __func__, hba->outstanding_tasks);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return hba->outstanding_tasks =
? SCSI_EH_RESET_TIMER :
> SCSI_EH_DONE;

Bart,

you have reset the device and host,  in the case, there are pending
TMs, Should be cleared locally, just like ufshcd_err_handler() does?

Kind regards,
Bean
