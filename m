Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E841C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 13:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D549A207DD
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 13:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtKA38Il"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgFONfy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbgFONfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 09:35:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6633DC061A0E;
        Mon, 15 Jun 2020 06:35:52 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q11so17181780wrp.3;
        Mon, 15 Jun 2020 06:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MDMIhrPCOKcrAndBvYfcPybYXdRjufTM858g2lxGDI=;
        b=PtKA38IlXmGkHf4e76zkzGjseXBXiyB0que/eRK62p/+VjCpZqUzwnuRxTpam3e12h
         aCCWe7JRQ7ZwVdAFdEdLeX0YZyEMoegG+0enO3VIbkjPKdRS5M00SChY9NSZ2gHnvWLz
         rc2KzPKeD5z/LuvE2TLs5aztcc1Lp0toLUu4BQnqgCNu8NUVSPKjQxhgOMXmtZYZwik2
         wFxcwL0fCXQmRPN6J6+h1yAt8flScEGgfk8+TKCdj0sUFBIXTclUE0TrRsH2oA3bTOnE
         8nT+xmgSt+YZkHnO+kEolx+gPnivmu6MigKO7ZyGpy0ixv1ME85k9v/Jv5SLd2cFZxeJ
         x/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MDMIhrPCOKcrAndBvYfcPybYXdRjufTM858g2lxGDI=;
        b=cHXU0izO/2LyeOP+0I7pVGUGoYarB+Kp7H59/O+PJ5Y59vGOuWoEqkN4FaVtEzw8c3
         +syAz4qnZ8H4E+wJniytygz3Y150gzGJUpPAVb8POOOsCsYf4SLd/NCz9vU7OZADzaNM
         NnOtjzHGqBwz2UB290XQ5VInaeS3r+hZRzTbLMF04sE4Jwmx+gXyIShTXnBvcRZ6+Af/
         lEpKfPlo2WiTX95rvpLX32d7Jrqka8FtpiC6vgPhZQJLPx+C1jwaAJ5iwdcXQdv7+8uR
         zdP1zyx7cN41VG0Bw1n4Vrxwl05TmjK5XHdJtYlSYyw9e/PIWufNK1R60LNWqrgyzpth
         +e+w==
X-Gm-Message-State: AOAM5335TYGoomlXcj/v9lShesoU0F2tlNIdeeEJXUHUAEpzt/8iOAou
        Wd2ophigE9TdjX5LoWsT5dA=
X-Google-Smtp-Source: ABdhPJw/0kS/YFup5n7E9GygoPpuywlZOlbQnFyenieDAVdig7XWxW3ZXDv/2q/g85j7CNxtlQJ3yg==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr31141470wrt.56.1592228151178;
        Mon, 15 Jun 2020 06:35:51 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b10e:413b:41dc:307c:ea47:9556])
        by smtp.googlemail.com with ESMTPSA id u3sm23247094wmg.38.2020.06.15.06.35.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 06:35:50 -0700 (PDT)
Message-ID: <078bb71ddc9cda4454d213333afa4b6a905b8b09.camel@gmail.com>
Subject: Re: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Mon, 15 Jun 2020 15:35:47 +0200
In-Reply-To: <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
References: <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
         <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
         <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
         <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
         <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p7>
         <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun


On Mon, 2020-06-15 at 18:30 +0900, Daejun Park wrote:
> +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
> +                                 struct ufshpb_req *map_req)
> +{
> +       struct request_queue *q;
> +       struct request *req;
> +       struct scsi_request *rq;
> +       int ret = 0;
> +
> +       q = hpb->sdev_ufs_lu->request_queue;
> +       ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
> +                                         map_req->mctx);
> +       if (ret) {
> +               dev_notice(&hpb->hpb_lu_dev,
> +                          "map_req_add_bio_page fail %d - %d\n",
> +                          map_req->rgn_idx, map_req->srgn_idx);
> +               return ret;
> +       }
> +
> +       req = map_req->req;
> +
> +       blk_rq_append_bio(req, &map_req->bio);
> +
> +       req->timeout = 0;
> +       req->end_io_data = (void *)map_req;
> +
> +       rq = scsi_req(req);
> +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> +                               map_req->srgn_idx, hpb-
> >srgn_mem_size);
> +       rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
> +
> +       blk_execute_rq_nowait(q, NULL, req, 1,
> ufshpb_map_req_compl_fn);


HPB map_req is now being en-queued in sdev->request_queue.
This is ok for the HPB v1.0. Have you ever been thinking about
changing this way to directly issue HPB requests to UFS?

Actually, there are two reasons for this way:

1. Latency of loading mapping entries is lower comparing to your curret
approach.
2. Also, it is preparing for the HPB v2.0.  After all HPB 1.0 only
supports 4KB read, this is useless, I am looking for the HPB v2.0.


Thanks,
Bean



