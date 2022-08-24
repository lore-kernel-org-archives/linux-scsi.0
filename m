Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9527FC00140
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Aug 2022 09:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiHXJgv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiHXJgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2022 05:36:31 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844D393229
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 02:36:26 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-334dc616f86so445260017b3.8
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aqKb1J0sUYKRxFSx8BTKcr3FtUOkogBHLhJ4EzMaqDI=;
        b=frLiu8gAjQ0kpxVUy9iux+0KZBGaas40KedmyZg1S18F99UNtbnKu4hhRcDttjsiJd
         0CwO3QisP0/EAOdV209Ke7wOk79MP83THWvb1oOu8ufAVd3wpqg8eBBxrJaXcD7lG8M2
         QCkTI9ixDBfjW6AfbuxNQqr+KvY7jj9h7ZgpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aqKb1J0sUYKRxFSx8BTKcr3FtUOkogBHLhJ4EzMaqDI=;
        b=W4MuBuBt4MyUgjuPWUnu0ZcIFhs7IFU5bxBa2aJ0U7VVwG+54Cb7unj5uYp85lEtMp
         K3ZhOxNn+HriBz0KXnioZ/HFUUymvZ9lCArUro+CP+idyn40X8dzed56tUbagmqE9e6/
         WRk6suINY+rNsOKjuwxfWldX+kSeCeeooKf6ctl1C6oPaxzQCWyhkTRFL/BRmKmwEts5
         3P5pUe1k4LNOq+3QU3p1C2AB0+cIq0+K8NjSzEvxT1DKBN4YWezmGkoVp9ynHm/+aC7J
         7CMyt3xt/T4L1F4GJRkGRL8grUm55LrkWMIxo1wGx1BDlFMzE6ObpRj7dN2/apYZ6qs5
         VtNg==
X-Gm-Message-State: ACgBeo2K+UnOfGbjuk8TRQK6f58OdZcnAF1+OrMM0K7y1+j1J6TPeBDe
        mcsZDspxBGAxLiygv40XRQokfPGhTEzimrwQ7J7oAg==
X-Google-Smtp-Source: AA6agR5u4zZdD5BUdh1+uP1ur82Idc4dh5due5UwgX6YLLUPiWMyvuRnCFUobBbL4xkzsp3eJyxT/mfgO5BtEv9ddcc=
X-Received: by 2002:a0d:d897:0:b0:33d:1aa7:2425 with SMTP id
 a145-20020a0dd897000000b0033d1aa72425mr11107499ywe.224.1661333785427; Wed, 24
 Aug 2022 02:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <1655727966-31584-1-git-send-email-Arthur.Simchaev@wdc.com>
 <YvBK/8yeohLhu2Za@google.com> <BY5PR04MB6327431615BFFFD735EB2502ED6B9@BY5PR04MB6327.namprd04.prod.outlook.com>
In-Reply-To: <BY5PR04MB6327431615BFFFD735EB2502ED6B9@BY5PR04MB6327.namprd04.prod.outlook.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 24 Aug 2022 19:36:14 +1000
Message-ID: <CAONX=-cXDcekWznHf6h1WwtJfELyFxSPAZ4bnA5t3xOrmUQZ5Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs-bsg: Remove ufs_bsg_get_query_desc_size function
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Daniil Lunev <dlunev@chromium.org>
