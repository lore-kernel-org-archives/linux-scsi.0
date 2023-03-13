Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08193C74A5B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 07:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCMH7J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 03:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCMH6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 03:58:15 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DEC521C1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 00:55:58 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id AA2732402E1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 08:55:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1678694138; bh=aPvc8/JGlkSwmnQBUBFEPAwFsKT4TVuWfr/u68w7xiw=;
        h=To:From:Subject:Date:From;
        b=qk4PRHXtYqTqScVFEhsD2JUSvZzl+SGYa/FP366JpeB+eNFExG3jdyTJafKjXIrj2
         U329EeWUga1AYt1SYRGQari+xLF5mh6TaJKLKZj8Yw4JIi76TjJbyQpCaKXssGqtoK
         5PiqeVXbFGhp3L4KQ/2T+jFP4T/PbAmQYC/EMpZYiXC1xoT58y5NzeqQonzWzglOA5
         wphnkQheD006FI4oFykCI36gP0FUU807ivt7+aUCa0pTzFb1gncoxgOx4tryv/CfCK
         vzJacVfRn+ye/lHC2YDaGv0bs2R0VpsUvaMyFphs+Ag2LyIstOczRtazhkmnpL5tK3
         Lo5WOJhnH4QUw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4PZpqZ2NWfz6tmH
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 08:55:38 +0100 (CET)
To:     linux-scsi@vger.kernel.org
From:   darkpenguin <darkpenguin@posteo.de>
Subject: Force ignore LBPME bit by using quirks?
Message-ID: <2162608f-7515-bfa7-9a5f-047495713eed@posteo.de>
Date:   Mon, 13 Mar 2023 07:55:32 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Short version: is it possible to force ignore the LBPME bit and use
UNMAP anyway? Maybe via quirks?

Long version: I've got a JMS567-based DAS from Sabrent (DS-4SSD) that
has an, um, "weird" firmware (they've tweaked it for their reasons, and
now it even refuses to reflash). It identifies as 152d:1561 (JMS561),
and does not have the LBPME bit set. However, they say that Windows
ignores this bit, and works just fine, which is why they never noticed
the problem. So it's definitely actually supported.

I've seen a proposed patch that enables the same behaviour, but it was
rejected for obvious reasons:
https://www.spinics.net/lists/linux-scsi/msg95062.html
But in the bottom, it was suggested that this might be better
implemented via quirking.

Is there currently a way to force UNMAP on this device regardless of the
LBPME bit? Was it implemented by quirking? I would prefer to avoid using
a patched kernel, and I'm not even sure if that patch would still be
(correctly) applicable to a modern kernel.

(Please CC me, I'm not on the list.)
