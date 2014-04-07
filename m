From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/9] target: Pass in transport supported PI at session
 initialization
Date: Mon, 07 Apr 2014 01:01:55 -0700
Message-ID: <1396857715.19888.2.camel@haakon3.risingtidesystems.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
	 <1396517753-23546-3-git-send-email-nab@daterainc.com>
	 <53425386.7090507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55483 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaDGICD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 04:02:03 -0400
In-Reply-To: <53425386.7090507@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 2014-04-07 at 10:28 +0300, Sagi Grimberg wrote:
> On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > In order to support local WRITE_INSERT + READ_STRIP operations for
> > non PI enabled fabrics, the fabric driver needs to be able signal
> > what protection offload operations are supported.
> >
> > This is done at session initialization time so the modes can be
> > signaled by individual se_wwn + se_portal_group endpoints, as well
> > as optionally across different transports on the same endpoint.
> >
> > For iser-target, set TARGET_PROT_ALL if the underlying ib_device
> > has already signaled PI offload support, and allow this to be
> > exposed via a new iscsit_transport->iscsit_get_sup_prot_ops()
> > callback.
> >
> > For loopback, set TARGET_PROT_ALL to signal SCSI initiator mode
> > operation.
> >
> > For all other drivers, set TARGET_PROT_NORMAL to disable fabric
> > level PI.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Cc: Quinn Tran <quinn.tran@qlogic.com>
> > Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/infiniband/ulp/isert/ib_isert.c   |   13 +++++++++++++
> >   drivers/infiniband/ulp/srpt/ib_srpt.c     |    2 +-
> >   drivers/scsi/qla2xxx/tcm_qla2xxx.c        |    2 +-
> >   drivers/target/iscsi/iscsi_target.c       |    6 ++++++
> >   drivers/target/iscsi/iscsi_target_login.c |    4 +++-
> >   drivers/target/loopback/tcm_loop.c        |    2 +-
> >   drivers/target/sbp/sbp_target.c           |    2 +-
> >   drivers/target/target_core_transport.c    |    8 +++++---
> >   drivers/target/tcm_fc/tfc_sess.c          |    3 ++-
> >   drivers/usb/gadget/tcm_usb_gadget.c       |    2 +-
> >   drivers/vhost/scsi.c                      |    3 ++-
> >   include/target/iscsi/iscsi_transport.h    |    1 +
> >   include/target/target_core_base.h         |   19 ++++++++++++-------
> >   include/target/target_core_fabric.h       |    5 +++--
> >   14 files changed, 52 insertions(+), 20 deletions(-)
> >

<SNIP>

> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 96aee43..78cab13 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -511,6 +511,11 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> >   	__iscsit_free_cmd(cmd, scsi_cmd, true);
> >   }
> >   
> > +static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
> 
> I think it is more correct that this routine will return a bitmap (u32) 
> and not the enumeration itself.
> 

Yeah, I was originally unsure if using bitmask ops on enums was OK, but
AFAICT it's perfectly safe and works fine here for this case.

--nab 

