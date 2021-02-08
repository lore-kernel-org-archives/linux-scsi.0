Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919C7C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 19:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5778B64E5A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 19:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhBHTJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 14:09:45 -0500
Received: from vps.thesusis.net ([34.202.238.73]:49328 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236038AbhBHTGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Feb 2021 14:06:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 41BEB2BB8F;
        Mon,  8 Feb 2021 13:55:03 -0500 (EST)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AwFOTC24NVD4; Mon,  8 Feb 2021 13:55:03 -0500 (EST)
Received: from debian.iradimed.local (097-068-109-042.biz.spectrum.com [97.68.109.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: psusi)
        by vps.thesusis.net (Postfix) with ESMTPSA id D793D2BB8B;
        Mon,  8 Feb 2021 13:55:02 -0500 (EST)
From:   Phillip Susi <phill@thesusis.net>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [RFC] [PATCH] LIO: Add emulate_removable attribute
Date:   Mon,  8 Feb 2021 13:54:08 -0500
Message-Id: <20210208185409.35907-1-phill@thesusis.net>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patch adds an additional attribute to the LIO confgfs
allowing you to cause the disk to report that it is removable.

It currently works but to get the sd driver to register the change in
the removable bit in the IDENTIFY data, you have to tap the delete
sysfs knob to unbind it and then trigger the host to rescan.  Is there
a way to trigger this when the attribute is changed?

I noticed that the attributes show up in configfs under the fileio
backing store rather than the disk lun, which seems like the wrong
place.  Why is this?

Also targetcli does not seem to know about these attributes.
Shouldn't it?  Or did I just miss it?

