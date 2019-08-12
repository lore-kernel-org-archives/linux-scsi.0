Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25213C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9A820665
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FKcPFuEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfHLOWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:22:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfHLOWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Xv2mRF6V/+dvEmf3LhDWENUTlC47/TRl8hoD9s1nkc8=; b=FKcPFuExfz9Ts9lFdKPhbz0H7
        rkGWFmqDA4pbIe5Mo8q5W5MZsUjPBLxYk2FyfdD0tFC5q+hRnKKQGJFYANY4BgyaTIcCyvL6vsSmG
        jCQ5UaT+xUKggQthISXH5cqpSyak7rPhbPN4IG28p2m3L/ozTDuGktceDbg9XvjfJruGHwYbebigu
        auKn/AdFC4yQYOwvsMRBthCckTmCyfylucXxSMfPJqIZ/MR06pKIJEU7mZPBf8vQNaVRERW4aUxJh
        /sfnJ1z6KmCd3QBuxS7bylAJjHvI59zmAXaorCyP4yLrqM0MkJiZVESLDT0uFlSssMGAVPv6HGBTL
        Ew7laK8eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBDV-0002Pa-Er; Mon, 12 Aug 2019 14:22:33 +0000
Date:   Mon, 12 Aug 2019 07:22:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 01/20] sg: move functions around
Message-ID: <20190812142233.GA8105@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-2-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:33PM +0200, Douglas Gilbert wrote:
> Move main entry point functions around so submission code comes
> before completion code. Prior to this, the driver used the
> traditional open(), close(), read(), write(), ioctl() ordering
> however in this case that places completion code (i.e.
> sg_read()) before submission code (i.e. sg_write()). The main
> driver entry points are considered to be those named in struct
> file_operations sg_fops' definition.
> 
> Helper functions are often placed above their caller to reduce
> the number of forward function declarations needed.

This looks generally sensible.  But can you also move the whole
procfs code to the very end of the file to follow the usual
pattern elsewhere and avoid the extra forward declaration?
