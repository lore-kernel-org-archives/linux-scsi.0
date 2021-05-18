Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55551C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 07:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC8261261
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 07:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344513AbhERHlU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 03:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbhERHlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 03:41:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C92FC061573
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 00:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Mp3sbAYHIBlMQkt43pBfgq0pkkN0OJCd9YLQh/DVNBU=; b=p4WpecMIrtKc6ZsFaNMD6jywFJ
        rIzctxr3OmhX6c7suonU3wAnIB9/D6A4vhorOkLb6B4oGrLLCgLMVqOniqhDBegPcSDZMwn08HTa2
        xi6QR8GKdzfp1CwuX2H+/Qlf4BslqQsImIGJRaDHmYvw9JgKDcaWK71qCR4Y0w+AtbPBunYzCmXWT
        C/EBnuv2ZVHmom9ufJTmImF+uhVd1+2Mx3oT3Y9NRRpePPjQ0I/vvJqhS/fwYYufTxrJUA0Az56fb
        zel+o3wkXH3qFKaetqCCv91jKG9MEplqAgHtPLmBFLqQOimQGxI29oeevOaLDSnnPoqvloQGoNPYb
        dMQHtQ1g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liuJm-00DluA-19; Tue, 18 May 2021 07:39:10 +0000
Date:   Tue, 18 May 2021 08:39:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, steve.hagan@broadcom.com,
        peter.rivera@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        sathya.prakash@broadcom.com, bvanassche@acm.org, thenzl@redhat.com,
        hare@suse.de, himanshu.madhani@oracle.com, hch@infradead.org
Subject: Re: [PATCH v5 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
Message-ID: <YKNvGn9TTwthUaMv@infradead.org>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-2-kashyap.desai@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513083608.2243297-2-kashyap.desai@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +	help
> +	This driver supports Broadcom's Unified MPI3 based Storage & RAID Controllers.

Overly long line here.

> +#ifndef MPI30_API_H
> +#define MPI30_API_H     1
> +#include "mpi30_transport.h"
> +#include "mpi30_image.h"
> +#include "mpi30_init.h"
> +#include "mpi30_ioc.h"
> +#endif

Just including the four headers where needed directly would make more
sense to me than this meta-header.

> + *           Name: mpi30_image.h

We generally do not add comments like this.  It does not add any value
and gets stale very quickly.

> + *  Creation Date: 04/02/2018
> + *        Version: 03.00.00

No need for this information either.  If you important from a specific
internal version this is something that should go into the commit log.

> +struct _mpi3_comp_image_version {

Please drop the leading underscore from the various type names.
