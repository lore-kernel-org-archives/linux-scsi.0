Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FBFC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6262E206F4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sin0sp3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGOSMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGOSMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:12:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D05C061755;
        Wed, 15 Jul 2020 11:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=saTIUebuHx60grLsqQ5UA1G0XniSO168pvbDAVmqxss=; b=sin0sp3gxKo1VHxgpXPM0it16z
        l3hICd/BFK2RVOQxe5HYgHEQNa5xtOc8ZYtYE4CsToJHDbrrwCqG6GHy/AeKiA+8hbiJneuYJw6so
        nxYIpDv1qzfV2VP0CEYo4Qm4m8wpch2uwyWKJg4qF2HYhA2hvFsd5WqvRpiSHuuucrI8D2K2SY05X
        bLiumEk5g1+/LfBYpN9LX8muhR7GD3wNPL2ospnqgFD4pU4hyrtlep5i2F1I5app3GYyv1mg9JM/L
        od2CDDzl4K1T9ytxRoCHA72e5bkqZefTF0pg94y8IHRVfBT1GLq3OrTqRnkfaoYuJJ62W7hQYf8cR
        d+tFttEQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlsf-0004ih-GE; Wed, 15 Jul 2020 18:11:45 +0000
Date:   Wed, 15 Jul 2020 19:11:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Simon Arlott <simon@octiron.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] reboot: add a "power cycle" quirk to prepare for a
 power off on reboot
Message-ID: <20200715181145.GA17753@infradead.org>
References: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Except for the fact that I think that usage of the BIT() macro is
a horrible pattern, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
