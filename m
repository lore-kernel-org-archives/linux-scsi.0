Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25F6C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B040C2065F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r/IRrR4o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgGOSM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgGOSM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:12:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA455C061755;
        Wed, 15 Jul 2020 11:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1O8gCAk3sHB73r10lZy+GXtbnZOViYIuP0JmkWQ7mtE=; b=r/IRrR4oQJgu4nromds02egPfH
        kIwrolcHx1rZENxCxqUKYknwwzcYtFosrLaYq7s3GFhwsa11B6zgsAW8mq+XRQpRuTUN0scK02YOy
        2SrtYGKWiblsBHH/T6PVMPO4HFs5z959fxTxlihRFxeVpP4bxGk85HZBU/l2OybIh6Sgfu9HZ/cWB
        oVxu3ipb5/EG7EAAwyYQ+UHoLv9wl1TKeOthEXYUXOM+4cIWOf36ToZN3z2kS1+fVpEd9m54ToTMb
        hGkEvOKx+8kD9+GPSAYqxQojdmFWSkjHjOJHH5f5k9B/vb+ik7vgQ/hOVjoO/ZepN0DV8QSxaVG/h
        kbD1rauA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvltc-0004kS-Hp; Wed, 15 Jul 2020 18:12:44 +0000
Date:   Wed, 15 Jul 2020 19:12:44 +0100
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
Subject: Re: [PATCH 2/2] x86/reboot/quirks: Add ASRock Z170 Extreme4
Message-ID: <20200715181244.GB17753@infradead.org>
References: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <a7c26ca1-0201-7526-8b69-484868725ee3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7c26ca1-0201-7526-8b69-484868725ee3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 09:58:05PM +0100, Simon Arlott wrote:
> If a PCI mode reboot is performed on the ASRock Z170 Extreme4, a power
> cycle will occur. Automatically set the reboot quirk for this to prepare
> for the power off (i.e. stop all disks).
> 
> This will only take effect if PCI mode is manually used. It'll be too late
> in the reboot process to prepare for power off if the other reboot methods
> fail.
> 
> It is necessary to re-order the processing of DMI checks because this quirk
> must apply even if a reboot= command line parameter is used as that's the
> only way to specify a PCI mode reboot.
> 
> Signed-off-by: Simon Arlott <simon@octiron.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
