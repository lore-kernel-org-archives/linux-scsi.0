Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AB7C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B9960F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGZTjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhGZTjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 15:39:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66A0C061757
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f22-20020a25b0960000b029055ed6ffbea6so15353811ybj.14
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GsN8HCqVh5N8aSJwsQzyNpefHB2pESiItXifSlAmSSM=;
        b=gJdCKTbk2C37vKwDcBCzX6vy3NgrJaCdDO8ylX4jL5Efkl2THEgpciZ+Gfqpi1pNu+
         uz26sJGw6z1vPs7dtWhk3sYsIs7+y9MTiHK5v5yI865S++oSd16Nctp8n7nUT3Zj8zzi
         6QLaLHEEcBGQrCRMx7m+rBZ3I//g9e+H6PPfSwhHOcYcQS9yh5jeI/vbv5ydjBavNrJj
         YRem8g5HR3BObvLbZY4p2i6KNKemqng7M1oG5CxGQFLuez26dnrjalCM9GaZH58s/TzH
         7JwmhrgZ00ztjpGMEkzhVpegunGGT7RAb+M41Lv048GixgOjdctrvQDap6++zAdAeABt
         zxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GsN8HCqVh5N8aSJwsQzyNpefHB2pESiItXifSlAmSSM=;
        b=AfdnDWVlbTGnYa813gRfMD1/0hxHeHds9xbl+D/OKs8BomY+iB0ozewtrWYLhV5/of
         Q3mtpVGmxa6q+YTqAE9/WIHjS1jfcfBvhPu/9FJNZDNOjQ+3WVWziKgU0x5RUGvr8odV
         6FgtxU/CkCB+HBaA94yqyFEXoW/3TbF/anZ7TpZpc8LquyJO7nHW7WFVx4q6WNXaGlTc
         KFU9u5PQO+8hpgimDXjPpPMrCRsCXzcBpjF4Nex9z7IGZckctaG7z9zsQq+focMCQtYw
         m82sunTCXKmoy/VyZP6UMGE5Ryt+akiBkRdgUAXxDhLdAZRjwJOv/glyi2/ahkj7bHc8
         anVg==
X-Gm-Message-State: AOAM533/2lqxUxiKuAAchni4d3Fc9qOONrQz9U3h7rr1R9U8/LQBKJ6p
        bL+WfBV/3VErk3/Gf/lGZ0mVcfuL
X-Google-Smtp-Source: ABdhPJyOQYwh3EiuCdUYc7I7SF9y2w6LHgoEfYxWl8nVzf1ebeI5lLJPSEbw4ycEaE0y5KP0ZO54TwepYg==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a25:ba10:: with SMTP id t16mr26601022ybg.87.1627330767966;
 Mon, 26 Jul 2021 13:19:27 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:21 -0700
In-Reply-To: <20210714091747.2814370-1-morbo@google.com>
Message-Id: <20210726201924.3202278-1-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 0/3] Fix clang -Wunused-but-set-variable warnings
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches clean up warnings from clang's '-Wunused-but-set-variable' flag.

Changes for v2:
- Mark "no_warn" as "__maybe_unused" to avoid separate warning.

Bill Wendling (3):
  base: mark 'no_warn' as unused
  bnx2x: remove unused variable 'cur_data_offset'
  scsi: qla2xxx: remove unused variable 'status'

 drivers/base/module.c                             | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
 drivers/scsi/qla2xxx/qla_nx.c                     | 2 --
 3 files changed, 1 insertion(+), 9 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

