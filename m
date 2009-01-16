From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 15:28:37 -0500
Message-ID: <1232137717.3224.54.camel@localhost.localdomain>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
	 <1232131733.3224.46.camel@localhost.localdomain>
	 <20090116110708.75c5828d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54614 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937165AbZAPU2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 15:28:54 -0500
In-Reply-To: <20090116110708.75c5828d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 11:07 -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 13:48:53 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > > > @@ -1258,35 +1258,48 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
> > > >  {
> > > >  	int	rval;
> > > >  	unsigned long flags = 0;
> > > > -	int cnt;
> > > > +	int cnt, que;
> > > >  	struct qla_hw_data *ha = vha->hw;
> > > > -	struct req_que *req = ha->req_q_map[0];
> > > > -	struct rsp_que *rsp = ha->rsp_q_map[0];
> > > > +	struct req_que *req;
> > > > +	struct rsp_que *rsp;
> > > > +	struct scsi_qla_host *vp;
> > > >  	struct mid_init_cb_24xx *mid_init_cb =
> > > >  	    (struct mid_init_cb_24xx *) ha->init_cb;
> > > 
> > > This cast worries me.  It's a cast between two complex data structures
> > > which appear to have nothing to do with each other.
> > 
> > Actually, it's a C++ type construct.  ha->init_cb is of type init_cb_t,
> > mid_init_cb actually contains this (via a second indirection) as the
> > first element, so what it's doing is dynamically casting out based on
> > the board type.
> 
> Ah, OK, I got lost amongst the typedefs and pointers.
> 
> This code could/should use container_of() for this operation?

It could, but since it's a double cast out it would get a lot uglier. We
don't really pick up any safety from this because the FW structure is
shared with the device, so no-one can move the first element anyway.

James


