Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D7FC2BB48
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 14:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E477923A77
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 14:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgLHOPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgLHOP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 09:15:29 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4367C061749;
        Tue,  8 Dec 2020 06:14:48 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c7so17722810edv.6;
        Tue, 08 Dec 2020 06:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ntk4ARBzMoRorjAN5A/E5yNdlDF2+4r0PmHqGriz3Rk=;
        b=C1J+nDwNp1ZdfO0ijKKGYCbe99/mqtc9zuQRgAg/JScQqexUHY1PPSPDgFbHxcUdH4
         0TVK2oVf7BcaaS1BOYAiozfNKMlkzEti9NkTZsBSpQD1qHpLKIqKkzEpzkGUgALoAfC9
         HBAQ4QAeupYVrqxd/pHK8xPuxm1/BVCfP2fP7irCwx1fX5eDThEFz0a6CIhOys9RgI+I
         SjasLmQGCz/8U3j0UVCR5Nnb7VXUqRTgJsxaezQcB8qWBOCLO1HrEjE6yFodpfazBswf
         cvZlWMFljWu5RxB1eJZRiJ/E02SbkC7dw9A2Ai/rUA++HUb8wkQQBevHmDDD71L3xMHv
         doUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ntk4ARBzMoRorjAN5A/E5yNdlDF2+4r0PmHqGriz3Rk=;
        b=CTGWhRLYv4DaRTwDdjEdIZQCN7RhH2HbA1EJtNZhz2Hs8I9O0GM/2gVuaVl0+OwNgu
         oW4RuAuo/VA+jfTkX20gsMj595+uH676sZuVhscLnf60Vq71Sip2UWlWPyK0q2r2KHJN
         wddDNEE1NutG9QMbGGlTrXoBKVu6/4D52VgU6oYakFp1+KUWG3pc3Zw9yGc3Of3H9Lls
         KwnIXg+Di2ZhqiydMeX4/uA1YcKsZfMA+K91Op84OGtEmwr+4n+XQnQL5rlmglBIA6rp
         8NZ4CmsgIrwsLU/sTGMMOvvTwAkhjGMYA0o5qgZX5WQMptgi0bur3Ky/im3eAYlSRqt3
         bX3w==
X-Gm-Message-State: AOAM530Lku/B+3bhtRo04Fczhmo04XTWGQfMkdDmo9sHRU/ntFJFwszS
        qejmcLrcZAVub8RHSQXD7Ug=
X-Google-Smtp-Source: ABdhPJwwn/b2Lb5c51CunsFgtGkimppN1lP894M6Gb0uMhuNwt9iTzSJoKqU1aGPUVT5ALatSoaYlg==
X-Received: by 2002:a50:a410:: with SMTP id u16mr24994533edb.274.1607436887471;
        Tue, 08 Dec 2020 06:14:47 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id g9sm17305447edw.67.2020.12.08.06.14.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 06:14:47 -0800 (PST)
Message-ID: <b01dacacb713ced3bd9cf07ec7a00b4eac5b5a1a.camel@gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Uninline ufshcd_vops_device_reset
 function
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, bjorn.andersson@linaro.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Date:   Tue, 08 Dec 2020 15:14:45 +0100
In-Reply-To: <20201208135635.15326-3-stanley.chu@mediatek.com>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
         <20201208135635.15326-3-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 21:56 +0800, Stanley Chu wrote:
> Since more and more statements showing up in
> ufshcd_vops_device_reset(),
> uninline it to allow compiler making possibly better optimization.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
reviewed-by: Bean Huo <beanhuo@micron.com>

