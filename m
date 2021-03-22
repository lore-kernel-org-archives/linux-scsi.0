Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C250FC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 09:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786F161929
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 09:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCVJL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCVJLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 05:11:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDCAC061574;
        Mon, 22 Mar 2021 02:11:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id l18so10148811edc.9;
        Mon, 22 Mar 2021 02:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=rt8sUmmGg6DRuuy6vkqqcgcTqYqiVw67z58kK2mPk5k=;
        b=OatXRRt/5h2y97MmXC+3D/inte/KkcWSBr6mitISgSZTerBDbKFrna0w3LK3+9je9m
         SN/aekaNnGmfoiNCW/u5OtsBccwoZN5m9snV8cIXVqvOigyJk5ut6BDlXr7SsgRr1okY
         Upnp6Lheh8GNI/qBiL7z/4HZYxaKTZZHEEp6Bd3mh1k0+3HqMg3Hb5ijJ+Rq+7uGeAzZ
         tA0zb2eHD2QDPLFixOk3qk/rCDSZms7q4MvCHMjPVVkW1L//T5mQ8rjj7/Ov3FFmw7px
         X21pgC6rh8Cwowi3zrz3GYn9YkaAXYi6mq/0BxMAxo5KMqQYZMsq4dQrj7H2FRjfbI1l
         oR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rt8sUmmGg6DRuuy6vkqqcgcTqYqiVw67z58kK2mPk5k=;
        b=pcvQN2v6j7HdFCgB3eYl9sbokHdv4GRoHQaCLwhp9k00j54fLW5eAKx8+Ez1Y5k0IL
         ODjGbRsXnDKdJ0cPdnhL0beKohCeTYBntSiwFkUBktXKYX7lYMDa5C8N+YIdy+APVIDp
         tMBijRzKMW45u1xj0TKv+UNv0eOxyRbWI9/rSmbBqPS4JW520PT1d9Q4uB0wyxN0iqjc
         hiTAq38YyZEEMgtU8W6gS8r6aBzYKC6ier0VGTErfKOjyYHnGhrdzai5TtQmhyQ3p3MJ
         uZjAN4G9vqOefeYIbm1n/dVjokeJtFt2GFYSNzajS/XkFEImAQ8M5UVcFA7ar/cKOwgP
         GnNQ==
X-Gm-Message-State: AOAM533i4bpcWdKVsQa3S3PeVUJRkyueJYP+ioywdavQLgpALqA7q9VJ
        n+4DBsrdseQBFOCLh1shDIo=
X-Google-Smtp-Source: ABdhPJxbY7BWtWRsIpMstJfo2w4ibAysqWUtc+AlKq05EqWMM+k8lOjhI3T1DzmcPV1qyDuQ9MtBOA==
X-Received: by 2002:a05:6402:484:: with SMTP id k4mr24154841edv.321.1616404309849;
        Mon, 22 Mar 2021 02:11:49 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id cb17sm11095458edb.10.2021.03.22.02.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:11:49 -0700 (PDT)
Message-ID: <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
Subject: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Date:   Mon, 22 Mar 2021 10:11:47 +0100
In-Reply-To: <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
References: <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
         <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p4>
         <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
> +       switch (rsp_field->hpb_op) {
> 
> +       case HPB_RSP_REQ_REGION_UPDATE:
> 
> +               if (data_seg_len != DEV_DATA_SEG_LEN)
> 
> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
> 
> +                                "%s: data seg length is not
> same.\n",
> 
> +                                __func__);
> 
> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
> 
> +               break;
> 
> +       case HPB_RSP_DEV_RESET:
> 
> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
> 
> +                        "UFS device lost HPB information during
> PM.\n");
> 
> +               break;

Hi Deajun,
This series looks good to me. Just here I have one question. You didn't
handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS, how to
handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
reset host side HPB entry as well or what else?


Bean

