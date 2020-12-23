Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A327C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6840A20C56
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgLWI33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWI33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 03:29:29 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF57C0613D6;
        Wed, 23 Dec 2020 00:28:48 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id j22so21694095eja.13;
        Wed, 23 Dec 2020 00:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOvsdrMTBeh+0VgWngn+23DuawjliOPcgqQaj1GbRKY=;
        b=DIKBb/BUNSgro3YLF+P7soDLRNBMrBtdteYuQb14lgDvYCKS/ge1o6u1zEHW0BN9JI
         cghO6l/Run/1lyge+5qq+OuqwtQRoA+eh/wMZR8yddT8hvoqv9BCD8hwV+Of729kyZJF
         8bXcpum4J2rE8SklE2KH8FFiN1PZFghxOUEP6IqQbKUkDmGJaWvXXcfKp9LyNwM2nnB2
         y6xLMXFHg8gUh7VwdL/blGZMg+E9GXEgG4rBP+930WPW77iX4v4uYhHEIuL16MWPrs+r
         +PoS3z2eednzSkahv0bPZexLS1ehpTMNlf0XsVg+0TCV9SGBMWFzX3Ptm1mgMw/ZedZZ
         6kQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOvsdrMTBeh+0VgWngn+23DuawjliOPcgqQaj1GbRKY=;
        b=h8Kv1jI2OXvuqMXwytEVvS2BGC+7wLR/JImWqYGT/f3kY2xVYkaHTQI9CXir4S/UsJ
         Ug5aa/dv/nN7F5F9t46dJWlMw8g6D/TfXrOu/dM+dJ5OQXTcyc5GRkM+EfFbuUOodLPP
         9AO0A0aDHJMSUjKtbIL5PFYh5XMPt+CKkaYZ4oUXq69o9RHhdo8Ek7qMq+AzGJjhtDPf
         6QAsvebQYoR41jMiokDhDfPeDi7Todfhsy6b3mFZNqMWIm3Xm/fuUXgR46eZ4eE5FvP5
         h/svNG7KTNqUrQFlUgi/9EUdmDqUslJFuJdp7Ijyq8wt4hDJnhBOJRKOiLC4nx70HqId
         2pbQ==
X-Gm-Message-State: AOAM531PQPwbveY0v0gx2RZ6XgMQYwDZzck8njxqUqnJsFYk0gwzI43g
        bHyoKkwP8UEl8IzaMMGo7VM=
X-Google-Smtp-Source: ABdhPJzba+QgayosWbyCokQxYLM3wIJswYeIWFvwSMMTL1kAlBUJ6ZoGALd4bXXBUkb1tnG1XW2CGQ==
X-Received: by 2002:a17:907:d9e:: with SMTP id go30mr22395664ejc.488.1608712127247;
        Wed, 23 Dec 2020 00:28:47 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id ca4sm30369009edb.80.2020.12.23.00.28.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 00:28:46 -0800 (PST)
Message-ID: <9ac61bb53d1f33797107577f66aefe95e3e35bb9.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 09:28:45 +0100
In-Reply-To: <862483add1462510b809aee6d3678435@codeaurora.org>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
         <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
         <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
         <28211d08700d1e4876a9aea342e8fcb79534cd2c.camel@gmail.com>
         <862483add1462510b809aee6d3678435@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-23 at 09:31 +0800, Can Guo wrote:
> I don't see why removing the sysfs nodes during ufshcd_shutdown() is
> a
> concern to customer - we should do whatever is needed to protect LLD
> contexts from user space intervene. What do you think?

The sysfs nodes can be removed only when the device is remvoed.

Bean


