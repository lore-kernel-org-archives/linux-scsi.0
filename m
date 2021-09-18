Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9D8C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC0561052
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhIRA0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhIRA0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:26:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87092C061574
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F5CQvqD9hreQweDnpQN3SPQ4aOQe/CBf4bwJo9CelZY=; b=nVT8X0N+iOKySh1FmKX23JBfay
        VOVFUsWE6077ieH6Y9fsEuADQg3oqHZX8QN212RbqVBuTRxheWoasTdxGmTP09zsHe3uWhivYIKWm
        Ew+I4XjT1l5v3C3aB7FRE9LSokW6r8aWlsL8Mj2hXXgKItsuqC1E1ePJ53mTTLXEXJVeC00tioFCM
        8Pp4q9tDcvYA5mXWnFf+tA+CCWSdMjizhlJmLz0zbqpcOODpzsSkX78RF2OT0ZeEAxPh8rUcIS6YQ
        HD6PyhUv9/w5V410WkBAlHPEC1ph+X5Hhxpwzw2thyCzv77wlUlM2/ob7zblQwM0wYbJMMrGdG0KL
        qkuzC9Tw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45136)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mROAH-000832-Si; Sat, 18 Sep 2021 01:25:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mROAF-0006NX-UZ; Sat, 18 Sep 2021 01:25:07 +0100
Date:   Sat, 18 Sep 2021 01:25:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 33/84] fas216: Call scsi_done() directly
Message-ID: <YUUx47L7W9qGGOwz@shell.armlinux.org.uk>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-34-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210918000607.450448-34-bvanassche@acm.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 05:05:16PM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.

NAK. I don't think you've bothered to read the driver code to check
that your change is safe to make.

SCpnt->scsi_done is not always "scsi_done" but may also be
fas216_internal_done().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
