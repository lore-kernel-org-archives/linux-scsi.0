Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA30C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60ABE208B3
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K0J3+9yh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgICQvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 12:51:51 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2391FC061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 09:51:51 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h1so1621512qvo.9
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=TeEkZiiDU8H/pW7dAcYbmu2YItXU/SZN3mESrsbdhQ4=;
        b=K0J3+9yhWexOuRsRaCWXXGL1vYkhG3N/pBt5P9iIEa9EWEPqx1ZcLPUwLkWuxg1fcW
         cO4HU2kGKOn5YrfQeiTuioWsQym+l2N18kC8DCaqx/CYyX/dkWbmw5o6Hc5qp1SC+sC1
         Zmh47bbUwZvtM0ge6dOh4zS2550z3k/y+T9Hs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=TeEkZiiDU8H/pW7dAcYbmu2YItXU/SZN3mESrsbdhQ4=;
        b=PjjsiF6OaYqTWFoBZ5YBcUEbLIaWp08uU0BBEK+9aVfAXfG6y0thPe37be7lDK2w6P
         HvgIHT3gVGHVmpZ8isaNeK+WIPSpwVE15pQdRnF+asPHtlo+yaAUgL4EgUepnkNN0nev
         ivQJzhufPXWLEqZj2pTsbO6fwQ/ho7EeFeb9QzLCwjc8G2ouqIPuVYYLSw2PmgH1HSaR
         AFnz8+ciSgy0lA00OdbnzCQkp4XHLvBxY8p7d5FWWxGzjOtSFzAu4MiYaU5LZRMeRYYW
         yC9keqwjkK+dY3V8ehDHiMyu3bNVxSv7JyA3juLTwbtzyrAj0m0YPA/N6np8ikWz5SCL
         1lBw==
X-Gm-Message-State: AOAM532g/35ZtgqGVdm9PLtHze+cLjwasGoSb8fM1OxQyHJFaNIXI9Hp
        +iuYPDMfUViAh+7jEnAg60z4YRZh+aeUSHuz8vI/GOpoXZU=
X-Google-Smtp-Source: ABdhPJzjieSzqPdGzKgH9uvtuxgXsHmWsCRw+kupX0t1m94BhBq/5BsNfoYizAjP2Ary0dei6fdC1VoLscLEQsBYhPQ=
X-Received: by 2002:a0c:ec11:: with SMTP id y17mr3834014qvo.72.1599151910212;
 Thu, 03 Sep 2020 09:51:50 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
 <f006b12d-ea59-27d9-7766-6d4039487714@interlog.com>
In-Reply-To: <f006b12d-ea59-27d9-7766-6d4039487714@interlog.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFXkOchWQrPHD3VTz81ROsL+5VbowGVEghOqkhYx4A=
Date:   Thu, 3 Sep 2020 22:21:35 +0530
Message-ID: <b0f358ce47cdc34ba2cc55aba33f3e37@mail.gmail.com>
Subject: RE: [RFC] add io_uring support in scsi layer
To:     dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > megaraid_sas and mpt3sas driver will be immediate users of this
> > interface.
> > Both the drivers can use mq_poll only if it has exposed more than one
> > nr_hw_queues.
>
> Perhaps you could add some comments in scsi_host.h about what the
>     int (* mq_poll)(struct Scsi_Host *shost, unsigned int queue_num);
>
> callback should do. And you could implement it in the scsi_debug driver
> which
> should have all the other hooks as it is part 15 of the shared host tag
> support
> patchset.

I will add supporting comment in  scsi_host.h.  I will also add scsi_debug
support and include it in my next patchset.

Kashyap

>
> > Waiting for below changes to enable shared host tag support.
> >
> > https://patchwork.kernel.org/cover/11724429/
>
> I'm testing this at the moment. So far so good.
>
> Doug Gilbert
