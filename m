Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7A0C00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 10:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiHOK7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 06:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHOK7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 06:59:18 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5B1759A;
        Mon, 15 Aug 2022 03:59:17 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id F119341239;
        Mon, 15 Aug 2022 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1660561154; x=1662375555; bh=8UncpEyJrRMoN0SPHF9A7V+VtNUI98mOPHq
        ilYqV9fo=; b=htexahYDvC6z6etne6wzuchYeGSQ68L5MSIFFSej7a0mDHaUBag
        3boZhCgWY1yZLKBi5lJMYGANcF/FFcmgPtCExXmSCnG+sIwf397RFlYh8VczJ4w1
        yEHZHQiBonyYiay4AbpM8p6p2dFyASRgc1+DWu079j3LWlYLgvwLBkEc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1nrIWOT05rSp; Mon, 15 Aug 2022 13:59:14 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EE4EE40889;
        Mon, 15 Aug 2022 13:59:13 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 15 Aug 2022 13:59:13 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 15 Aug
 2022 13:59:12 +0300
Date:   Mon, 15 Aug 2022 13:59:11 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/6] scsi: target: core: add list of opcodes for RSOC
Message-ID: <20220815105911.GB17595@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-3-d.bogdanov@yadro.com>
 <99508f9b-46cb-b696-a5c4-3874b4d08355@oracle.com>
 <20220812080307.GA29582@yadro.com>
 <YvdXl/H1etXxeTqN@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YvdXl/H1etXxeTqN@infradead.org>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 13, 2022 at 12:49:43AM -0700, Christoph Hellwig wrote:
> 
> On Fri, Aug 12, 2022 at 11:03:07AM +0300, Dmitry Bogdanov wrote:
> > > > +     .support = SCSI_SUPPORT_FULL,
> > > > +     .opcode = XDWRITEREAD_10,
> > > > +     .cdb_size = 10,
> > > > +     .usage_bits = {XDWRITEREAD_10, 0x18, 0xff, 0xff,
> > > > +                    0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
> > > > +                    0xff, SCSI_CONTROL_MASK},
> > > > +};
> 
> > > one of Martin's tree after you made this patch.
> > Yes, I saw,  Iwill remove XDWRITEREAD_* in the next revision.
> 
> What this does point out is that the way the patches are done,
> we have a fundamental issue with these descriptors being potentially
> out of sync with the actually supported commands. Once way to fix
> this would be to add a parse callback to these dscriptors to unwind
> sbc_parse_cdb.  The big downside would be an extra expensive indirect
> call per command, though.
Yes, there is such a risk. I was raising it in our company 2 years ago
when I did this patchset. We agreed that, until there is somebody who
can notice about it, it's OK :). It's happened not so often. There was
just one case when we changed RSOC structs - when I was adding support
of ACA condition.

Recently someone wants to have some defence against fuzzy-logic attacks,
may be he (or someone else) will intergate RSOC descriptors into
sbc_parse_cmd within his task.

