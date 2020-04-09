Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F916C2BB54
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 07:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6022075E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 07:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDIHgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:36:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:57642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgDIHgg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Apr 2020 03:36:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 37471ADA3;
        Thu,  9 Apr 2020 07:36:35 +0000 (UTC)
Date:   Thu, 9 Apr 2020 09:36:34 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: core: Rate limit "rejecting I/O" messages
Message-ID: <20200409073634.t2xgdhoyb4jmidnp@beryllium.lan>
References: <20200408171012.76890-1-dwagner@suse.de>
 <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ewan,

On Wed, Apr 08, 2020 at 03:16:27PM -0400, Ewan D. Milne wrote:
> On Wed, 2020-04-08 at 19:10 +0200, Daniel Wagner wrote:
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1217,7 +1217,7 @@ scsi_prep_state_check(struct scsi_device *sdev,
> > struct request *req)
> >  		 */
> >  		if (!sdev->offline_already) {
> >  			sdev->offline_already = true;
> > -			sdev_printk(KERN_ERR, sdev,
> > +			sdev_printk_ratelimited(KERN_ERR, sdev,
> >  				    "rejecting I/O to offline
> > device\n");
> 
> I would really prefer we not do it this way if at all possible.
> It loses information we may need to debug SAN outage problems.

Understood.

> The reason I didn't use ratelimit is that the ratelimit structure is
> per-instance of the ratelimit call here, not per-device.  So this
> doesn't work right -- it will drop messages for other devices.

I didn't really think this through. Sorry.

> > -		sdev_printk(KERN_ERR, sdev,
> > +		sdev_printk_ratelimited(KERN_ERR, sdev,
> >  			    "rejecting I/O to dead device\n");
> 
> I practice I hardly see this message, do you actually have a case
> where this happens?  If so perhaps add another flag similar to
> offline_already?
> 
> The offline message happens a *lot*, we get a ton of them for each
> active device when the queues are unblocked when a target goes away.

I've missed commit b0962c53bde9 ("scsi: core: avoid repetitive logging
of device offline messages") which should address the report I got in
our enterprise kernel. I was over eager to rate limit the 'dead
device' as well. It seem no need for this patch. Let me backport the
commit and see what our customer has to say.

Thanks for the help!
Daniel
