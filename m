Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325F7C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 08:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009AE64DAF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 08:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhBPInX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 03:43:23 -0500
Received: from verein.lst.de ([213.95.11.211]:40331 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhBPIlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Feb 2021 03:41:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F164168B05; Tue, 16 Feb 2021 09:40:56 +0100 (CET)
Date:   Tue, 16 Feb 2021 09:40:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
Message-ID: <20210216084056.GC23615@lst.de>
References: <20210212072642.17520-1-michael.christie@oracle.com> <20210212072642.17520-16-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212072642.17520-16-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 12, 2021 at 01:26:32AM -0600, Mike Christie wrote:
> tcm_loop could be used like a normal block device, so we can't use
> GFP_KERNEL. This adds a gfp_t arg to target_cmd_init_cdb and covnerts
> the users. For every driver but loop I kept GFP_KERNEL. For loop and
> xcopy I switched to GFP_NOIO.
> 
> This will also be useful in the later patches where loop needs to
> do target_submit_prep from interrupt context to get a ref to the
> se_device, and so it will need to use GFP_ATOMIC.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
