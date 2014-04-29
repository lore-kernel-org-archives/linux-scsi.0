From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] bfa: Added support to obtain SFP info.
Date: Tue, 29 Apr 2014 15:51:00 +0300
Message-ID: <20140429125100.GS4963@mwanda>
References: <20140327230514.GA15507@mwanda>
 <20140327230737.GB7045@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaD2MvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2014 08:51:09 -0400
Content-Disposition: inline
In-Reply-To: <20140327230737.GB7045@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>

Krishna isn't around any more.  Does anyone else know what's going on
in this code?  It looks buggy to me.

regards,
dan carpenter

On Fri, Mar 28, 2014 at 02:07:37AM +0300, Dan Carpenter wrote:
> On Fri, Mar 28, 2014 at 02:05:14AM +0300, Dan Carpenter wrote:
> > Hello Krishna Gudipati,
> > 
> > The patch 51e569aa1f0c: "[SCSI] bfa: Added support to obtain SFP
> > info." from Jun 24, 2011, leads to the following static checker
> > warning:
> > 
> > 	drivers/scsi/bfa/bfa_ioc.c:3668 bfa_cb_sfp_state_query()
> > 	warn: add curly braces?
> > 
> > drivers/scsi/bfa/bfa_ioc.c
> >   3659  static void
> >   3660  bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
> >   3661  {
> >   3662          bfa_trc(sfp, sfp->portspeed);
> >   3663          if (sfp->media) {
> >   3664                  bfa_sfp_media_get(sfp);
> >   3665                  if (sfp->state_query_cbfn)
> >                                                    ^
> > Add a curly brace here?
> > 
> >   3666                          sfp->state_query_cbfn(sfp->state_query_cbarg,
> >   3667                                          sfp->status);
> >   3668                          sfp->media = NULL;
> >   3669                  }
> >   3670  
> >   3671                  if (sfp->portspeed) {
> >   3672                          sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
> >   3673                          if (sfp->state_query_cbfn)
> >   3674                                  sfp->state_query_cbfn(sfp->state_query_cbarg,
> >   3675                                                  sfp->status);
> >   3676                                  sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
> 
> It looks like this if statement needs curly braces as well.
> 
> regards,
> dan carpenter
> 
> >   3677                  }
> >   3678  
> >   3679                  sfp->state_query_lock = 0;
> >   3680                  sfp->state_query_cbfn = NULL;
> > 
> >                 ^
> > And another close curly brace here?
> > 
> >   3681  }
> > 
> > regards,
> > dan carpenter
