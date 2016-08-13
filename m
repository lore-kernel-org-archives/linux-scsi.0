From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v3 03/13] iscsi-target: add void (*iscsit_get_rx_pdu)()
Date: Sat, 13 Aug 2016 22:26:02 +0530
Message-ID: <20160813165600.GA2372@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
 <f993801e40717417bb752ddeb20765b25b092584.1461088672.git.varun@chelsio.com>
 <684b7d66-ee8b-a2fd-c949-1e449df1e8a1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:57117 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbcHMQ4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2016 12:56:21 -0400
Content-Disposition: inline
In-Reply-To: <684b7d66-ee8b-a2fd-c949-1e449df1e8a1@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, SWise OGC <swise@opengridcomputing.com>, "kxie@chelsio.com" <kxie@chelsio.com>, Indranil Choudhury <indranil@chelsio.com>

Hi Andy,

On Tue, Aug 09, 2016 at 08:49:41AM +0530, Andy Grover wrote:
> Hi Varun,
> 
> On 04/19/2016 11:30 AM, Varun Prakash wrote:
> > Add void (*iscsit_get_rx_pdu)() to
> > struct iscsit_transport, iscsi-target
> > uses this callback to receive and
> > process Rx iSCSI PDUs.
> >
> > cxgbit.ko needs this callback to
> > reuse iscsi-target Rx thread.
> >
> > Signed-off-by: Varun Prakash <varun@chelsio.com>
> > Acked-by: Sagi Grimberg <sagi@grimberg.me>
> > ---
> >  drivers/infiniband/ulp/isert/ib_isert.c | 10 ++++++++++
> >  drivers/target/iscsi/iscsi_target.c     | 10 ++--------
> >  include/target/iscsi/iscsi_transport.h  |  1 +
> >  3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> > index 411e446..9118d7c 100644
> > --- a/drivers/infiniband/ulp/isert/ib_isert.c
> > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> > @@ -3273,6 +3273,15 @@ static void isert_free_conn(struct iscsi_conn *conn)
> >  	isert_put_conn(isert_conn);
> >  }
> >
> > +static void isert_get_rx_pdu(struct iscsi_conn *conn)
> > +{
> > +	struct completion comp;
> > +
> > +	init_completion(&comp);
> > +
> > +	wait_for_completion_interruptible(&comp);
> > +}
> > +
> 
> Does this mean that the iser rx thread just does nothing and waits to 
> receive a signal to exit?

Yes.

> 
> If we don't set *iscsit_get_rx_pdu for iser, so the thread exits 
> immediately from iscsi_target_rx_thread, would that be an ok change?

I think it may need few more changes to remove Rx thread.
Please see Nicholas's comment on this issue.

https://www.spinics.net/lists/target-devel/msg12269.html

Thanks
Varun
