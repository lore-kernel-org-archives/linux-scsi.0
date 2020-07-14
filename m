Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F349CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 11:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A2222201
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 11:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UaU0W+oQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgGNLl3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgGNLl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 07:41:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08707C061755
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 04:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W0uP5OtIAUnRAOSsv9mZUTtRrqIXBcSYHKHXkgH+zcU=; b=UaU0W+oQnktbZ+jzn1GQ3zkWP+
        yI0Q/AasO1ZkfnI7GhMT0bLwTfaNDok2j7KUgIh0SwogAZAxMRHBCk4E09kGkLgCmehFE0EuL7R55
        FMx8EZvE+sSVPmIpsI/LgwX1WvBXRRGnAYOzV65XsdDZkajlvLIdSiWeOmeRPX6q3ub/99zWcyZvr
        GFJc9QKBxXMQZWo+eMLXiFcWBnb6HoqLXwExiOnvDjQmibaCKz79R3T4Pw8rCqQgTjoFnltXj6eRW
        9ZLrP62rYIdisaVSp/4gLJZbZNE8SLJ7ht6wVxDQ374yF5rnMDqlYd7i3uqa/StT4o8HRG55b8q7s
        vZBlanIw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvJJL-0007xb-0i; Tue, 14 Jul 2020 11:41:23 +0000
Date:   Tue, 14 Jul 2020 12:41:22 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Message-ID: <20200714114122.GA12769@casper.infradead.org>
References: <20200706193920.6897-1-willy@infradead.org>
 <20200706193920.6897-4-willy@infradead.org>
 <20200714082631.GB7244@t480-pf1aa2c2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714082631.GB7244@t480-pf1aa2c2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 10:26:31AM +0200, Benjamin Block wrote:
> > @@ -428,7 +428,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
> >  	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
> >  	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
> >  	.sdev_prep		 = zfcp_scsi_sdev_prep,
> > -	.slave_configure	 = zfcp_scsi_slave_configure,
> > +	.sdev_configure	 = zfcp_scsi_sdev_configure,
> 
> Please fix the alignment.

sed doesn't kow how to do that.
