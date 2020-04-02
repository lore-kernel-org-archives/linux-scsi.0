Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD6FC18E5B
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C792072E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 09:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbgDBJjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 05:39:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:52286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgDBJjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Apr 2020 05:39:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 396CFABAD;
        Thu,  2 Apr 2020 09:39:21 +0000 (UTC)
Message-ID: <f07b1a2226f4364e523fd5e0f8d60f62126ad7e7.camel@suse.com>
Subject: Re: [EXT] [PATCH v3 3/5] Revert "scsi: qla2xxx: Fix unbound sleep
 in fcport delete path."
From:   Martin Wilck <mwilck@suse.com>
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Date:   Thu, 02 Apr 2020 11:39:20 +0200
In-Reply-To: <alpine.LRH.2.21.9999.2004011007350.12727@irv1user01.caveonetworks.com>
References: <20200327164711.5358-1-mwilck@suse.com>
         <20200327164711.5358-4-mwilck@suse.com>
         <alpine.LRH.2.21.9999.2004011007350.12727@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Arun,

On Wed, 2020-04-01 at 10:12 -0700, Arun Easi wrote:
> On Fri, 27 Mar 2020, 9:47am, mwilck@suse.com wrote:
> 
> > External Email
> > 
> > -----------------------------------------------------------------
> > -----
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This reverts commit c3b6a1d397420a0fdd97af2f06abfb78adc370df.
> > Aborting the sleep was risky, because after return from
> > qlt_free_session_done() the driver starts freeing resources,
> > which is dangerous while we know that there's pending IO.
> > 
> > The previous patch "scsi: qla2xxx: check UNLOADING before posting
> > async
> > work" avoids sending this IO in the first place, and thus obsoletes
> > the dangerous timeout.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_target.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_target.c
> > b/drivers/scsi/qla2xxx/qla_target.c
> > index 622e733..eec1338 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -1019,7 +1019,6 @@ void qlt_free_session_done(struct work_struct
> > *work)
> >  
> >  	if (logout_started) {
> >  		bool traced = false;
> > -		u16 cnt = 0;
> >  
> >  		while (!READ_ONCE(sess->logout_completed)) {
> >  			if (!traced) {
> > @@ -1029,9 +1028,6 @@ void qlt_free_session_done(struct work_struct
> > *work)
> >  				traced = true;
> >  			}
> >  			msleep(100);
> > -			cnt++;
> > -			if (cnt > 200)
> > -				break;
> 
> By taking this code out, it would leave a stuck FC target delete
> thread 
> and thus preventing the module unload itself, in case of a bug in
> this 
> logic (which was seen in some instances).
> 
> How about increasing the wait time to say 25 seconds (typical worst
> case 
> is 2 * RA_TOV = 20 seconds) and then alerting user with a "WARN",
> but 
> still break out?
> 

I've seen the kernel crash because of this breakout. A crash happens if
another code path was blocked because of either the stopped FW or
anything else, and would time out after this code. 

The actual crash I've seen is already been fixed by patch 1 of this
series, because qla2x00_terminate_rport_io() checks UNLOADING before
sending IO. So if it was just about that, we could keep the breakout.

I suspect that the "unbound sleep" occurred only because of the 
hanging access to stopped FW (note that c3b6a1d39742 was made just ~2
months after 45235022da99 "scsi: qla2xxx: Fix driver unload by shutting
down chip"). If that's true, the hang wouldn't occur any more with
patch 1-2 of my series applied. If it's wrong and the hang does occur
again, IMO we should find out what is hanging, and fix it, rather than
blindly quit this wait loop and free resources.

But if you want to keep it in, I'm not going to insist; I'm more
interested in getting the first two patches merged.

Regards,
Martin

(Btw, I suppose you'll admit the combination of msleep() and counting
isn't the state of the art of implementing a timeout in the kernel).




> Regards,
> -Arun
> 
> >  		}
> >  
> >  		ql_dbg(ql_dbg_disc, vha, 0xf087,
> > 


