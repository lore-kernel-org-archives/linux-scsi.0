Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405A6C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 07:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjDRH5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 03:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDRH5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 03:57:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F0C4201
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 00:57:48 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4ec816d64afso9281921e87.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 00:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804666; x=1684396666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAKYIorvlE6NwFtMndb+APlIQ20b/T2io24+lSh7W/c=;
        b=eqct0YMt0aJpb5ImyuFOiyyHfe3teqw3hat9lEI+AmxmAxSW4sn2PHcLMrr3HIVfsT
         PlT0VtBi5Y0QAWy1eddwGtFZgTkz+xx32e9T1n57sONUF7J9BPegVXjX8Gsus5q7XZ6j
         3S6zZ/iZfLx8QQ1efH4cJhyGzEtj4OQh8F4VzEvQsXpTiI2//0Bw5g+d8BuO+lDtSGDx
         S0f3He/54HffHhQSGyhUmX8wyIJ0E+3IETiVLdbfJJaTGxUdc8z+z7ebMUpkKRO//yEw
         AuPZKym5ez0gPA5nZuwCsYrannrqF37QKMu9atgRY7RIbAhOR/KLeu1lsb0R/VwBAtHw
         L1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804666; x=1684396666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kAKYIorvlE6NwFtMndb+APlIQ20b/T2io24+lSh7W/c=;
        b=hTq70d1TBjsvGDrdvpZUYdaSmDLeDHwb6Iw1oR9wpAJ2vnWhtWA3rxniXSLn5Dk7FC
         KWf2PTBAH9udPequ9YywBuNxkgsf9CbfM+lZuPF3EhTS6bjsGaHvdRkQ42SLfb4obZRa
         JwKBZI7oHvqD5SrzP4iKDSevNNF0f5+nQ1bwsR7kHT9926ARB/Z86u1OHYguhEYbD8bx
         biLJZY76KiR1ghzRLT9o4ltFnBQX3nnnD4ynxjoNzTkg4bLasj1DMKMZ7DlQ1+qXR2UQ
         gLly0hirwIzWh0/j2VInX4AiEG+bC2p8nMGzZVRWBSSAD4gK/VvOYP+bM6GYXnfXgCfn
         2k9Q==
X-Gm-Message-State: AAQBX9eQnNZD2Ivm+/Os+MUWghJ8JtlUVumczzSom6AAbqvSj1Bs+d/Q
        a1/yB6fHBWbyw2I56/94t+cPUV7lEwzvm36vng==
X-Google-Smtp-Source: AKy350ay3GAmkMZ1sibDS9+iGjOnBoBc/giXmFgdt3pSLe7jX13IiBSe/KPgjN/gMddfL4JBLfVM1VhMhHVcd9wMFPA=
X-Received: by 2002:ac2:562d:0:b0:4db:b4:c8d7 with SMTP id b13-20020ac2562d000000b004db00b4c8d7mr3151943lff.2.1681804666149;
 Tue, 18 Apr 2023 00:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230417230656.523826-1-bvanassche@acm.org> <20230417230656.523826-4-bvanassche@acm.org>
In-Reply-To: <20230417230656.523826-4-bvanassche@acm.org>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Tue, 18 Apr 2023 15:57:34 +0800
Message-ID: <CAGaU9a9btBMn5yX-kWf-QRbc=HGfbz2WqtU0H=Jv08AapiigeQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] scsi: ufs: Increase the START STOP UNIT timeout
 from one to ten seconds
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> =E6=96=BC 2023=E5=B9=B44=E6=9C=8818=E6=
=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8A=E5=8D=887:17=E5=AF=AB=E9=81=93=EF=BC=9A
>
> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
> Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
> Hence this patch that increases the UFS timeout to 10 s. This patch can
> cause the total timeout to exceed 20 s, the Android shutdown timeout.
> This is fine since the loop around ufshcd_execute_start_stop() exists to
> deal with unit attentions and because unit attentions are reported
> quickly.
>
> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
> Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeo=
ut")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
