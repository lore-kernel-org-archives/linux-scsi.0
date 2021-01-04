Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42348C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF1D2068D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbhADRkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbhADRkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 12:40:24 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC5FC061574;
        Mon,  4 Jan 2021 09:39:44 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g24so28189806edw.9;
        Mon, 04 Jan 2021 09:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I6Fmai3zxtRYkoYSzql1sEjwGD4yMJcjICTRzVZoSG4=;
        b=XHi9fG0JM7wjCNCC+2uqr8ydAy9xl8fTKKzr9MYKsOVI+9tqSi5EkbGKquDWosiDSk
         0fxyISqSyqT31sTh2Fu8nYlStj5elIpEA9IrlDrnpp2puqQox0NGuAhKVdx7ibSWkH4A
         2qSO/dTl2Km1KgiAMatTALvdrv/q8A3FSQfML1HMi48JFHUJWLtgfwEUvcXm0piqfawc
         vgoPOBCq0XqRmU2ocaJB4xBCXMjzd0Bk1EkN1zsUUPYc3s7WCim/ZzmpGaoYfT2vf01z
         qxAiyFBk7BVrCsRB1EJVIm/1hCA3AU13xUdKeHUfvf0wLa4sNuqXb32gUsnsLrx7L9oI
         ORrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I6Fmai3zxtRYkoYSzql1sEjwGD4yMJcjICTRzVZoSG4=;
        b=UkgUhkyz+4mUYEv0hfa8sNo1+9NFttdMa6+ZHs4C9abGrHu9/VcmrUWLKFi3hmScS5
         JQJgxJbfy7En/LZcse/QWd6qmQAjWCvGvJnXb36D4FkTsD6YeDYcdUVd6z6ZvfoWZsDH
         OUOqXHiPRHhiN7wvXofVL/6xdY9BjBLqNYbhTns7naIAw2ry0AVPATKUU5oeiugVHq7+
         wYuFJHzJzawvYAgwv+gnutc7nvxI9Q3r8HewceSHq0KIJy9aazdJYx93zY6Ob70OZN/L
         QxLBdeeifz9iwhaKeAaAdD06/II0PlG2hUDfGrPXqZHhbBYMUc7a4vi3mM0+AGibYXOY
         7z2A==
X-Gm-Message-State: AOAM533dMB3d8sKSRCAidX54bddMC4+Df7RG1ea9m0U4HOkYggceLYRw
        eS1ZQFbxVrjOF5uWzZSYiYI=
X-Google-Smtp-Source: ABdhPJyCYeDZtmeDPmcqu6V4GVPrkrNDMBdCJXVMeUB5GQNgmZmD+W268eHtWjmhNdJ6pabIy6hQSg==
X-Received: by 2002:a05:6402:388:: with SMTP id o8mr71654176edv.359.1609781983363;
        Mon, 04 Jan 2021 09:39:43 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id z10sm23668771ejl.30.2021.01.04.09.39.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Jan 2021 09:39:42 -0800 (PST)
Message-ID: <dd3a0f2e8c9688f98b1c5a3c843db0570e4da139.camel@gmail.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Add handling of the return value of
 pm_runtime_get_sync()
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Date:   Mon, 04 Jan 2021 18:39:41 +0100
In-Reply-To: <88069c938a06b06f89cc4662cef3c1be@codeaurora.org>
References: <20201224172010.10701-1-huobean@gmail.com>
         <20201224172010.10701-3-huobean@gmail.com>
         <88069c938a06b06f89cc4662cef3c1be@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-28 at 09:50 +0800, Can Guo wrote:
> > The race issue may exist between UFS access in UFS sysfs context
> > and 
> > UFS
> > shutdown, thus will cause pm_runtime_get_sync() resume failure.
> 
> Are you trying to fix the race condition by adding these checks or
> just
> adding these checks in case pm_runtime_get_sync() fails?
> 
> Can Guo.

Can,
thanks for your review. Sorry, I didn't quite get your point.
This patch is just to add checkup in case pm_runtime_get_sync() failed.

what else should be added?

Bean

