Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E42AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 16:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443994AbiEFRBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 13:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392317AbiEFRBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 13:01:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558006A076
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 09:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9F9B8377F
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 16:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432A4C385A8;
        Fri,  6 May 2022 16:57:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f3FrHx2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651856266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=VejW5MMh8OR8WrrAp1ATaywvP5WjqvCJGUCCUek0vFs=;
        b=f3FrHx2dac6fI0xaZR5cr0RzjvaTCA+hDGjtsa+yQuKDCHVeIdyiIMTpup2srB+Vs6c8sY
        N/37wwXiFXP2Fi2RsU4/sapNrv2fea/4slVWSBb7XaIKfS2xHR7zs78pAqD+xfJ1EBpUCu
        at4GZ7KGi4yNRLViIREhVpYogbNCzgs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d3d88bef (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 6 May 2022 16:57:46 +0000 (UTC)
Date:   Fri, 6 May 2022 18:57:35 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: calling context of scsi_end_request() always hard IRQ or sometimes
 different?
Message-ID: <YnVTf+vkcLl2wZZE@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey James, Martin,

I'm in the process of fixing a few issues with the RNG and one thing
that surprised me is that scsi_end_request() appears to be called from
hard IRQ context rather than some worker or soft IRQ as I assumed it
would be. That's fine, and I can deal with it, but what I haven't yet
been able to figure out is whether it's _always_ called from hard IRQ,
or whether it's sometimes from hard IRQ and sometimes not, and so I
should handle both cases in the thing I'm working on?

And if the answer turns out to be, "I don't know; that's really
complicated and..." just say so, and I'll just try to work out the whole
function graph.

Jason
