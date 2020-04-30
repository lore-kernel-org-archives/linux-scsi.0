Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEB1C83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B21452186A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD3H3D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:29:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgD3H3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 03:29:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE0DDAD79;
        Thu, 30 Apr 2020 07:29:00 +0000 (UTC)
Date:   Thu, 30 Apr 2020 09:29:00 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
Message-ID: <20200430072900.bj6n54d3amllstqy@beryllium.lan>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-3-bvanassche@acm.org>
 <20200427081548.skbi7pqysknamfv5@beryllium.lan>
 <20200427144133.6639f447@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427144133.6639f447@gandalf.local.home>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 27, 2020 at 02:41:33PM -0400, Steven Rostedt wrote:
> On Mon, 27 Apr 2020 10:15:48 +0200
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > > --- a/include/trace/events/qla.h
> > > +++ b/include/trace/events/qla.h
> > > @@ -9,6 +9,9 @@
> > >  
> > >  #define QLA_MSG_MAX 256
> > >  
> > > +#pragma GCC diagnostic push
> > > +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"  
> > 
> > I would be really surprised if this is needed for every single
> > DECLARE_EVENT_CLASS declaration. 
> > 
> > >  DECLARE_EVENT_CLASS(qla_log_event,
> > >  	TP_PROTO(const char *buf,
> > >  		struct va_format *vaf),
> 
> Right. Looks like this warning is caused by the 'va_format' being passed to
> the event prototype.

Thanks for explaning. I had the impression the pragma is muting
DECLARE_EVENT_CLASS.

In this case

Reviewed-by: Daniel Wagner <dwagner@suse.de>
