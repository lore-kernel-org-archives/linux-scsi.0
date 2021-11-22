Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C644C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhKVU2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 15:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKVU2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 15:28:49 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A341FC061574
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 12:25:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d24so35000600wra.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 12:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rwGWYE4/YHq4l4sXy3xg1f6W+JJ4x3KR4OrhMHaw3lc=;
        b=PJGJyjhw/bP/3+wp3nMlv9G2R7kajSS3mx3UmZS1F2tir47TkDCj9WoVploe7HBWic
         Txm332KpmPAkPPx4YUeRQAiWrNUKUEpqYyX/6Mu2Ljpv5aYB/Ct4+yVV9Q3PJVdKQ1LN
         VW+qygz8nQfEoKEJ5AkYGiIu0EPHxR7fgwL/hVan1dMqCB/6yPUU0QU1Fzr6ivh5w5Uc
         HPClYlHuTQEo6+f06nxHQd18XMhr7pT5WkHiMzOyBYXf7nrXYmOspFtUhSgqksnvMVMr
         hAI0em2bsSWI+vEheStjiw/9vuJCYZhgx+OU+PP6Nt4asccLiBkv9xaGt4m5a4f9Ov9m
         jE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rwGWYE4/YHq4l4sXy3xg1f6W+JJ4x3KR4OrhMHaw3lc=;
        b=cR2BVZftkkEM6HZiKaFPAstep4G34o7NypfxC6ipQ91zZFOGJi6S25uuDvbBkZQhg9
         PCp6n31DdOkw+psBCtiEZM7K+b3XMGhhecJEUrIZn/2pEQMCVeaWDJqj4KC1nb/XDnn0
         CAOuPsqFJFp1PfDJf8yNDlI+Z8ZR0RH3hg8GsSUI653sH34fyTOXRC/MXdYUI+HngC8e
         ch8fSFc6BJ57lxBuvHsFb4Ti/fLeg7JokEADeN++S7y1ggSEiz83QmOjMIqqO0SUP+ej
         Hbbhe2pWHHtU72+jbbQj49lYHtIIu0yVM4ns5k/yN11OYZ9MQTNmLRgc9mME0o/luNEH
         6lyQ==
X-Gm-Message-State: AOAM530PBxpXd1SJq7fN4msL9fXsINVE5orLzi03mLtxUK3IZvORNjec
        GptvpO0rd2SZ0yKGB0xazaA=
X-Google-Smtp-Source: ABdhPJwqwoj4TQqWEx5P4aWYb1DPsexPArS4J9hdZoxw2z97GEOMEx7mP1ejgmr1/l4s58JU/fiLFw==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr42495493wrw.118.1637612741215;
        Mon, 22 Nov 2021 12:25:41 -0800 (PST)
Received: from p200300e94719c9d26370150383a113b6.dip0.t-ipconnect.de (p200300e94719c9d26370150383a113b6.dip0.t-ipconnect.de. [2003:e9:4719:c9d2:6370:1503:83a1:13b6])
        by smtp.googlemail.com with ESMTPSA id bg12sm9855136wmb.5.2021.11.22.12.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 12:25:41 -0800 (PST)
Message-ID: <c6002d6789f5e51652fc5da3cf67a3d12f25de5c.camel@gmail.com>
Subject: Re: [PATCH v2 07/20] scsi: ufs: Rename a function argument
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Mon, 22 Nov 2021 21:25:39 +0100
In-Reply-To: <20211119195743.2817-8-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-8-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> The new name makes it clear what the meaning of the function argument
> is.
> 
> 
> 
> Reviewed-by: Chanho Park <chanho61.park@samsung.com>
> 
> Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> Reviewed-by: Keoseong Park <keosung.park@samsung.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

