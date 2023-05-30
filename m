Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63B5C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 11:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjE3LKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjE3LKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 07:10:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F75B0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:10:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96f8d485ef3so675394966b.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685445008; x=1688037008;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R8G37TBNrAXNARzoGRP4mOfSp1MgT4ZHRFgb1p3wvZ4=;
        b=nhsoQoeo7B8zzGXoxM6MMiWWl7lDDCmY9lRcR48oyNpgjt+Cgk+gMvHGkfH6t3e/fC
         C4bTuffvKb75bR6NTuyg0JuzTAdVnabdh1ph0mQOezSeZWBgNVUmw1FladF750M7H4yU
         vZDGkuG9LETU0HAyKQiclMAb2r8QFgYlx6FbsiPhWBbQL88UruxSxb9xZKb48eP01iDF
         V3NaQr/onEF4QzaQtfVftNLFz9EElvhLaiKVM5z766Ty78HesI7x98llF5p9EiUD5c8s
         sy/Otc2wM56f7MuuaAm58sjpMShMSutwusHPIdblxccRUsjINqXuyKiKiNxgnhhmQQRG
         bchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685445008; x=1688037008;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R8G37TBNrAXNARzoGRP4mOfSp1MgT4ZHRFgb1p3wvZ4=;
        b=Fw+XUlqy0ATBZCGSECV/J2vRQuglJjYKR/Y/gxPzxeOfjcUwSoherfVPzi9ZBC07Ob
         ethHzZz+SP+rsW8XsltaZg/RN3YVW21CKSbwYgd5m11TP7ZXLFuWTtdf2f3fhcD+Wd2S
         RnKRGhB4cenpwJKE7KiB3TJMJ2kyl2Haq/f3BkaCRM4BcqDJGWaacJ4l4auolVyjUlf4
         L6zGee1GfrW7Zot5Ji7zcnVBetFW24SDKSztR0GocK5POryQ/u8sqxbuNQ/LvoiHu8gP
         /FZ19gHrPXrQAsm3z2fJFLJrSRIPuxr11CzkojcUf7eXikOm9EP1Fayw875RcxB/1/Wf
         58eg==
X-Gm-Message-State: AC+VfDwvnL064/L+vV4KR1EBHM1J0JdZe7jZK1Dw4IUYIzga1N2CL/QO
        epEc8l0brIYPDvPNAXlDAuw=
X-Google-Smtp-Source: ACHHUZ6yiaMq15otxc56Akku32ZJ1rLBLSpjmtcYV/Bhn3WLZGh412HUxYynIwQXGOi8eWLp/I4n0A==
X-Received: by 2002:a17:907:9722:b0:973:946d:96ba with SMTP id jg34-20020a170907972200b00973946d96bamr2150213ejc.69.1685445008132;
        Tue, 30 May 2023 04:10:08 -0700 (PDT)
Received: from [10.176.234.233] ([165.225.203.148])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00965bf86c00asm7335110ejf.143.2023.05.30.04.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:10:07 -0700 (PDT)
Message-ID: <ebfa75c01d0f565d82b78d68417da4abfd0985cf.camel@gmail.com>
Subject: Re: [PATCH v4 5/5] scsi: ufs: Ungate the clock synchronously
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Date:   Tue, 30 May 2023 13:10:05 +0200
In-Reply-To: <20230529202640.11883-6-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
         <20230529202640.11883-6-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-05-29 at 13:26 -0700, Bart Van Assche wrote:
> Ungating the clock asynchronously causes ufshcd_queuecommand() to
> return
> SCSI_MLQUEUE_HOST_BUSY and hence causes commands to be requeued.=C2=A0
> This is
> suboptimal. Allow ufshcd_queuecommand() to sleep such that clock
> ungating
> does not trigger command requeuing. Remove the
> ufshcd_scsi_block_requests()
> and ufshcd_scsi_unblock_requests() calls because these are no longer
> needed. The flush_work(&hba->clk_gating.ungate_work) call is
> sufficient to
> make the SCSI core wait for clock ungating to complete.
>=20
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

