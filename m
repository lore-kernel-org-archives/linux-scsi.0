Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7825EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 20:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32ABB22AB9
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 20:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgLVUve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgLVUve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 15:51:34 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A898DC0613D3;
        Tue, 22 Dec 2020 12:50:53 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g24so14190518edw.9;
        Tue, 22 Dec 2020 12:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=13jUuvMm5qEL9dKeZ0BBLqDpiDnKuuirEu90KIY/1jM=;
        b=tAhhMvW2t3knmkTjo+nQ83QlOnFidKfhVLH8x8facNR8zi6vsY5vTo4mPUVWAssA6R
         +2kKGTNyXPYxKSyvFbLKGnJo6HPMLKwaGcC1+3ToJwmxJJ20kANU8k37Z2tqZA/ZsgYo
         XmbkIt+uN+I+BWqHRKj22mTtiQSROB2XpM1A617MF6A2BM4FLBu8XDN+7FADSHvG//vh
         yN3YWEaQvk4RaE/qBMoyMUwNY1BL/aUFQ4gPkg5ci+h3XgE4HVhSTAOe8SrkmYfT1g4F
         SycGl27saEs9HkdQUtOJl4U5aqW7DXwBMRiE4tcL4Ws4FsHhnBbHDm1eSSurPpzW7fOD
         9aVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13jUuvMm5qEL9dKeZ0BBLqDpiDnKuuirEu90KIY/1jM=;
        b=XWx63Xq/FV/PwWbVy+6UEnTNZYpYAlu/1+ONbdWNSrRynKuLPjIjWhiFSR09Z0jz1P
         NfyLzxi7WtwtydcDYDGXaFzLEvhPlcrsu8i5iMyMtPIVaprRaQoCvfIP5n1TMP8AW2hr
         Tf+29C/iBCY5qI4ybJqbTKksbhMvqzAWdFqPCDo42BIF7SQESD4O5cNt/fyRQYl+ujG/
         YQ1o9DSdPPK0iUY/R0bVJ7RR2JEBvPh1KYaWbxj8QSaKpJ6SEnuJnCkRFxCjWui925GY
         gTA56L7V9+hAjSrUpNhskPdCVztVkHwyouBkQiKARTfjx9EXnckFe0qrjrK+c15OTQ5s
         kP8w==
X-Gm-Message-State: AOAM530PkRc3X2zJfyDxnQjnV2R+WVkwexrhM+dN5oqwRBqLWnO77Pfi
        0Z34a/hSQWieaQ1Tm41y1uE=
X-Google-Smtp-Source: ABdhPJxGWuPTiQPSbe/NYoEamwNjTR+C4RDectzRAsxK6LsPIGecGvgaNNRPgkAmcjKV5f8LJY8wWA==
X-Received: by 2002:aa7:d999:: with SMTP id u25mr21693026eds.297.1608670252413;
        Tue, 22 Dec 2020 12:50:52 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id n8sm10810329eju.33.2020.12.22.12.50.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Dec 2020 12:50:51 -0800 (PST)
Message-ID: <4c15956660bd7305b0c095603bfa0e30c7f1610e.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Dec 2020 21:50:49 +0100
In-Reply-To: <1608617307.14045.3.camel@mtkswgap22>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-22 at 14:08 +0800, Stanley Chu wrote:
> > +     if (kstrtouint(buf, 0, &wb_enable))
> > +             return -EINVAL;
> > +
> > +     if (wb_enable != 0 && wb_enable != 1)
> > +             return -EINVAL;
> > +
> > +     pm_runtime_get_sync(hba->dev);
> > +     res = ufshcd_wb_ctrl(hba, wb_enable);
> 
> May this operation race with UFS shutdown flow?
> 
> To be more clear, ufshcd_wb_ctrl() here may be executed after host
> clock
> is disabled by shutdown flow?
> 
> If yes, we need to avoid it.
> 
> Thanks,
> Stanley Chu

Yes, it is quite possible, but who will mess up this on purpose?

ok, to counterbalance our concerns, I can add checkup:


/* UFS device & link must be active before we change WB status */
if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba))
	return -EINVAL;


how do you think about?

Bean

