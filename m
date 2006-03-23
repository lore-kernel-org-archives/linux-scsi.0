From: Bryan Holty <lgeek@frontiernet.net>
Subject: Re: [PATCH] scsi: Fix sg memory leak building 2 scatter-gather lists
Date: Thu, 23 Mar 2006 06:04:39 -0600
Message-ID: <200603230604.39336.lgeek@frontiernet.net>
References: <200603221703.59337.lgeek@frontiernet.net> <4421DE81.3090805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04.roc.ny.frontiernet.net ([66.133.182.167]:17642 "EHLO
	relay04.roc.ny.frontiernet.net") by vger.kernel.org with ESMTP
	id S1030248AbWCWMEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 07:04:42 -0500
In-Reply-To: <4421DE81.3090805@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday 22 March 2006 17:32, Douglas Gilbert wrote:
> Bryan Holty wrote:
> > Hello,
> >     There is a memory leak in sg that is hit in the case when direct_io
> > is in use and the length of the data is longer than we can fit into a
> > single scatter-gather list.  Two scatter-gather lists are allocated for
> > each io that meets the criteria, and only 1 ever gets released.
> >
> >     The following fix releases the scatter-gather list created by the
> > attempted sg_build_direct when abandoning the effort in favor of
> > sg_build_indirect.  sg_build_indirect creates a new scatter-gather list.
>
> Wow, sg leak fixes are coming thick and fast.
> I agree there is a leak there but I'm not sure about
> the placement of sg_remove_scat().
>
> Bryan, what do you think about the variant attached to
> this post? It is untested.
>
> Doug Gilbert
>
> > Signed-off-by: Bryan Holty <lgeek@frontiernet.net>
> >
> > --- a/drivers/scsi/sg.c	2006-03-03 13:17:23.000000000 -0600
> > +++ b/drivers/scsi/sg.c	2006-03-22 16:32:17.536091840 -0600
> > @@ -1648,6 +1648,7 @@
> >  		res = sg_build_direct(srp, sfp, dxfer_len);
> >  		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
> >  			return res;
> > +		sg_remove_scat(req_schp);
> >  	}
> >  	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
> >  		sg_link_reserve(sfp, srp, dxfer_len);

I think the variant solves the same problem.  I had no other reason for 
releasing the scatter-gather list outside of sg_build_direct other than that 
is how the the sg_build_indirect is done and that due to the checks in 
sg_remove_scat it could be called from there.

I agree that the variant placement makes more sense.
--
 Bryan Holty
