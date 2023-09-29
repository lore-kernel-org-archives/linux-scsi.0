Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB08AE71D3F
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 14:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjI2OPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 10:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbjI2OPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 10:15:08 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E53CCD
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 07:14:52 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c1807f3400so9077751fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 07:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695996890; x=1696601690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZgZNblR8SfW/4R6oKkon9JEl6qDNJGO3vXwUsdRVac=;
        b=lAFSeihK5Ty6eHtvrh3T933s3pDr5A0RlNFP0StRyv+KSaxJl26j0XW2fuC4O4CHfP
         w5/7crFUW8CkhERyodtf+LePZiktBCWIzRz+PM4vMcbG8hZ2Q2t7dWe7Cc8LfE0IBqL4
         HtN2JDjq0MdJVQITYWNwrlS2oLZzXm9+ZKVjIv4fKyegGML+2kcgviIWb7YlR+U+2h5A
         iEXdWbGufZHxlA+JcTsD9ZPCeOlPKlnkc/TJI78GysONDnlWQOUF8q979UBrm1ebhjjF
         J0QD5Qzv9x2bnvhs87GwqUiG1IjUKx/+YXAuyS2h0W318W1P45790H+5Qo0RLv+z1k8h
         a7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695996890; x=1696601690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZgZNblR8SfW/4R6oKkon9JEl6qDNJGO3vXwUsdRVac=;
        b=o6yLb7VqqRGcdHWmxotR2WEn1a29glKstcHFo4Vc2OXKhUmPzyUXC0VDbpNkkXO9uO
         ATjE3UMFsFFz5d5DBdCYEZysQSSh84iB9RFt1mcjimuwCmcWhZ5MW9Cvsofa9XztnaXK
         tm5WzBIyC8S8gmqb0wIYDh0AlFpIo5T25FA4wH3EvHaueIAefSfMvBxA856O8F7m1mZX
         elAbAwWLj5QkmHyFer7TMEN9P2G0Jjmo+DFD0cBnJfEJI7T2YaY8DyWBRAuoZfIbXlqE
         LE6x6QZPalx5nyXvw+XMY4g+IPyqzNxyO+GCUcOAi5HfO4B2ixe68kWaECNUUBAnPllE
         sRtw==
X-Gm-Message-State: AOJu0YytRjVvfrk/CkarEfzKUu7QxPK9pyLTLHfScVeCG/R5TRMhin7v
        GPe8UjdHswuFYYH3kNpuwH+UYvkHt3GYDtdgdg==
X-Google-Smtp-Source: AGHT+IFEO1axz8htxJf7NY8ey6tqW/VBV1n2cJtYGQXzDfYk81LF0OT2GNAX4KPv9SIeFxDYtngf5+bJLsUGJUE0yJk=
X-Received: by 2002:a2e:b4b9:0:b0:2c0:b37:a1cf with SMTP id
 q25-20020a2eb4b9000000b002c00b37a1cfmr3443644ljm.22.1695996890212; Fri, 29
 Sep 2023 07:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230927033557.13801-1-peter.wang@mediatek.com>
In-Reply-To: <20230927033557.13801-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Fri, 29 Sep 2023 22:14:38 +0800
Message-ID: <CAGaU9a_0Xu8X4ouRbygquEXhLWb_4KvKQAnUF+XTWVE0MdhpJA@mail.gmail.com>
Subject: Re: [PATCH v5] ufs: core: wlun send SSU timeout recovery
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

On Wed, Sep 27, 2023 at 1:43=E2=80=AFPM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> When runtime pm send SSU times out, the SCSI core invokes
> eh_host_reset_handler, which hooks function ufshcd_eh_host_reset_handler
> schedule eh_work and stuck at wait flush_work(&hba->eh_work).
> However, ufshcd_err_handler hangs in wait rpm resume.
> Do link recovery only in this case.
> Below is IO hang stack dump in kernel-6.1

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
