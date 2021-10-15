Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F72C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 686286120A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbhJOPQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240842AbhJOPQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:16:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84CC061570;
        Fri, 15 Oct 2021 08:14:25 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634310863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JVzk7Wa/jMbuTbH5+3LVxNUlhbhJgVSboKsnYOECFqE=;
        b=O4QVslOsnoJIpHdVt4nDkOUgDCmlx3yuJGD3s3izKlZJvYcSEU6GMu9JnqWQiqzBKNgeD2
        Kg+fW+gmupCYRDQYrj2R4Qo4cSbiJf6VEKASHzrrRatku5NP43Mgz+GZWDBOt+DR6Dh/95
        0sLYrTwS1yZ3bDEvfBxxQ7Ts/KCnPxW+FKv8Y2HevLt5WnU7FC5BevBHg5RXeBeXzr8B80
        mNrfYCNEzcuwVPsNGzm84m03XS9VedKgivweOoS2hdx/yOwinmjfQWlwFuNQAT2wm7AVU2
        ByQUmGN3CfMcI43LqwMG7zeqpvpozpEcRtQf28mVTucKMHm9F9PXLKWenYAQQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634310863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JVzk7Wa/jMbuTbH5+3LVxNUlhbhJgVSboKsnYOECFqE=;
        b=kgDO2iX7Ul8JtzhLFs3Fa8p9czh3ABjQxkWidVvhv69FHl6+NJmfYr+cmNwfj0GHCJ8eAP
        e1C/HMRqNtJnQXBg==
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/3] blk-mq: Allow to complete requests directly
Date:   Fri, 15 Oct 2021 17:14:09 +0200
Message-Id: <20211015151412.3229037-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a follow up to
  https://lkml.kernel.org/r/20201102181238.GA17806@infradead.org

where I *think* we agreed to audit driver which complete their blk
request from process context and then let them complete the request
directly instead going through ksoftirqd.

This series converts a part from the MMC layer which completes the
requests from kworker/ preemptible context. It was verified with
sdhci-pci device under normal usage. It also converts the usb-storage
driver which is slightly complicated since it goes through the SCSI
layer.

Sebastian

