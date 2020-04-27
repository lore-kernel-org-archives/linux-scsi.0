Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE369C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 18:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6EA22208
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 18:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgD0Slg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgD0Slg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 14:41:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E48C221EC;
        Mon, 27 Apr 2020 18:41:35 +0000 (UTC)
Date:   Mon, 27 Apr 2020 14:41:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
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
Message-ID: <20200427144133.6639f447@gandalf.local.home>
In-Reply-To: <20200427081548.skbi7pqysknamfv5@beryllium.lan>
References: <20200427030310.19687-1-bvanassche@acm.org>
        <20200427030310.19687-3-bvanassche@acm.org>
        <20200427081548.skbi7pqysknamfv5@beryllium.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Apr 2020 10:15:48 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> > --- a/include/trace/events/qla.h
> > +++ b/include/trace/events/qla.h
> > @@ -9,6 +9,9 @@
> >  
> >  #define QLA_MSG_MAX 256
> >  
> > +#pragma GCC diagnostic push
> > +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"  
> 
> I would be really surprised if this is needed for every single
> DECLARE_EVENT_CLASS declaration. 
> 
> >  DECLARE_EVENT_CLASS(qla_log_event,
> >  	TP_PROTO(const char *buf,
> >  		struct va_format *vaf),

Right. Looks like this warning is caused by the 'va_format' being passed to
the event prototype.

-- Steve
