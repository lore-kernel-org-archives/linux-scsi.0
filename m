Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C572C1975A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 15:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E6B22073E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 15:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCYPeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 11:34:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:37922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgCYPeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 11:34:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96333ADBB;
        Wed, 25 Mar 2020 15:34:18 +0000 (UTC)
Message-ID: <1fe3adead7a07ea3e14c2bc45bd87f58cc370720.camel@suse.com>
Subject: Re: [PATCH v2 2/3] scsi: qla2xxx: don't shut down firmware before
 closing sessions
From:   Martin Wilck <mwilck@suse.com>
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Date:   Wed, 25 Mar 2020 16:34:20 +0100
In-Reply-To: <alpine.LRH.2.21.9999.2003241732470.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
         <20200205214422.3657-3-mwilck@suse.com>
         <alpine.LRH.2.21.9999.2003241732470.12727@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-03-24 at 17:36 -0700, Arun Easi wrote:
> On Wed, 5 Feb 2020, 1:44pm, mwilck@suse.com wrote:
> 
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Since 45235022da99, the firmware is shut down early in the
> > controller
> > shutdown process. This causes commands sent to the firmware (such
> > as LOGO)
> > to hang forever. Eventually one or more timeouts will be triggered.
> > Move the stopping of the firmware until after sessions have
> > terminated.
> > 
> > Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
> > down chip")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> > 
> > 

...

> NAK.
> 
> The fcport deletion was done after chip reset to minimize
> interference and 
> further action on fcports. We should not be sending out logouts
> during 
> unload (driver just implicitly logs out). If you experience any
> hangs, 
> please let us know.

What about target mode? AFAIK target ports need to send explicit LOGO.

Regards
Martin


