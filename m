Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31C2C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 23:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91EB22518
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 23:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgLNXWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 18:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgLNXWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 18:22:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E1E32250F;
        Mon, 14 Dec 2020 23:21:19 +0000 (UTC)
Date:   Mon, 14 Dec 2020 18:21:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Bean Huo' <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
Message-ID: <20201214182117.1bbc717d@gandalf.local.home>
In-Reply-To: <977f3ea155644cd89bc83f2e9dcf281e@AcuMS.aculab.com>
References: <20201214202014.13835-1-huobean@gmail.com>
        <20201214202014.13835-2-huobean@gmail.com>
        <977f3ea155644cd89bc83f2e9dcf281e@AcuMS.aculab.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Dec 2020 23:11:40 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > ---
> >  include/trace/events/ufs.h | 40 +++++++++++++++++++-------------------
> >  1 file changed, 20 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> > index 0bd54a184391..fa755394bc0f 100644
> > --- a/include/trace/events/ufs.h
> > +++ b/include/trace/events/ufs.h
> > @@ -20,28 +20,28 @@  
> ..
> > +#define UFS_LINK_STATES						\
> > +	EM(UIC_LINK_OFF_STATE,		"UIC_LINK_OFF_STATE")		\
> > +	EM(UIC_LINK_ACTIVE_STATE,	"UIC_LINK_ACTIVE_STATE")	\
> > +	EMe(UIC_LINK_HIBERN8_STATE,	"UIC_LINK_HIBERN8_STATE")  
> 
> If you make EM a parameter to UFS_LINK_STATES then the caller
> can pass in the name of a #define that does the required expansion.
> The caller can also add in any required terminator after the last entry.
> For an enum (which doesn't want a , at the end) just add a dummy entry.
> You often want a constant for the number of items anyway.

This is currently the way its done in multiple other places. When creating
the "EMe" trick, I've thought about it, but then realized it would make the
other locations look strange without the expected comma, and decided that
EMe() would be the best solution, as it's only strange in where it's added,
and not where its used.

 $ git grep -l EMe include/trace/ |wc -l
     11

It's already used in 11 other files, let's not muck with it now.

-- Steve

