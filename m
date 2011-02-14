From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 18:31:55 +0900
Message-ID: <20110214183152E.fujita.tomonori@lab.ntt.co.jp>
References: <20110214181129X.fujita.tomonori@lab.ntt.co.jp>
	<1297675096.7114.59.camel@haakon2.linux-iscsi.org>
	<1297675175.7114.60.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57349 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1BNJcD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 04:32:03 -0500
In-Reply-To: <1297675175.7114.60.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, bvanassche@acm.org, linux-scsi@vger.kernel.org

On Mon, 14 Feb 2011 01:19:35 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Mon, 2011-02-14 at 01:18 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2011-02-14 at 18:11 +0900, FUJITA Tomonori wrote:
> > > On Mon, 14 Feb 2011 08:16:45 +0100
> > > Bart Van Assche <bvanassche@acm.org> wrote:
> > > 
> > > > Are you sure that it is fine to pass values like MSG_SIMPLE_TAG as the
> > > > sixth argument of transport_init_se_cmd() ? As far as I know TCM
> > > > doesn' t support any of the MSG_..._TAG values.
> > > 
> > > Oops, I'll send the next version soon.
> > 
> > Hi Tomo,
> > 
> > Target core is actually still using the TASK_ATTR_* defs for SCSI task
> > attributes from include/scsi/libsas.h..  These should probably be
> > converted to use something generic, and I think scsi_tcq.h:MSG_* would
> > sufficent, but appears to be missing some extra SCSI task attrs.
> > 
> > In any event, here is a patch against your rev2 to address the
> > short-term for lio-core-2.6.git/tcm_ibmvscsis code, please give your
> > sign-off, and I will get this pushed into LIO upstream.
> > 
> > Thanks!
> > 
> > --nab
> > 
> > diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
> > index 591cedb..36acaa1 100644
> > --- a/drivers/scsi/ibmvscsi/ibmvscsis.c
> > +++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
> > @@ -37,6 +37,7 @@
> >  #include <scsi/scsi_cmnd.h>
> >  #include <scsi/scsi_tcq.h>
> >  #include <scsi/libsrp.h>
> > +#include <scsi/libsas.h> /* For TASK_ATTR_* */
> >  #include <generated/utsrelease.h>
> >  
> >  #include <target/target_core_base.h>
> > @@ -855,18 +856,18 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
> >  
> >         switch (cmd->task_attr) {
> >         case SRP_SIMPLE_TASK:
> > -               attr = MSG_SIMPLE_TAG;
> > +               attr = TASK_ATTR_SIMPLE;
> >                 break;
> >         case SRP_ORDERED_TASK:
> > -               attr = MSG_ORDERED_TAG;
> > +               attr = TASK_ATTR_ORDERED;
> >                 break;
> >         case SRP_HEAD_TASK:
> > -               attr = MSG_HEAD_TAG;
> > +               attr = TASK_ATTR_HOQ;
> >                 break;
> >         default:
> >                 printk(KERN_WARNING "Task attribute %d not supported\n",
> >                        cmd->task_attr);
> > -               attr = MSG_SIMPLE_TAG;
> > +               attr = TASK_ATTR_ACA;
> >         }
> >  
> 
> Ugh sorry, this last one should be TASK_ATTR_SIMPLE..

No point to commit this kinda of a fix separately. I'll fold your
patch and send the third version soon.

Thanks,
