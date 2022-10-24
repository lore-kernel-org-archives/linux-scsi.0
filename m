Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5BDC38A2D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 14:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiJXO4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiJXOz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 10:55:57 -0400
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D671527CE5
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 06:33:19 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id e18so31235183edj.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 06:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0sMr5LMpx7kn/7s7Sx7ZIZcqCa9AYhMtKw0LeVc+4NY=;
        b=Z/hgfAKaoQy+GtgOeyfqMYXizV03BcSToMv8i8Qk2ps9uXuoyBwf+Ukb21VG/x1cEa
         5jAQUtb0j7Z9HavrSf22TIWPhMbBOKxp+rOMetug5iek1n3SziyoFCnLq0mHJSRJddE5
         2aQf7t6LfdqAgX2JrhHF8e6g34hQI2Wf+1whiFJw+KLsfET9wCnk3uPAmzHErYrDEUbr
         5sir6S5k78hQ3IpfkowQgdrZJ/3EYdgptWiv5Bo/Nl5ZbSqEyZ45YRFhuP0TMxJr3VbQ
         6IQ8d8ZfK3DLYIZNYwnMR3LOuzvs6h3iJNJ7WX0PUL57YCrBoU52VdkWAiAKgpIedwd1
         6tOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0sMr5LMpx7kn/7s7Sx7ZIZcqCa9AYhMtKw0LeVc+4NY=;
        b=roIKtl+2lI9O9o19lzxku03H6S5PXfRNShv63ewZpvm13OJDaGr0pivY9C3md5c0fB
         uZx+vguNYfAszVcJi4achLWxRkwjkEiqhGHt311E/xfCE/DF+KJZy+S9eXo2GXLEnvSZ
         lYwupLNSEsY6HBrRHHvE9SUZuvqr7f3D3ktv1JqgcVL36PTyZBft4ICtnDAg3hY+y712
         PnmeWEZy0WdKAFbAQzdEEjxYqVM6TXByMedLDNJEhfsBI1hAkt4bOs/aZ0AOPmzcCnNY
         9JDRGVVQ9kgIXLZxPY7zOAmX4aKkULADYEOexSSQ5Rarly/4Qhd+qXj/Zp1BLnDn10b6
         Yatw==
X-Gm-Message-State: ACrzQf3qju89Ak7pO/XBmXJ/QbogiJ12+KbzqMv2R2aWTh95GDBxfQ6B
        iLhhNvgu0it99LtCoW4nXRnm06wkfjs4HkRo1SY0NP02+g==
X-Google-Smtp-Source: AMsMyM4xh6amhZ4agKbym874OYc20ETwDPyyOUFqBwR4FwgLL/x9slo1C8nDPcvN6MIH+SPXsukS86XMHKnVJ+Fo2/E=
X-Received: by 2002:a05:651c:1a22:b0:26f:b314:6fae with SMTP id
 by34-20020a05651c1a2200b0026fb3146faemr11276181ljb.307.1666617367678; Mon, 24
 Oct 2022 06:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221024120602.30019-1-peter.wang@mediatek.com>
In-Reply-To: <20221024120602.30019-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Mon, 24 Oct 2022 21:15:56 +0800
Message-ID: <CAGaU9a87HoN1JvzuTAuDFRc8UaLOUfEALyrED2Ke+kH5=zbhFg@mail.gmail.com>
Subject: Re: [PATCH v1] ufs: core: print more evt history
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Peter,

On Mon, Oct 24, 2022 at 9:11 PM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> Some error event is missing in ufshcd_print_evt_hist.
> Add print for this error event.
>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
