Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F393FC74A5B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 00:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjC3AxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 20:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjC3AxG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 20:53:06 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7054C2F
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 17:53:04 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id br6so22457349lfb.11
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 17:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680137583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E7xemqptwLripvftPpiPZ5BxGFjDwXLXsFzH7aXhh2U=;
        b=hC4AcC9jdetH7b0GKc9T3Em4dPVXm5nMjhzBNG7GhQfECy8fbHp8+0fPh7bJgAeXyr
         eD2bl8L+Ml+O/GxhC4hncaZUGABwpTKHDn/kQNHILypwqyz3er4Zh4SpeJlyJmWjn235
         fjCIVIdsQYvME2m6UnMh+ZvM47Ye/Vsg4eHbMm8ZlYbXWCEoHmmAll5UPNw3NUya40A9
         NDpihs86Vm7zVLoW/ilaWNQIbtB6+uy5nNMf+xl34TbJkwMmZZlVaeNtxKxkY/yPrmxf
         3x7OO6JTy37BSrQ+6g1+5k9Mh8IiayhrUMIlZpmO2s8VEMMzYMJPb/WYXmJn60G5zidH
         /uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680137583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E7xemqptwLripvftPpiPZ5BxGFjDwXLXsFzH7aXhh2U=;
        b=3yRgVTeOlBTEEBMk1FQLaMKj/QwbD2oSlth6JisBlUAr3SMphQULA0dLjA6i5rhMdC
         umbYQ+bktuYXFsXar82gm9KFV6uMChiAojKg0q6018aBttGXKglhl/x217lmnYV1YdHN
         dIrcta3wjdbllorE9slr6zaWyzErK/yTQLTlrzblMZ/ax4uVhJx9KLVP2uAP16qbPdtz
         lklMmeOwdFAVMV18Ac9O1a6FKzYwLz2p9VJAo1MBkRMOozR7+STHu34eqOZgRPcCbbuk
         dk14lN/5giIZLyTGYvAyqTwnOVdwHcvVOriyqn1HhNqNO6alFie5U4Saugci5L0qaT0D
         ivfA==
X-Gm-Message-State: AAQBX9dqvz7HiQwPGIjlXYvnypFeslXxq8IvFlmyOlnAkVEwZoPp3GRK
        lWkrzQpxQe2X9zzlL+VY2+54Wesnjrvo7x3fUQ==
X-Google-Smtp-Source: AKy350bLbwPS4AEgFtkJ8c7i8BWUJhZyt/Vv9TML/juIniBLTQ6PZOxhSOh6XBS+uyoZa+sg0hyl2DmD2jLeX/EdWYY=
X-Received: by 2002:ac2:4473:0:b0:4eb:eaf:aa00 with SMTP id
 y19-20020ac24473000000b004eb0eafaa00mr4109347lfl.4.1680137582629; Wed, 29 Mar
 2023 17:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230329205426.46393-1-athierry@redhat.com>
In-Reply-To: <20230329205426.46393-1-athierry@redhat.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Thu, 30 Mar 2023 08:52:50 +0800
Message-ID: <CAGaU9a-Mf3MmSO1fvazNCCFLjA1dboT7obBCQG3uP3VfgJBF6g@mail.gmail.com>
Subject: Re: [PATCH] Revert "scsi: ufs: core: Initialize devfreq synchronously"
To:     Adrien Thierry <athierry@redhat.com>
Cc:     peter.wang@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrien,

On Thu, Mar 30, 2023 at 4:54=E2=80=AFAM Adrien Thierry <athierry@redhat.com=
> wrote:
>
> This reverts commit 7dafc3e007918384c8693ff8d70381b5c1e9c247.
>
> This patch introduced a regression [1] where hba->pwr_info is used
> before being initialized, which could create issues in
> ufshcd_scale_gear(). Revert it until a better solution is found.
>
> [1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+=
oen-NZ6Otw@mail.gmail.com
>
> Signed-off-by: Adrien Thierry <athierry@redhat.com>

Thank you for posting the revert patch in such a short time.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
