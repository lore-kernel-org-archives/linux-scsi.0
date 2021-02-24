Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E88C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B94764E90
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhBXSzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbhBXSyf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 13:54:35 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB329C06178A;
        Wed, 24 Feb 2021 10:53:54 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g5so4779681ejt.2;
        Wed, 24 Feb 2021 10:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3j5rcn1/ytvH1rXMmsxxfFA9wVspHf6qKNPviAA8jPk=;
        b=WQhUat5ETrJQMlm0raxJi9u7wWAklGe8nfLDSUrkZIulKsgCAbz4QFa+xWfEv+eYR3
         48W7q6rIRkGV1JrV4xtt7UBxhaDmlOkM5OQh5lYyePrvZRrtdiOiBtYV6ecA2pKojmpC
         Y0E3wGqyvzIhi/adkv0dwXfOypIzq+EXgFLwQZN/rZpq1e3X8Mx2rNTTCcsAjddKiNLD
         1OGlhIC/nSoLl5g05KYHL8uGKUJOa9WAyl15LNBd2IxWxpMnNkqUfhFoSEo+6PfvPBid
         9oGsAzhpImrHorqPIyVAm7h7eHX4fB7BEvrcdMcwVYBPSIzz1clFjMd60WfJ5ECgKsWe
         m/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3j5rcn1/ytvH1rXMmsxxfFA9wVspHf6qKNPviAA8jPk=;
        b=hEZOuYL0BnMrYCJDQ0EzlLra0aLzUg163pE+Jp93y+TKy+W8iSwx809TYhdC9YJlVt
         VB56gq41/UUL0qlT6dyJ/ooaM83Ge+m+Si+y3JPjwW29SqFLLh/v+mxnnFtZu9QTJo6F
         8KehhgNIg1wKyj0D0WPNAOSCFsgIp8KPCde2mjb4eI5SEh2r7ICY6E+Yl3JJ0ShDXd+p
         JapQkVoEUOaV9E6M+DXiDmKJUnXw6LlKTRdHwQ3EzY19AWmBEWqWDzdoaefiMQaI29ng
         Bh+1mJVCkdqrY8TdFlmT4pCu27G+9A23gW/Mxtt7Zsnay3prrdNkF/MvOSCYHuujoY0/
         QwvA==
X-Gm-Message-State: AOAM530gFSs0e/BbwhUSfqzSIR54uOHCOP0YTF1ihshyZuFpx/00n8Xu
        fsm8H1zJg91jkntoTx0wHEdVcyAXEdg=
X-Google-Smtp-Source: ABdhPJzvBDmUMNq4KJG4fhMGlpDGCvkLLkFbdZfGHyf/Ok2SX6ATi7PIw9h8ViihDw032Tfh/r6l1Q==
X-Received: by 2002:a17:907:d0b:: with SMTP id gn11mr32012430ejc.144.1614192833658;
        Wed, 24 Feb 2021 10:53:53 -0800 (PST)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id cb14sm1748047ejb.82.2021.02.24.10.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 10:53:53 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with XArray
Date:   Wed, 24 Feb 2021 19:53:33 +0100
Message-Id: <20210224185335.13844-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series is based on Martin's for-next.

Future patches will need something like the - meanwhile removed -
radix_tree_for_each_contig macro.
Since general direction is to use xarray as replacement for
radix_tree and IDR, instead of re-introducing or open coding the
removed macro, with this series we switch over to xarray API.
Based on xarray a future patch easily can implement an analog
to radix_tree_for_each_contig.

Bodo Stroesser (2):
  scsi: target: tcmu: Replace IDR by XArray
  scsi: target: tcmu: Replace radix_tree with XArray

 drivers/target/target_core_user.c | 64 +++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

-- 
2.12.3

