Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF7C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 17:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E0664DC3
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 17:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhBORML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 12:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhBORLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 12:11:21 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD556C061756;
        Mon, 15 Feb 2021 09:10:41 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y18so8911093edw.13;
        Mon, 15 Feb 2021 09:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWbg4DdogtY10SwmZ8bb0CjcoeVc39azJNWP/xOX164=;
        b=puO2K3XWd5kb9NbElyzyfrAMT2M3zd0UhnUTNNEsw8FKcGLucfIpjz1ueg1z2zJjzb
         0mIwkXHVbAYdgpDVN4T9sLutpaO5v3ERaI/aXta/Cf0BujlCKyitHjzUlh0l9/mj9iD5
         Stap20ZTAOumCy+UqeLM3bbENm0/VdjQYB7HbLcq1AG0TQQkJcL4jZvcf3FepvLNQbIA
         6s2iR6dmLkrQ6m6dfx3QWCippaEq2BleVJKTEaw0MfPzSWTBf6SpYgXwsCw0q10NlQ03
         ex3QfAgY9W2TTnFTinz4knB++5tI8SwXWz+cGlh0iBygoiX1PtzsROSBGOtMJYKnLz83
         aDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWbg4DdogtY10SwmZ8bb0CjcoeVc39azJNWP/xOX164=;
        b=CCBOtyEWXvNsnmbvn9A0T3OnTAHLCe/8GzSuU7Uks/Q0cMiDlAJdXYlywnQupXWOmw
         W1JZt3pbuLsNRCtE0PNiWe0aqaJt88721ZLMq94Kh4qlBZr3YnCCWcHV361xmHHZ5d4P
         i95qPbRUVZE4ywEbzOxji2CZE8ck9XdgyF2Lj4miBo3GXc1hZ44ic7gFC0vdR0s8zOdK
         j3k42VkbzcB3WiEOU7elD/Fk6Cip7ckXFGsVyB1oYWXpunzgKmYhdWp4verjRB3rwHIj
         44E9Dd2q8Nty81gnv7/eYmx5AvrLHdcG/dkSSyQIgouk5HEQu7CV57VtyvgUnk36wh5G
         2f0A==
X-Gm-Message-State: AOAM532dy+Yyhv5DL7Lfqi5uvtN9sXZMCjC2M73loL56HaaKnIXctIhb
        IVOY+zAdBZtwB553Phy0IO8=
X-Google-Smtp-Source: ABdhPJxq/Z3u6ekwwlv5xWqUgmffSZrAWiyR+7ogVmEhnbl52TS0gaV5eSYOGO4vbJHVxoQ+XjEG7g==
X-Received: by 2002:a50:9e62:: with SMTP id z89mr15972050ede.79.1613409040460;
        Mon, 15 Feb 2021 09:10:40 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id df15sm10585308edb.24.2021.02.15.09.10.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Feb 2021 09:10:40 -0800 (PST)
Message-ID: <d00dacbd2a1b57dfdecd184303ab2bee47f3d7f9.camel@gmail.com>
Subject: Re: [PATCH V2 4/4] scsi: ufs-debugfs: Add user-defined exception
 event rate limiting
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Mon, 15 Feb 2021 18:10:39 +0100
In-Reply-To: <20210209062437.6954-5-adrian.hunter@intel.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
         <20210209062437.6954-5-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-09 at 08:24 +0200, Adrian Hunter wrote:
> An enabled user-specified exception event that does not clear quickly
> will
> repeatedly cause the handler to run. That could unduly disturb the
> driver
> behaviour being tested or debugged. To prevent that add debugfs file
> exception_event_rate_limit_ms. When a exception event happens, it is
> disabled, and then after a period of time (default 20ms) the
> exception
> event is enabled again.
> 
> Note that if the driver also has that exception event enabled, it
> will not
> be disabled.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Bean Huo <beanhuo@micron.com>

