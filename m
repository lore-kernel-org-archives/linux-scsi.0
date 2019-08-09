Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49278C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 18:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2553320B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 18:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pp3TclQj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406974AbfHISRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 14:17:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfHISRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 14:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ml+u8yDNnJwbZxXnTPYLCdyaPo9+Hy67Rp3YV4keyc8=; b=pp3TclQjfSki7ddzzzNjASr3G
        GRd3rBPoMlFVX863gg7sBFrn9L25y19+wdosfDlMoty125IpEgEwpG1zvO00VHRXOnClW3sESsI6r
        uy1FTUpYOqwnTDC0MRvWe65liPigljt4a+V/JDtB58rANp9bgKm3URSN1eLXuqXQE8ByHtOd/0aI8
        WvwyzqcOxRqZKhetkGKUzbPfGoX2ZsqLdiloSuYGs/bnS4bDbaVns7Ppag11MdqjKP+48va3ez+G5
        +XPERsTtxYpBk1UoNXO5RCOxIff/t+YW9UekL1THLl9OLACsqnYOomSFDmlP05GmYx55Fgrbi6tl7
        38lXJtvlw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hw9SH-0002hr-Lr; Fri, 09 Aug 2019 18:17:33 +0000
Date:   Fri, 9 Aug 2019 11:17:33 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c8xx_2: remove redundant assignment to retv
Message-ID: <20190809181733.GQ5482@bombadil.infradead.org>
References: <20190809175932.10197-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20190809175932.10197-1-colin.king@canonical.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190809181733.W8br-L2lXvyUVnlWffRKU1LowRXj-cZm2QefnYT--XA@z>

On Fri, Aug 09, 2019 at 06:59:32PM +0100, Colin King wrote:
> Variable retv is initialized to a value that is never read and it
> is re-assigned later. The initialization is redundant and can be
> removed.

Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Seems like a bit of a pointless class of warnings, given that gcc now
initialises all locals.  But I'm happy for James or Martin to pick it up.

