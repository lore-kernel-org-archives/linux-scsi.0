Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6894BC77B7F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 17:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbjEKR3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 13:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbjEKR3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 13:29:17 -0400
X-Greylist: delayed 2654 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 May 2023 10:29:10 PDT
Received: from mout6.gn-server.de (mout6.gn-server.de [87.238.194.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD133C2F
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 10:29:10 -0700 (PDT)
Received: from mout17.gn-server.de ([87.238.194.244])
        by mout6.gn-server.de with esmtp (Exim 4.92)
        (envelope-from <lkml@mageta.org>)
        id 1px9PQ-00057b-QC; Thu, 11 May 2023 16:44:52 +0000
Received: from lc0.greatnet-hosting.de ([178.254.50.20])
        by mout17.gn-server.de with esmtp (Exim 4.92)
        (envelope-from <lkml@mageta.org>)
        id 1px9PQ-0003pv-L3; Thu, 11 May 2023 16:44:52 +0000
Received: from chlorum.ategam.org (ategam.org [88.99.83.185])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: work@mageta.org)
        by lc0.greatnet-hosting.de (Postfix) with ESMTPSA id BA2D3ECF051;
        Thu, 11 May 2023 18:44:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=lc0.greatnet-hosting.de; s=rsa1; t=1683823491;
        bh=1bnfSSlX4RZCIYOKN1hdmY1+SLIhMr9vlxIhw4iy2DE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dv+PVfMxvIxo5y/7NoOV2k0Pc4qXc685nFZnDiqVe3y7D6hsjRXWXn2til4neyncs
         1g1e8QWtL+WYVRvxs5mLPDJXQlxXNBdJ+DXQjYP0qeoREk3vIpxW5ttg73TiZfPGi4
         yrbOtVNRb6nMfBJXREvmac4ry6uYekqYq4W8fJ/nXJ/37+/awC2fRilvnAo9SVAZCx
         ozj+vZ7PXUyw/GSmXxIyXX0eUIGDgECkgveQdrG0aTDcedT+WUNVH9unv4A2wAbT9o
         fBGhu6PucUDZyz201KgzYjjAlnbulZmCdY4T3290prqnlE7nPTPw0tHQw3oG6gnL7A
         VNcG+mQUdkPOA==
Date:   Thu, 11 May 2023 18:44:50 +0200
From:   Benjamin Block <lkml@mageta.org>
To:     Brian Bunker <brian@purestorage.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
Message-ID: <ZF0bgrAXJnWPJR/U@chlorum.ategam.org>
References: <20230505204950.21645-1-brian@purestorage.com>
 <20230508100930.GA9720@t480-pf1aa2c2.fritz.box>
 <7C02DE30-DBA7-45E5-A16C-02C75C670E9F@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7C02DE30-DBA7-45E5-A16C-02C75C670E9F@purestorage.com>
User-Agent: Mutt/2.2.9 (00093fd7) (2022-11-12)
X-Virus-Scanned: clamav-milter 0.103.2 at av0.int.greatnet.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 08, 2023 at 09:34:15AM -0700, Brian Bunker wrote:
> > On May 8, 2023, at 3:09 AM, Benjamin Block <bblock@linux.ibm.com> wrote:
> > On Fri, May 05, 2023 at 01:49:50PM -0700, Brian Bunker wrote:
> > 
> >> + int ret = -EINVAL;
> > 
> > Been wondering, whether it would make sense to have two different error
> > levels here. One for the case where the page is not found in the loop
> > that searches within page 0, and one for when page 0 is not present when
> > we try to dereference the RCU protected pointer.
> > 
> > That way we could have a safe fallback. If the page is there, we use its
> > data, if it is not, we blindly send the INQUIRY like we do today.
> > 
> > Not sure whether this is a bit too paranoid.. VPD page 0 is mandatory
> > after all.
> 
> That could be done, but the problem would still exist for the PURE target.
> We don’t support the page 0xb9, and we don’t advertise we do in the response
> to VPD 0. This approach would still lead to the INQUIRY being sent to devices

I wasn't meaning to send the INQUIRY regardless to what the page says,
if it is present. I was just thinking to having fall-back for when the
page 0 is not there at all (initially, when you call
`rcu_dereference()`). That would support your storage, as you have page
0, and it would be present for the check I assume.

But anyway, it seems this is a no-go regardless. I didn't expect targets
sending a valid page 0, but still supporting pages that are not listed in it.

> who don’t support it, don’t expect it, and report an unexpected error. What I am
> trying to avoid is the INQUIRY being sent to devices who don’t invite it.

-- 
Best Regards und Beste Grüße, Benjamin Block
               PGP KeyID: 9610 2BB8 2E17 6F65 2362  6DF2 46E0 4E05 67A3 2E9E
