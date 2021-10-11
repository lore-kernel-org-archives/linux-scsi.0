Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14683C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 08:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F042F60C4B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 08:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhJKIhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 04:37:18 -0400
Received: from email.unionmem.com ([221.4.138.186]:48785 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235146AbhJKIhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 04:37:09 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19B8Ya11060730
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 16:34:36 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 11
 Oct 2021 16:34:36 +0800
Date:   Mon, 11 Oct 2021 08:34:35 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211011083435.6e24a2e8@songyl>
In-Reply-To: <52ee4617-93ba-919f-b990-f04f64a13d4b@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
        <20211009133207.789ad116@songyl>
        <52ee4617-93ba-919f-b990-f04f64a13d4b@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19B8Ya11060730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Oct 2021 20:52:13 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 10/9/21 06:32, Yanling Song wrote:
> > op_is_write() does not meet our requirement: Both read and write
> > commands have to be checked, not just write command.  
> 
> Right, I should have proposed to compare the operation type with 
> REQ_OP_READ / REQ_OP_WRITE. However, that approach only works for
> SCSI commands that come from the block layer and not for SG_IO 
> (REQ_OP_DRV_IN/OUT).
> 
> >> Please remove all of the above code and use blk_rq_pos(),
> >> blk_rq_sectors() and rq->cmd_flags & REQ_FUA instead.  
> > 
> > I did not quite get your point. The above is commonly used in many
> > similar use cases. For example: megasas_build_ldio() in
> > megaraid_sas_base.c.
> > What's the benefit to switch to another way: use
> > blk_rq_pos(),blk_rq_sectors()?  
> 
> I expect that using blk_rq_pos() and blk_rq_sectors() will result in 
> faster code. However, these functions only work for SCSI commands
> that come from the block layer and not for SG_IO. If you want a
> common code path for SG_IO and block layer requests, please take a
> look at how get_unaligned_be*() is used in drivers/scsi/scsi_trace.c.

get_unaligned_be*() is an inline which has the same function as our
current code and there is no difference on performance.  
But current code is better when supporting old kernels since it is
implemented on SCSI spec and there is no dependency on
get_unaligned_be*(), which means the code can work on any version
of kernel. 
So I prefer to keep current implementation. What's your opinion?
 
> 
> Thanks,
> 
> Bart.

