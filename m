Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20187C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 06:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4C12076D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 06:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389776AbgJMGwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 02:52:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:48790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389637AbgJMGwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Oct 2020 02:52:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 013F7AEA8;
        Tue, 13 Oct 2020 06:52:33 +0000 (UTC)
Date:   Tue, 13 Oct 2020 08:52:32 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] qla2xxx: Return EBUSY on fcport deletion
Message-ID: <20201013065232.hdyjdkurkmowkf2f@beryllium.lan>
References: <20201012173524.46544-1-dwagner@suse.de>
 <alpine.LNX.2.23.453.2010131058220.10@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.23.453.2010131058220.10@nippy.intranet>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 13, 2020 at 10:59:18AM +1100, Finn Thain wrote:
> 
> On Mon, 12 Oct 2020, Daniel Wagner wrote:
> 
> > When the fcport is about to be deleted we should return EBUSY instead
> > of ENODEV. Only for EBUSY the request will be requeued in a multipath
> > setup.
> > 
> > Also in case we have a valid qpair but the firmware has not yet
> > started return EBUSY to avoid dropping the request.
> > 
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > ---
> > 
> > v3: simplify test logic as suggested by Arun.
> 
> Not exactly a "simplification": there was a change of behaviour between v2 
> and v3. It seems the commit log no longer reflects the code.

How so? I am struggling to see how it could be a change in behavior. But
then I sometimes fail at simple logic ;)

v2 and v3 will return ENODEV if qpair or fcport are invalid and for
EBUSY one of the other condition needs be true. The difference between
v2 and v3 should only be the order how tests are executed. The outcome
should be the same.
