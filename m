Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EFDC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 05:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiKRFnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 00:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiKRFnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 00:43:13 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F33370A23
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 21:43:12 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id c1so6513404lfi.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 21:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PknBuTZr0FbgH0swf5hFiHuXgYTaMvN22ZAv7CpcJ8Y=;
        b=Z+j1JGrIcXFWgvLfYoL2pm6aQ8Ilb6U6izVwzYosCWSl+RpUe1YftGgB1bwBbv9SR0
         5k+PdvTBml+yMs2N18073QvPvL9yw3GdDAOZJOppxOVNPrW+XAnLZdkoKxdQoyXQv5xU
         Oi8dYWTr5IWBB1pkQW/7nMlHLlpQZW9Nt/+s52bVpyo5kgAoDAzqjnNX7fYBDn9GU9mg
         4Sp88iHeBfjuM42Z2Dd3/ZqwBCI63QXpmUsu+4G8VCVZD4lkqTEPW0k5TrAqCGLpnKbt
         0syavJCcT22PuWL0m2zFyJbnQ2xZ5qu3FNBYpoFv4pFF6f0Lc3oTC/6VtMRHmJl4dvSA
         6JlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PknBuTZr0FbgH0swf5hFiHuXgYTaMvN22ZAv7CpcJ8Y=;
        b=OrD7scYMed57/Z6tUHSqRYMGsXaCKa3ew49IXYdt4u7qvJZbFxS3Un1H9hvDfyV5Vl
         jyITaOHwM16winBO+FSltl5u+RAMnzRt3n3qbfyR7HU7a3THZn3CneTEM2g0AJ0upIRf
         ud8RYSt5se5vJd7P+//89VPBqwIVU1x4G1a0ane3faztaUqjtcWq5rfju5jhW2ny9lLC
         gnLbui/zJWBLsl9iJ68k0C5IJUTbUY0kO8UVrFBd9BBRUabXUDIucjeq9GbyRD06o2DE
         JbYxHu1eLlBZYb9sOFOVcuglLQ2A91dYyOj7Iyw6Uek0i36W98d4q0YznE7oZjJWy++6
         MpiQ==
X-Gm-Message-State: ANoB5pnj5/GEGK4O1hQDE6OIex/XHVt4n29HKk0/K1L0rXo1YTxZrSsu
        4GrTJHoh8jH25jgg9mXNBhcIC9An16q0MQDhig==
X-Google-Smtp-Source: AA0mqf4StMWwt3iJHTzVw0CF0Y0XvqTbQVw98z8nfJyQ5d2bNSU0LmbrgYKxcuOfjY4aurPEwf9wV1sJ+zGHmI35kKk=
X-Received: by 2002:a05:6512:3f10:b0:4b1:5463:a55f with SMTP id
 y16-20020a0565123f1000b004b15463a55fmr2172729lfa.215.1668750190785; Thu, 17
 Nov 2022 21:43:10 -0800 (PST)
MIME-Version: 1.0
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
 <20221118045242.2770-1-cw9316.lee@samsung.com>
In-Reply-To: <20221118045242.2770-1-cw9316.lee@samsung.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Fri, 18 Nov 2022 13:42:59 +0800
Message-ID: <CAGaU9a_uRWrQfVQjOh_KnfhQJvwkx_0G367t_R3audP0B6nVow@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 18, 2022 at 12:57 PM Chanwoo Lee <cw9316.lee@samsung.com> wrote:
>
> From: ChanWoo Lee <cw9316.lee@samsung.com>
>
> Change the same as the other code to return bool type.
>   91:   return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
>   98:   return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
>   105:  return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
>
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
