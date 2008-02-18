From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 0/3] iscsi bidi & varlen support
Date: Mon, 18 Feb 2008 11:03:42 -0500
Message-ID: <20080218160342.GC22541@osc.edu>
References: <47A20E85.6040906@panasas.com> <20080212201239.GB12532@osc.edu> <20080212201753.GC12532@osc.edu> <47B9A6AF.1040603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:35677 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYBRQDo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 11:03:44 -0500
Content-Disposition: inline
In-Reply-To: <47B9A6AF.1040603@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>

bharrosh@panasas.com wrote on Mon, 18 Feb 2008 17:39 +0200:
> On Tue, Feb 12 2008 at 22:17 +0200, Pete Wyckoff <pw@osc.edu> wrote:
> > From: Pete Wyckoff <pw@osc.edu>
> > Subject: [PATCH] iscsi iser: varlen
> > 
> > Handle variable-length CDBs in iSER.
> > 
> > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > ---
> >  drivers/infiniband/ulp/iser/iscsi_iser.c     |    5 +++--
> >  drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +-
> >  drivers/infiniband/ulp/iser/iser_initiator.c |   16 ++++++++++------
> >  3 files changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > index 5f2284d..9dfc310 100644
> > --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> > +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > @@ -401,7 +401,8 @@ iscsi_iser_session_create(struct iscsi_transport *iscsit,
> >  		ctask      = session->cmds[i];
> >  		iser_ctask = ctask->dd_data;
> >  		ctask->hdr = (struct iscsi_cmd *)&iser_ctask->desc.iscsi_header;
> > -		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header);
> > +		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header) +
> > +				 sizeof(iser_ctask->desc.hdrextbuf);
> >  	}
> >  
> >  	for (i = 0; i < session->mgmtpool_max; i++) {
> > @@ -604,7 +605,7 @@ static struct iscsi_transport iscsi_iser_transport = {
> >  	.host_template          = &iscsi_iser_sht,
> >  	.conndata_size		= sizeof(struct iscsi_conn),
> >  	.max_lun                = ISCSI_ISER_MAX_LUN,
> > -	.max_cmd_len            = ISCSI_ISER_MAX_CMD_LEN,
> > +	.max_cmd_len            = 260,
> 
> Same bug I had. .max_cmd_len is still char, before the varlen patch to scsi-ml.
> So it must be at most 252, Until that patch is introduced and it can return to
> the correct 260 or better yet SCSI_MAX_VARLEN_CDB_SIZE. That also is only 
> defined in the scsi-ml varlen patch.

Ah, that is unfortunate.

> I'm afraid the varlen patches to block and scsi-ml are waiting because of
> me. There are more things I need to check, before they can get approved.
> 
> Once I do that, and varlen gets accepted, iSER and iscsi_tcp can go up 
> to 260 for the .max_cmd_len as they should.

I will sit on these iser changes until we get core varlen resolved,
then.  Or you can just sequence it all cleverly through the various
maintainers.

		-- Pete
