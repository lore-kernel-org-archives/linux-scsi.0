Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94680C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 13:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B23020EDD
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 13:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGGOZ4O0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHaNek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHaNei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 09:34:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C7C061573;
        Mon, 31 Aug 2020 06:34:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d11so8455854ejt.13;
        Mon, 31 Aug 2020 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8GcnX02giYXdZ/RxHybOYa4+sVruRRxorMeqsk/TQCk=;
        b=QGGOZ4O0RRDhLLBhcIWkF4selDYedgjgBwmFZefkhwkgFPW69QApZd6Xe9lEi3z3Wu
         qlunSZr4e4pnvgwQyOzm18Gf83nQlTifrQUajZaREdHEgkpCB4NlyBAdtmxnwcnFi5ea
         NJXv9bGN1DnpYoUqTx5Uaodao9fUNh03Pw6wOQBew+6hC6gfkRWkvJmBsL/e5yTMxvxn
         wq2OVbv61Jp5NkmX6DRTksPy2GKxh4Vg6CJ3O5gCgalulhh3dkk45I0a9nCF+h+wSD1w
         malhRijnmH8jh6ypRaBmucO9s6QjNbmfcN/k/+V2s2/EsBGF1/tbNhAittIflALlUDkO
         nu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8GcnX02giYXdZ/RxHybOYa4+sVruRRxorMeqsk/TQCk=;
        b=tXjEUK2eCTYWqGweCmIz704FBcxh0MWXP8K8KWsSHH4XdeJv2klrZWfuA39ZgFtmyl
         vlsQygR5o8xtObfwuhJdaOfzIKOf57GmRjxyb4zsmK40fzBuZIK8RF/nRpgsj4AkAJRZ
         fyrhhxfedoWrmo9XODeYzuOMOKZjKlq5QMEyyNbVLMwQn2zqo/k1SCIee7MZTJ0EruG0
         zysRwIZ7a88UOX07kKNBN9kcgsn7hXWappDR6RjKGS7BOJMEqNdAABgQjfWV4w4VFJw5
         qO31SPjgYGRYSHTD4O5swCbs8xRxauojZafXBsCITZNnZptMrPC3MDdm+ZOIpRg0nXzg
         JuTA==
X-Gm-Message-State: AOAM530VMylLstYX5veHv/cEab1MQc8A4Y8L7XmaJ5kJw8IOOy/I1NsR
        8b0OeLD7oR991xGt7dP4VwXW9qcZY1tS24ia5iunDlqrX3SARg==
X-Google-Smtp-Source: ABdhPJzGS7uMIR2j5ikMu1m2rX3E0IdVw7LkXrZ5SBIV6NJs9csiD8cvFJr3MYcyv27oEKFz6BkTrZYO3ReoslJUcvw=
X-Received: by 2002:a17:907:205c:: with SMTP id pg28mr1163295ejb.22.1598880876175;
 Mon, 31 Aug 2020 06:34:36 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Dionne <marc.c.dionne@gmail.com>
Date:   Mon, 31 Aug 2020 10:34:24 -0300
Message-ID: <CAB9dFdtALXb_51QiY1t1Tbng34gA4wBHQGwk4w8Fttw-ko05Ng@mail.gmail.com>
Subject: "scheduling while atomic" BUG in iscsid since commit 1b66d253610c7
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The issue reported here:
    https://lkml.org/lkml/2020/7/28/1085
is still present as of 5.9-rc3; it was introduced in the 5.8 cycle.

When the problem occurs, iscsid crashes and iscsi volumes fail to come
up, which makes the machine quite sad if the volumes are critical to
its function.

Added CCs for iscsi related maintainers and lists suggested by get_maintainer.

Thanks,
Marc
