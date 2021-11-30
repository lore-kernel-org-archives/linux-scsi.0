Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32B7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 15:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhK3Pn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 10:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhK3Pn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 10:43:57 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8BFC06174A
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 07:40:38 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso19863216wms.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 07:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nqhuFDsnKkXRDBD2VkYSTunv9kP+Et39ou1k8Mq4Y+8=;
        b=NHYCWCLodTGiZBRXtkksO+9f1IGkfW+K/54xJTf4QHyMfaUQXmBq1eKy3Co9/MsCeg
         M8eyQmrhlIZAps3ir9vh+Cs1W0ghawJ3N2asOO25/429B8gNsKZThr/qF1XXuwju337D
         z4S2fkMOb5+KH1DLSy/1iXih3plROx4mFhwJfrhUffIx6QLz5Xx5jRnDx6jEnPqtrY7o
         mfx6uKON0aFh01e95HlDREOsHa5nCUU3s59pgZpHOH3KuHkuzoVyIaoYH1brtP7FkLJ2
         6DA8nAZaYmrh7BknicjuYTUweFj4a8nDXu477XykfdakxZqqgzBhD6Lx6zS2wBx6F2Yr
         PaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nqhuFDsnKkXRDBD2VkYSTunv9kP+Et39ou1k8Mq4Y+8=;
        b=kRXnv53O9i9Z6DzAESysQeDZcILyfB5YoK39hlFeNrbi2xLBxh2M8YStRQ295P/c9Z
         w4jrCgnZa/Ex9Xe1PA1fc06syO8rkbW+LYONcsa9M+WIxW3d3m+YyotbhFCMw75d8HO6
         xVdS18n78I1qr7UMQagkEPQHABxAK0E7eqH2F78qqUAaFWv5LG0tEawpocEERYvdsCVV
         5iqPkCEc+iqvpPbCY+204CbPr8F5Qmj0STm8dEF73+QCUR5t00H3bsCZrr72HEqhyb1+
         oJ/IJ+U4Ygx8vHL1f3dcdorhTOsCAZD7ePf5BfazMjey/ZDwt7QXRN45PBSKKclcoxZG
         6P4w==
X-Gm-Message-State: AOAM531+JRDCq6dpOBpqwTXnhyyYVwJH3z8U4aaT1++AYE+DwtIezYfK
        eiaI+SPF78jE+pFy3M0x83I=
X-Google-Smtp-Source: ABdhPJyP5t1DF+WoiL/if4a9sOp5XXpCttRBciHtZGWUzoPI3q1wdId8914BqmUlS7DtX6RP7YD1Sg==
X-Received: by 2002:a1c:6a04:: with SMTP id f4mr242155wmc.56.1638286836777;
        Tue, 30 Nov 2021 07:40:36 -0800 (PST)
Received: from p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de (p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de. [2003:e9:4719:c91f:5d9:3518:15d7:236e])
        by smtp.googlemail.com with ESMTPSA id c4sm16775520wrr.37.2021.11.30.07.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:40:36 -0800 (PST)
Message-ID: <952443760df360b48a153c01b1dad957cd82fdea.camel@gmail.com>
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Tue, 30 Nov 2021 16:40:34 +0100
In-Reply-To: <deeb660e-d1ef-7a54-6221-45cfebd87881@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-20-bvanassche@acm.org>
         <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
         <deeb660e-d1ef-7a54-6221-45cfebd87881@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-30 at 06:26 -0800, Bart Van Assche wrote:
> On 11/30/21 12:43 AM, Bean Huo wrote:
> > On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> > > On my test setup this patch increases IOPS from 2736 to 22000
> > > (8x)
> > > for the
> > > following test:
> > > 
> > > for hipri in 0 1; do
> > >      fio --ioengine=io_uring --iodepth=1 --rw=randread \
> > >      --runtime=60 --time_based=1 --direct=1 --name=qd1 \
> > >      --filename=/dev/block/sda --ioscheduler=none --gtod_reduce=1 
> > > \
> > >      --norandommap --hipri=$hipri
> > > done
> > 
> > For 4KB random read, direct IO, and iodepth=1, we did not see an
> > improvement in IOPS due to this patch. Maybe the test case above is
> > not
> > sufficient.
> 
> Hi Bean,
> 
> Which test has been run? Polling is only enabled if --hipri=1 is
> specified
> to fio and --ioengine=io_uring is the only I/O engine on Android that
> supports
> that flag.
> 
> Thanks,
> 
> Bart.

Hi Bart,

It is the test case in your commit message. If iodepth=1, there is no
performance improvement. Increase the io-depth to multiple, for
example, let iodepth= CPU core counter. I see that the interrupt
overhead is significantly increased when the request is completed, so
IO_polling will win compared to the interrupt mode.

Kind regards,
Bean

