Return-Path: <SRS0=Nn94=DV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0387AC43457
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 07:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D292073A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 07:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgJNHGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Oct 2020 03:06:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:35818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgJNHGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Oct 2020 03:06:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C33EAB1E9;
        Wed, 14 Oct 2020 07:06:31 +0000 (UTC)
Date:   Wed, 14 Oct 2020 09:06:31 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] qla2xxx: Return EBUSY on fcport deletion
Message-ID: <20201014070631.oe7hbjtfhsohgr54@beryllium.lan>
References: <20201012173524.46544-1-dwagner@suse.de>
 <alpine.LNX.2.23.453.2010131058220.10@nippy.intranet>
 <20201013065232.hdyjdkurkmowkf2f@beryllium.lan>
 <alpine.LNX.2.23.453.2010141103150.6@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.23.453.2010141103150.6@nippy.intranet>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

On Wed, Oct 14, 2020 at 11:57:04AM +1100, Finn Thain wrote:
> 
> On Tue, 13 Oct 2020, Daniel Wagner wrote:
> > How so? I am struggling to see how it could be a change in behavior. But 
> > then I sometimes fail at simple logic ;)
> > 
> 
> Me too, so I confirmed the result by executing the code snippets.

Thanks for taking the time to explain it to me!

> I don't know whether the changes in v3 are desirable or not, I was just 
> pointing out that the commit log ("valid qpair but the firmware has not 
> yet started return EBUSY") now seems to disagree with the code.

I see where I did my thinko. In v3 we have more ENODEV due to the fact
that we test the pointers first (qpair, fpcort). If either of them is
invalid we get the ENODEV. Actually, it's makes more sense and is likely
to be 'more correct'.

Anyway, let me update the commit log.

Thanks a lot!
Daniel
