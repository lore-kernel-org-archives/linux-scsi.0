From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH RESEND] Eliminate extra 'out_free' label from fcoe_init
 function
Date: Fri, 2 Jun 2017 18:07:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706021807250.19640@hadrien>
References: <8e1e75c4-3a80-00c3-2697-37fb1c86f7a1@redhat.com> <593161A9.9000100@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49662 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750955AbdFBQHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 12:07:51 -0400
In-Reply-To: <593161A9.9000100@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: mgandhi@redhat.com, Johannes Thumshirn <jth@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



On Fri, 2 Jun 2017, walter harms wrote:

>
>
> Am 02.06.2017 14:39, schrieb Milan P. Gandhi:
> > Simplify the check for return code of fcoe_if_init routine
> > in fcoe_init function such that we could eliminate need for
> > extra 'out_free' label and duplicate mutex_unlock statement.
> >
> > Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> > ---
> >  drivers/scsi/fcoe/fcoe.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > index ea21e7b..a2cf3d0 100644
> > --- a/drivers/scsi/fcoe/fcoe.c
> > +++ b/drivers/scsi/fcoe/fcoe.c
> > @@ -2523,14 +2523,13 @@ static int __init fcoe_init(void)
> >  	fcoe_dev_setup();
> >
> >  	rc = fcoe_if_init();
> > +	mutex_unlock(&fcoe_config_mutex);
> > +
> >  	if (rc)
> > -		goto out_free;
> > +		goto out_destroy;
> >
> > -	mutex_unlock(&fcoe_config_mutex);
> >  	return 0;
> >
> if you do that, why not
> if (!rc) return 0;

I agree with Dan.  If's should be for failures.

julia

>
> re,
>  wh
>
>
>
> > -out_free:
> > -	mutex_unlock(&fcoe_config_mutex);
> >  out_destroy:
> >  	destroy_workqueue(fcoe_wq);
> >  	return rc;
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
