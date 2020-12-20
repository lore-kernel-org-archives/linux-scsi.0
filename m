Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D970C3526E
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0610F23AAA
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgLTUhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:37:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35038 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbgLTUhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:37:37 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mVVnukOOl2W/Eq1oKRWiFcFrNnar7Wbbj/7qOdPasNo=;
        b=TIqrOQWMMdVka7aYTf6oXbf5HRP2W5AQSGY/p7VY2oVx37VYJijfq2J/APrR4QiyrhDzUK
        8DpY1lS9/TDOW7SBFnMreKIZjCSHlTreu7sUWwMY3kR4PRtnWGPNL0+R6mt51KTYn2wML/
        L/fHhGAwieYO5PKp1Q18khOmtJpMX05N+oFWNErA6bugLgZ5z0Zv0qYkG5Hd+TmmwowZlH
        oWi5xBIsKzhNhylNPqdSf5D8Yxx5zs5i804Q/HO5VJd0GQMy1cllMRqDIntx9RgDTS65HO
        2j2HCEcRboTFm3rKm9w438YetQC+EoL3V1Fey2yQ6t7gh9bUuz2DxF1/3tEfHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mVVnukOOl2W/Eq1oKRWiFcFrNnar7Wbbj/7qOdPasNo=;
        b=YJkFz5YU6TkGurJEH36ZcEPBXz9ywhW8o+C6ihQ4GCaFZd3NtZ2/493FtkbmmcYqbFRaPs
        VGSVi3BCz/tr4TCw==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 0/6] scsi: target: Remove in_interrupt() usage.
Date:   Sun, 20 Dec 2020 21:36:32 +0100
Message-Id: <20201220203638.43615-1-bigeasy@linutronix.de>
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

In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
driver code completely.

This series addresses the target subsystem.
Most of in_interrupt() usage is debugging. There is one function which
either invokes wait_for_completion() or schedules a timer based on
in_interrupt().

Sebastian
