Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C7DE8FDC4
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 01:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbjJDBcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 21:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjJDBcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 21:32:00 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A87B0
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 18:31:54 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bff776fe0bso18143451fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 18:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696383112; x=1696987912; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtgXwyXGb2bi1jhVkZotMHTKIP1cWrsqyGVuQzeEo2I=;
        b=QeD6B8GarogQkw3z9QxkYQG/QzaSxqqfVGuDRvDmYfK/tFvOwskFR+Z+XapqTHq0Pm
         Jn0N5kUSKiD3LPqtGWRr3F14hfwoH1hUrXS032WUaFpESzH/fODznfxr7Iajhu9zBAUG
         edpSpD/JbKY1MF4oa65klvY3MnFm3sT/FVVeYNr2oXZoDTo0V/KN3Qs/pwe5zBGl/Jok
         3oS2pQYWVhrJYahSMDd/VlZV63sn7naLESoXDgnfyFmpxxTpbRJQFuKqG/dtVx1dR9Yg
         RugfqlBdVBhupdiP4fgh34qycxtajvbm7itXrYamwKJkULyAin0dNxVOlPfnnKGrVnwM
         QV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696383112; x=1696987912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LtgXwyXGb2bi1jhVkZotMHTKIP1cWrsqyGVuQzeEo2I=;
        b=QLbK12PROMqm/4O18PsT60UwIGih+iH9LEzhDwqa8m5AeQ/LHMpbsOOWG+5Ix+TXbV
         /aW/reh+6x/rDF5ey+x7McyF61et8Zwm9EZJ+6SGIB+Rdl5q6A8VAdyP9AZqfdTLeqM6
         Vj/+vGxwLP9v5acuXN7854BjDk72DTQEPtyAgpqyxVbT8PuvbXhCx7gz2Mqv2lF8AA4O
         SqpEk4LRc9DxdCETDhv9EHhs7l8fIt0GlKPsM8UXX/fDlcPRB6WLF8h5mN1fCVeo60nj
         x62Uk/UMKBLM9VyzrcrcIBhsi0z0KAbTJNh+l466oirf6vibw6SVJapzseY96U2Oa+3C
         upjg==
X-Gm-Message-State: AOJu0YwsIBzSzqY8rEoI5ka5So/R/7CF7pO4I6rPsS1DM3Vknr3LSVVh
        dqdawrdVXeKd5xEul92eaQTDeCDVTrc+japvk+8vQK4jMA==
X-Google-Smtp-Source: AGHT+IGMEx30pecyH5eeOV8Fty5foMoStxfIj8LgwrA4eKoEVBRS2moxsuXLaNu/rZsEb1P8LuaTwT8pqmVF9UoUwp4=
X-Received: by 2002:a2e:8507:0:b0:2bc:feb6:6da4 with SMTP id
 j7-20020a2e8507000000b002bcfeb66da4mr782282lji.33.1696383111909; Tue, 03 Oct
 2023 18:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231003022002.25578-1-peter.wang@mediatek.com>
In-Reply-To: <20231003022002.25578-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Wed, 4 Oct 2023 09:31:40 +0800
Message-ID: <CAGaU9a84pAWG83EVjAJxZsvDW8T8d+UyJuHXKP3XbKQwkkZjdw@mail.gmail.com>
Subject: Re: [PATCH v2] ufs: core: correct clear tm error log
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 3, 2023 at 10:20=E2=80=AFAM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> The clear tm function error log is inverted.
>
> Fixes: 4693fad7d6d4 ("scsi: ufs: core: Log error handler activity")
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
