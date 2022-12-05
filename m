Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A23C47088
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 21:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLEVty (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 16:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiLEVtd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 16:49:33 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18082D1D4
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 13:45:52 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id b9so15099145ljr.5
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 13:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ho1xT1DNH2hZ7tSFEwwpKWLKb8YR6673F+jub5l0Cqo=;
        b=wRrK0lf09eTZiC9pyj8GTiGPsCo+Q6tzgLrid3OIGKwo14+4+D4SvM4z+lrLd9XqYh
         qoCqPzGN353txXXHMUm6UGuZ3E55BRot1jfwEUvgj9oX1Jjg/p3kC1MGBUhEDKCr2BZn
         4VUK9XLwnVbKHWiSUFlu5b+GBmmMbQqjh94F6qPuQQtGW6ELitCnYVYOG4LuCzEP2VHA
         svsKQtjZcoF6d4P6Wt1AlM0PsSkUSZ71K+u254d1DXNs3HH5XE+fYfX4KsU7rgpeO8E+
         bm+0lPZ8nQ5fauGgm+FLUZ9NSfA2tPfOGSVda4E3+99Sk8+6RaqtbRWurCOwxgQ3d+im
         KHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ho1xT1DNH2hZ7tSFEwwpKWLKb8YR6673F+jub5l0Cqo=;
        b=3x1VQ2znl8LnRRk6MBmb5Wr1mx3R7hT4h85R8BeiECRkuInrn1cyAB3SqBqCYY3v1M
         BS12pAwjrmRAegwR6XNWv18Anp4ouXI3tYfHmVcK9GcL6X9Xu9hfVWfVWTHdzVVU0QCz
         jM/3thXsC7JYrVl8cK0Pl93WieKv9RPXSxUW6YMlE/eWW/gzxtt495AwHkUMfuAH/K/7
         uuEGGhAZAtQcFhyQ55gnIOULE+t94S7uhymn+wK4r/UqFkN2EZNp2V3wxsP/OwAkTlyj
         OFh/nqeLgs7oVRBX2fkq7rqlMMEUw9Rt2+wi6hhxcOYyD8ynjlKJT+/YzJ2kncEe3a29
         MQuw==
X-Gm-Message-State: ANoB5pmCVqHoFE3rpMovU071bdscohHf0QtDgmzlAPM7F2N2COi+69hS
        F2R/wulWpprZH/ypLS+yMlNqMg==
X-Google-Smtp-Source: AA0mqf7MaWgYfZrCFNYu2ixUr978meX9sDkrK7zebK8zQmNU6JMjFYnwbYLOGtgPajOZfLvt0gkdbg==
X-Received: by 2002:a2e:86d2:0:b0:279:df97:e895 with SMTP id n18-20020a2e86d2000000b00279df97e895mr4625724ljj.226.1670276751045;
        Mon, 05 Dec 2022 13:45:51 -0800 (PST)
Received: from [127.0.0.1] ([94.25.229.129])
        by smtp.gmail.com with ESMTPSA id a20-20020a2eb554000000b0027a081bfee9sm216675ljn.43.2022.12.05.13.45.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Dec 2022 13:45:50 -0800 (PST)
Date:   Tue, 06 Dec 2022 00:45:47 +0300
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
CC:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        ahalaney@redhat.com, abel.vesa@linaro.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_01/23=5D_phy=3A_qcom-qmp-ufs=3A_Remove?= =?US-ASCII?Q?_=5Ftbl_suffix_from_qmp=5Fphy=5Finit=5Ftbl_definitions?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20221201174328.870152-2-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org> <20221201174328.870152-2-manivannan.sadhasivam@linaro.org>
Message-ID: <BAC8FE14-4964-4E3D-9335-192465B4DF2A@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 1 December 2022 20:43:06 GMT+03:00, Manivannan Sadhasivam <manivannan=
=2Esadhasivam@linaro=2Eorg> wrote:
>Following the other QMP PHY drivers like PCIe, let's remove the "_tbl"
>suffix from the qmp_phy_init_tbl definitions=2E This helps in maintaining
>the uniformity across all of the QMP PHY drivers=2E
>
>Signed-off-by: Manivannan Sadhasivam <manivannan=2Esadhasivam@linaro=2Eor=
g>
>---
> drivers/phy/qualcomm/phy-qcom-qmp-ufs=2Ec | 146 ++++++++++++------------
> 1 file changed, 73 insertions(+), 73 deletions(-)


Reviewed-by: Dmitry Baryshkov <dmitry=2Ebaryshkov@linaro=2Eorg>

>

--=20
With best wishes
Dmitry
