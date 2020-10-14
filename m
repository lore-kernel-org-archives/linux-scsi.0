Return-Path: <SRS0=Nn94=DV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C28C433E7
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 00:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F17820EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 00:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgJNA5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 20:57:07 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53370 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgJNA5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 20:57:07 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 84BB023D26;
        Tue, 13 Oct 2020 20:57:04 -0400 (EDT)
Date:   Wed, 14 Oct 2020 11:57:04 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Daniel Wagner <dwagner@suse.de>
cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] qla2xxx: Return EBUSY on fcport deletion
In-Reply-To: <20201013065232.hdyjdkurkmowkf2f@beryllium.lan>
Message-ID: <alpine.LNX.2.23.453.2010141103150.6@nippy.intranet>
References: <20201012173524.46544-1-dwagner@suse.de> <alpine.LNX.2.23.453.2010131058220.10@nippy.intranet> <20201013065232.hdyjdkurkmowkf2f@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Tue, 13 Oct 2020, Daniel Wagner wrote:

> On Tue, Oct 13, 2020 at 10:59:18AM +1100, Finn Thain wrote:
> > 
> > On Mon, 12 Oct 2020, Daniel Wagner wrote:
> > 
> > > When the fcport is about to be deleted we should return EBUSY 
> > > instead of ENODEV. Only for EBUSY the request will be requeued in a 
> > > multipath setup.
> > > 
> > > Also in case we have a valid qpair but the firmware has not yet 
> > > started return EBUSY to avoid dropping the request.
> > > 
> > > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > > ---
> > > 
> > > v3: simplify test logic as suggested by Arun.
> > 
> > Not exactly a "simplification": there was a change of behaviour 
> > between v2 and v3. It seems the commit log no longer reflects the 
> > code.
> 
> How so? I am struggling to see how it could be a change in behavior. But 
> then I sometimes fail at simple logic ;)
> 

Me too, so I confirmed the result by executing the code snippets.

> v2 and v3 will return ENODEV if qpair or fcport are invalid and for 
> EBUSY one of the other condition needs be true. The difference between 
> v2 and v3 should only be the order how tests are executed. The outcome 
> should be the same.
> 

Here's a truth table for v2:

qpair fw_started fcport deleted result
---------------------------------------
F       X       F       X       -ENODEV
F       F       T       F       -ENODEV
F       F       T       T       -EBUSY  *
F       T       T       F       -ENODEV
F       T       T       T       -EBUSY  *
T       F       F       X       -EBUSY  *
T       F       T       X       -EBUSY
T       T       F       X       -ENODEV
T       T       T       F       neither
T       T       T       T       -EBUSY

Here's a truth table for v3:

qpair fw_started fcport deleted result
---------------------------------------
F       X       F       X       -ENODEV
F       F       T       F       -ENODEV
F       F       T       T       -ENODEV *
F       T       T       F       -ENODEV
F       T       T       T       -ENODEV *
T       F       F       X       -ENODEV *
T       F       T       X       -EBUSY
T       T       F       X       -ENODEV
T       T       T       F       neither
T       T       T       T       -EBUSY

The asterisks mark the changed rows.

I don't know whether the changes in v3 are desirable or not, I was just 
pointing out that the commit log ("valid qpair but the firmware has not 
yet started return EBUSY") now seems to disagree with the code.
