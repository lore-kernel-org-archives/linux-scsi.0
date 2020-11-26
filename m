Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C71C63697
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A569221F1
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IZAPLh/g";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+R2H2APu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbgKZNaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389545AbgKZNaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED31C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 05:30:12 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gKWNXrO69ijmKr06RgReA2B5m0/QsKYm+ymsyZGidRw=;
        b=IZAPLh/gPNV9SPkRo5yU1iTFK2/RrPlGshE5xGaEscU4ZuVttcZeo8LCMhGjngrzr6Z4Fa
        RjhoNwUG3NSiIaZERsAQOJzWNFekPczy4i6MGab1QY2E98qwzxeF7hvMi03qV4a3FRsR/s
        7gBn0v66mzB6Hky27bu+XAThgaiUNGfKbQXkIN0Ko4nan3q9+c5rXv0zCzG8FwmCtB8Aq9
        d3niDoJvLMkOGWxvO5scPZynOgG39NbvfVTsMZKdzr5XPCZiqIhU9e9l6feac7WntRLVlL
        HaXm6UApmSErfYhI+rgP6gl9evci+6xqtIazLqZYBCIuijSGv0lE6VXp/tsuYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gKWNXrO69ijmKr06RgReA2B5m0/QsKYm+ymsyZGidRw=;
        b=+R2H2APu+AeyvL7q0xCnCAAFOiwwYoumjtb91uMyFvik8JqRH5A+Ow4NjnUvqyNBVPrC/S
        iP/Qh8jpnmGsU8Cw==
To:     linux-scsi@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 00/14] scsi: Remove in_interrupt() usage.
Date:   Thu, 26 Nov 2020 14:29:38 +0100
Message-Id: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Folks,

in the discussion about preempt count consistency across kernel
configurations:

 https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/

it was concluded that the usage of in_interrupt() and related context
checks should be removed from non-core code.

This includes allocation mode (GFP_*) decisions and avoidance of code paths
which might sleep.
In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
driver code completely.

This series addresses most of the SCSI subsystem.
The first three patches have Fixes tags and address bugs were noticed during
review.

Sebastian
