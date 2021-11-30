Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9D2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 09:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhK3JTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 04:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhK3JTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 04:19:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0C2C061574
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 01:15:41 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d24so42918061wra.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 01:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qQ4btdS4J4N8LHcyJiJ+SGdaoLUftlryn54ErkSj5GA=;
        b=okFZG+HgWbwLb+xNIkcxkbCA5KKHe0nhPJ1Dmj9N01AxijnQbj6XxFjS5SgDdUyw3a
         p74Up4i/TtI8l0vljosiELqD+0axOrajWVusC7e9x0f/RTMQ3L2NnS01LUjlY2svzI4Q
         dQmcJ8ywIbsF/344+hqr9VOSNGfbf8AWyloAnk3gNcjoEEPkHNYNYdqcp2pwwCtV6gIC
         R1FnRo1WjX9o9L7pLBwlwRWbcOiwdQ4dvx/NVO8tFJnrWZU3YlZp191a7AdxEYW3JTyc
         aOnsEhAe5S/iL+NaA5bPz50BVnFfN1JDFpOoa4ndETiedbkyPnuCgTEoZkbH/rg6JfL8
         W0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qQ4btdS4J4N8LHcyJiJ+SGdaoLUftlryn54ErkSj5GA=;
        b=mX1/1EjeNCFtVH19Y0hoqsD3B8ZRD3i4CFXR/zvIClyAqyxIV+FYR/EYG+g25k325x
         nB1wDhXFniJdksYAUDdSFzztcFBuwcprThdAEIFZgAddrYvtsjTKK/WjU5h28tOUf4P5
         fBnVEM2i2j8TO2HiekRklt2RZ0P+QaJc9n4ZnuVV4OOPyXKgG3z86HLK9SoS8Rsaor0Y
         tXTsVPlt8hj+iObHaPHhiPG+f7OT2bk/3l4MfVH1Hv4ZhxXiq5zGDm/ley3iA2d6Bs/g
         joL5AwuetRBQhP8dw6Ni9k+DrFeXPeuU7RWt0I00LSWNG0eZVJBvraRxIRKg2ueZdkQg
         /1+A==
X-Gm-Message-State: AOAM5316vO0mOhGyZ62GmJSZA70OFTYk2LdnjNdlX8PuIi18UEni2tmI
        LTHBg5AiLMpTngWyvTL7uhI=
X-Google-Smtp-Source: ABdhPJylAnD+S5gr9k3M26fzROLFhAWskkW+kS4XhX83JtFM5nBKyTsjw5VFhtsl1XmwmPzRHSD3Pw==
X-Received: by 2002:a5d:4ccc:: with SMTP id c12mr40539956wrt.453.1638263740490;
        Tue, 30 Nov 2021 01:15:40 -0800 (PST)
Received: from p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de (p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de. [2003:e9:4719:c91f:5d9:3518:15d7:236e])
        by smtp.googlemail.com with ESMTPSA id v15sm16032545wro.35.2021.11.30.01.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 01:15:40 -0800 (PST)
Message-ID: <4793d8498d00ab34008bb9f5beed8ad4515168ff.camel@gmail.com>
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Tue, 30 Nov 2021 10:15:38 +0100
In-Reply-To: <DM6PR04MB657536D64FBAE7FB4D32BF9DFC679@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-20-bvanassche@acm.org>
         <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
         <DM6PR04MB657536D64FBAE7FB4D32BF9DFC679@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-30 at 08:57 +0000, Avri Altman wrote:
> > 
> > Bart,
> > 
> > We look forward to the support of UFSHCD polling, I did a review
> > and test.
> > comments as below:
> > 
> > 
> > On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> > > The time spent in io_schedule() and also the interrupt latency
> > > are
> > > significant when submitting direct I/O to a UFS device. Hence
> > > this
> > > patch that implements polling support. User space software can
> > > enable
> > > polling by passing the RWF_HIPRI flag to the preadv2() system
> > > call or
> > > the IORING_SETUP_IOPOLL flag to the io_uring interface.
> > > 
> > > Although the block layer supports to partition the tag space for
> > > interrupt-based completions (HCTX_TYPE_DEFAULT) purposes and
> > > polling
> > > (HCTX_TYPE_POLL), the choice has been made to use the same
> > > hardware
> > > queue for both hctx types because partitioning the tag space
> > > would
> > > negatively affect performance.
> > > 
> > > On my test setup this patch increases IOPS from 2736 to 22000
> > > (8x) for
> > > the following test:
> > > 
> > > for hipri in 0 1; do
> > >     fio --ioengine=io_uring --iodepth=1 --rw=randread \
> > >     --runtime=60 --time_based=1 --direct=1 --name=qd1 \
> > >     --filename=/dev/block/sda --ioscheduler=none --gtod_reduce=1
> > > \
> > >     --norandommap --hipri=$hipri
> > > done
> > 
> > For 4KB random read, direct IO, and iodepth=1, we did not see an
> > improvement in IOPS due to this patch. Maybe the test case above is
> > not
> > sufficient.
> Does your setup contains commit af1830956dc3 (scsi: core: Add mq_poll
> support to SCSI layer) ?
> 
> Thanks,
> Avri
> 

yes, that commit was mainlined since v5.13, and I tested this patch on
v5.16.


