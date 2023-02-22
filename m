Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41A2C636D6
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 16:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjBVQpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjBVQpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 11:45:03 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF163BDA9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 08:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qj4/wUvuYBB7N+Y9LA8l89zGBmqdIRGfgsWaxKkBaug=; b=Tw0pmpuoFb72/djYGTKZbstk3i
        Qisu9akf8lVz3gLrekCpDqTM2KpgZGbYODULReAAzhWxQthPz+R735wLkT/xORhvzA5zvuSjCWYqS
        mSlcYO2x52WidirP8uNaABLmlBaaWzw5MDESI04s0QDrYrBt70s7Zqz6lAS+8eGwA8jnVU5RvctE/
        Me689/9XFOz3pxzILD7F5H/KgjL2/THQfatNga6JgNrw2D8AjORvTWrVSPY0bCz8i2ZFGkc+t9Q8Y
        QsLjtUHtipl11m06ybj5g6aSYutza1zXTsKnOU9F/Su4pCecNdglxIVrbHC42K0BBWriP9ajp28Q9
        6bySXm3A==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <carnil@debian.org>)
        id 1pUsEW-008lbK-Nw; Wed, 22 Feb 2023 16:44:45 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
        id E8EC6BE2DE0; Wed, 22 Feb 2023 17:44:43 +0100 (CET)
Date:   Wed, 22 Feb 2023 17:44:43 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Message-ID: <Y/ZGe8c1XyqSuCSk@eldamar.lan>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
 <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
 <Y15lk+CPsjJ801iY@infradead.org>
 <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
 <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
 <Y8+m0w4Og2CLFImY@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8+m0w4Og2CLFImY@lorien.valinor.li>
X-Debian-User: carnil
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Tue, Jan 24, 2023 at 10:37:23AM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Mon, Jan 02, 2023 at 08:06:41AM -0500, Martin K. Petersen wrote:
> > 
> > Martin,
> > 
> > > is anything blocking mainline inclusion of this patch?
> > 
> > I applied these to 6.2/scsi-fixes last week. The patches have been
> > sitting in a topic branch for a bit due to the three-way conflict
> > between fixes, queue, and upstream.
> 
> It landed in 6.2-rc4 recently in fact. Thank you!
> 
> Would it be posssible to backport the fix as well back to the stable
> series affected? 
> 
> In Debian we have the reports as per https://bugs.debian.org/1022126
> where the issue was introduced back in 5.10.y. Context in
> https://lore.kernel.org/linux-scsi/CAK=zhgr=MYn=-mrz3gKUFoXG_+EQ796bHEWSdK88o1Aqamby7g@mail.gmail.com/
> .

Friendly ping on this, can this change be backported as well to the
relevant stable series? It would apply already cleanly to 6.1.y, but
due to 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
reallocating pools") it might need some additional review for the
older stable series (in particular of interest due to the above for
5.10.y).

Thanks already! If the change for older series needs some additional
testing we might ask the affected users from the Debian bug 1022126 to
test on 5.10.y as well.

Regards,
Salvatore
