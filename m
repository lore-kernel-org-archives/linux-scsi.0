Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B02C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F11EE61108
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhEaR13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 13:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbhEaR1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 13:27:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051ABC072122;
        Mon, 31 May 2021 09:05:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n2so11472157wrm.0;
        Mon, 31 May 2021 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Qc6CI/WXrqiqEChpYGorO6MkwQYDxw3uL16JCZvhWUM=;
        b=qCqJmtounWoHmySgIWFJx3GKQV1ZiTAr7/JgogeudF/5uBOPGllZYzdTYWU/SNLtgT
         RFRUeX6e7Wn0Y5gWuSrLxBOssFS9XD+TbSx03mhlnX7E/ZNtb4FwMRxjeqTQIZVB/KcU
         jo2+TuM3l/MXi3LaRGsCYqa4Te5vQ0tN1Nhcpf2M17WerAVT+fYlBMtmIZsrdam+1jze
         kIUs7FEgxl5vbh9JpnVM6JxYogFNGFm3PS4IvV03T57NtWUY1rWYacKXYMqcKdToyK9F
         cAMU2F38vcSAtuzA2D/OcQhbAYOoy3Sv09I1SKsfUZmxgLccZ3Q6bFrunv2EPkT/2Kb8
         J6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Qc6CI/WXrqiqEChpYGorO6MkwQYDxw3uL16JCZvhWUM=;
        b=E1Jb7lbHAV1NWrP51TgsvY906sX2KkSaHS3UowbKpKtAPeqgHdVWJnRd+BmT9IsgVg
         PXJQtdMP74hVysZtZ3V0cYbIvB3F1/f3hCJ16trtQzqzsMHg6Jos9dKh6tIaSdcpwPLT
         FbtcJMa849LS8iHlALgFS3kX3+r7Uv76C7v5pCpsK6k2lPoDZxuR0O/C0o7kowkrMcDq
         miWN78dSHMKqV6gRZYWhUy8rk4H4YmbgYeVP1Nf4jo8qNN21rvggVaM0cY2yO3AOJDhg
         bRCChIClsfFHUCkm90z01Dfn4S3ruwsuPkZsa3uKD+6x+LOEEC7ZdQoss4CVh/HO5eKF
         x+Dg==
X-Gm-Message-State: AOAM532yhlbNikqh/u0IHGpy15r1/qKTNuywrTvuLiCtMtoaTYTRNafT
        C32slV6RnihhzrFzqf11qck=
X-Google-Smtp-Source: ABdhPJzyI+GMUKWGdnluF3L0hbXzLcnYFP6YTTjFJAKEmHNmyYxDt4HnS2Vpf8+CZDWtmk++b7GLbA==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr23013384wrd.407.1622477125656;
        Mon, 31 May 2021 09:05:25 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id b10sm128238wrt.24.2021.05.31.09.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:05:25 -0700 (PDT)
Message-ID: <88dc0251ee98aee5af2217f5d864f0a893dbdef8.camel@gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Utilize Transfer Request List
 Completion Notification Register
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Caleb Connolly <caleb@connolly.tech>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 31 May 2021 18:05:24 +0200
In-Reply-To: <1621845419-14194-4-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-05-24 at 01:36 -0700, Can Guo wrote:
> By reading the UTP Transfer Request List Completion Notification
> Register,
> 
> which is added in UFSHCI Ver 3.0, SW can easily get the compeleted
> transfer
> 
> requests. Thus, SW can get rid of host lock, which is used to
> synchronize
> 
> the tr_doorbell and outstanding_reqs, on transfer requests dispatch
> and
> 
> completion paths. This can further benefit random read/write
> performance.
> 
> 
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Co-developed-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

