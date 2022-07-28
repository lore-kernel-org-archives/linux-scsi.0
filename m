Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121F9C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiG1WXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1WXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:23:22 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5189C796B0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:23:21 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id oy13so5468322ejb.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=L1jwqncOixuONiv1NPSLlTRPOyfC+aepdHS8AnDO7Gc=;
        b=d/Z7K/ckzyYpmV1lL4vAK4ygmXIc2CB8ZZ+LojHVt6nTG/l/5sXgPScuX2sF2VTnbp
         xRs9Rn42tfCOr5pWVKWaPvZwBHgdryRnMo1NlF9nwCzxqEgQy0dVWqEwYRH8P6g/KUIC
         6hxSEKW7LkqUmDFgY03zQT78+QSFOUs1Lp7J+MsgFxfP7GRwgxx4zwoabI/+tqXxZ23o
         8emJxRVoLOiTjaFVtsnaC8qwiUB5V0ykXBEuYgF9pgsEezWmIRjueVWQJdPYQ/GKmVhY
         5MRYhFYUhKYsGRL8TAChFHmOmUHI/Er58hk/ppD+L0N+mO7rc0+PrFI0RNb/az8dKFqS
         5bMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=L1jwqncOixuONiv1NPSLlTRPOyfC+aepdHS8AnDO7Gc=;
        b=zXDjimBcrcv/IoNrghNz2hWDOk/dPWmDeOdgUwH6k8W1I3PCbJJWe9ahHF/ZrymbRO
         AW+McSQOjN5RJoGYgAeXtuzYc6pRMn1/gsBo0LhTppkt9j29fMhbOfgTYSpLawdXCQWk
         644fRGE2vyXimC19YnGDk/ZGVbvFnZnt8kSJJ1DsUoNMtihLtLHlrrvtRLgM2WxCD7TR
         sTsckpH+cPQyWuBo1ckiaLJOLq251ZEhHxweLLAyi3J2vLXQnGYEnphXdjETGI4iYG21
         1B3g4QiWSEXdTCMIeK2pvdsN68s4puKt74wY0f3uziI//d2A7l4UAGHicq7CKpjMzuj9
         XgeA==
X-Gm-Message-State: AJIora+tlLTNoWZrUxDkrE7WlwFo+qUV9URuZo0x16DluwyRS+PhoMQh
        L6Mvei5D6FfPZO+gnTXE1m4=
X-Google-Smtp-Source: AGRyM1uG7NJNfjyEexbkYk5WWRWCe0XQ1RYU1ncjzr9Px4lvMUOR0ETSKOf8e3RDz0FtdfUHGtcS0w==
X-Received: by 2002:a17:907:720f:b0:72f:1c62:8dac with SMTP id dr15-20020a170907720f00b0072f1c628dacmr698018ejc.437.1659046999754;
        Thu, 28 Jul 2022 15:23:19 -0700 (PDT)
Received: from p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de (p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de. [2003:c5:870e:1483:ac11:a16c:f4a:e195])
        by smtp.googlemail.com with ESMTPSA id i15-20020a50fd0f000000b0043a5bcf80a2sm1386823eds.60.2022.07.28.15.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:23:19 -0700 (PDT)
Message-ID: <3b1a57c89058e3c09a746bc55c21fbb15434717b.camel@gmail.com>
Subject: Re: [PATCH 0/2] UFS Multi-Circular Queue (MCQ)
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <quic_cang@quicinc.com>, bvanassche@acm.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        quic_asutoshd@quicinc.com, quic_nguyenb@quicinc.com,
        quic_ziqichen@quicinc.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Date:   Fri, 29 Jul 2022 00:23:17 +0200
In-Reply-To: <1658214120-22772-1-git-send-email-quic_cang@quicinc.com>
References: <1658214120-22772-1-git-send-email-quic_cang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-07-19 at 00:01 -0700, Can Guo wrote:
> UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to
> improve storage performance.
> This patch series is a RFC implementation of this.
>=20

Hi Can/Asutosh,

we could remove RFC, add more detail about MCQ configuration and its
implementation. Review will takes longer since we don't have a platform
to verify it, and now only reply you to verify.


Kind regards,
Bean

> This is the initial driver implementation and it has been verified by
> booting on an emulation
> platform. During testing, all low power modes were disabled and it
> was in HS-G1 mode.
>=20
> Please take a look and let us know your thoughts.
>=20
> Asutosh Das (1):
> =C2=A0 scsi: ufs: Add Multi-Circular Queue support
>=20
> Can Guo (1):
> =C2=A0 scsi: ufs-qcom: Implement three CMQ related vops
>=20
> =C2=A0drivers/ufs/core/Makefile=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0drivers/ufs/core/ufs-mcq.c=C2=A0 | 555
> ++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0 | 362 ++++++++++++++++++++---=
------
> =C2=A0drivers/ufs/host/ufs-qcom.c | 116 +++++++++
> =C2=A0drivers/ufs/host/ufs-qcom.h |=C2=A0=C2=A0 2 +
> =C2=A0include/ufs/ufs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0include/ufs/ufshcd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23=
1 +++++++++++++++++-
> =C2=A0include/ufs/ufshci.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 89 +++++++
> =C2=A08 files changed, 1251 insertions(+), 107 deletions(-)
> =C2=A0create mode 100644 drivers/ufs/core/ufs-mcq.c
>=20

