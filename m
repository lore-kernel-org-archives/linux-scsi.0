Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193FAC2BB9A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B93CF224B1
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLOKAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgLOKAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 05:00:35 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3BFC06179C;
        Tue, 15 Dec 2020 01:59:49 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id b9so1847109ejy.0;
        Tue, 15 Dec 2020 01:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VWi9lvVrtm8vqGMgMBrAESVz3nZujJvYtHJX+Z95Jw=;
        b=BU3TGKZo/XOQEoIXFdM1P4n5pKuFdlZOTA9L9qx7LtQH7SwLjsIr91Lh2D62rpj55c
         EWPTM+17jHVlpH03T1FiYVU3aoB0qGWcmgcMddTsRXfGOCiAqmHatqHekDpHGRZNuhZ9
         ZIdWBfa0eyefu6LwH14DJ32NYmYNTP5d5mCH6/Q6iV6FV2CBMiQ6+Ane2hUIkbfiFMuZ
         rChIQhdBPXgco3juca1zpha87LxNHpOxgRP5j/Pg/zZ6Wp+Cx9aSZOxaDrMA5SLfDXej
         1VW3cEqVlPzc8GlE77ozLxNuwDZkpquc2fsN/5b7jxvHsUjtLJldTeHNwPpNjH9gSwVP
         tf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VWi9lvVrtm8vqGMgMBrAESVz3nZujJvYtHJX+Z95Jw=;
        b=fee8ny3n+TUXSvDILpT+cD8JdU3sPdEoNCrg1HHhIuOmO/k5GVMsM0hZi/GoTdCAdV
         Hz8ck95AdCO5ZEdGY8sgXtlIgIWt/R03vMdnuC41QfbZvumZg+s9q+AFXuFcdOyQrY+8
         E2L5BksHIot0sSjNPCwhpQZ4KuNpd4fiVC+A//dGOo3IUfNRYOzsy4ET2TtIcHaTLmRU
         1IvROr7fK82Wi0N12EIbpS7dl9wNqe7BZI8+pomVG36YtFV+v3wJMbLiGkp1CsKx84wv
         TY7hW09jOyQ8zRnx7owiwKSeTXsuynC29GOXkA35my3d6g2PO1ELHmMNhGl841ttN1BE
         rmWw==
X-Gm-Message-State: AOAM532UiTLXFHVSNsn3S/SiS6szrcEWPHG7/sk/ZsNKwWjh580AMxop
        ieH7iCRRYnv3d933YeQCV8Q=
X-Google-Smtp-Source: ABdhPJwCxl4PpHeih2wMXniKYALjSkU03AHuXby+xZvV9XFwppfN4g9J2/HbB6WB4YNYszHZSJp3zw==
X-Received: by 2002:a17:906:8587:: with SMTP id v7mr25524315ejx.381.1608026388125;
        Tue, 15 Dec 2020 01:59:48 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id r24sm17708914edo.4.2020.12.15.01.59.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 01:59:47 -0800 (PST)
Message-ID: <277a6fd2dd3b3e70a0caeda6283214ed5152aa65.camel@gmail.com>
Subject: Re: [PATCH v4 4/6] scsi: ufs: Remove d_wb_alloc_units from struct
 ufs_dev_info
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Dec 2020 10:59:46 +0100
In-Reply-To: <1608022638.10163.14.camel@mtkswgap22>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-5-huobean@gmail.com>
         <1608022638.10163.14.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-15 at 16:57 +0800, Stanley Chu wrote:
> >        u8      b_wb_buffer_type;
> > -     u32     d_wb_alloc_units;
> 
> Perhaps below two fields could be also removed from struct
> ufs_dev_info
> for the same reason?
> 
> u32 d_ext_ufs_feature_sup;
I thought twice before this patch. maybe will be used in near future,
so I keep d_ext_ufs_feature_sup. Now that you suggest, we can remove it
as well. 

> u32 d_wb_alloc_units;
This patch is to remove it.

Thanks,
Bean

