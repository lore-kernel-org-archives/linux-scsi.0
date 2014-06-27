From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Date: Fri, 27 Jun 2014 13:52:31 +0200
Message-ID: <1403869951.11208.30.camel@br9vgx5g.de.ibm.com>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
	 <1403850425-89297-7-git-send-email-hare@suse.de>
	 <53AD4BDB.2040707@linux.vnet.ibm.com> <53AD4FA1.8090502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49507 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaF0Lwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 07:52:38 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Fri, 27 Jun 2014 12:52:36 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5E66217D805F
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 12:54:01 +0100 (BST)
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5RBqW1I26345522
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 11:52:32 GMT
Received: from d06av11.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5RBqV9g028168
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 05:52:32 -0600
In-Reply-To: <53AD4FA1.8090502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, 2014-06-27 at 13:04 +0200, Hannes Reinecke wrote:
> On 06/27/2014 12:47 PM, Steffen Maier wrote:
> > On 06/27/2014 08:27 AM, Hannes Reinecke wrote:
> >> Issuing a host reset should not rely on any commands.
> >> So use Scsi_Host as argument for eh_host_reset_handler.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >
> >>   drivers/s390/scsi/zfcp_scsi.c             |  3 +-
> >
> >>   69 files changed, 289 insertions(+), 379 deletions(-)
> >
> >> diff --git a/drivers/s390/scsi/zfcp_scsi.c
> >> b/drivers/s390/scsi/zfcp_scsi.c
> >> index dc42c93..fe50f69 100644
> >> --- a/drivers/s390/scsi/zfcp_scsi.c
> >> +++ b/drivers/s390/scsi/zfcp_scsi.c
> >> @@ -281,13 +281,14 @@ static int
> >> zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> >>       return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
> >>   }
> >>
> >> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpn=
t)
> >> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host=
)
> >>   {
> >>       struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->devi=
ce);
> >
> > Scpnt argument no longer exists, so this line must likely go away t=
o
> > compile.
> >
> >>       struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
> >
> > This needs the assignment from the added line below since zfcp_sdev
> > no longer exists.
> > Alternatively, drop the assignment here, only have the auto variabl=
e
> > definition, and do the assignment below with the added line.
> >
> >>       struct fc_rport *rport =3D zfcp_sdev->port->rport;
> >>       int ret;
> >>
> >> +    adapter =3D (struct zfcp_adapter *)host->hostdata[0];
> >>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
> >>       zfcp_erp_wait(adapter);
> >>       ret =3D fc_block_scsi_eh(rport);
> >
> > A question just for my understanding: Calling fc_block_scsi_eh at
> > the end *after* our adapter recovery is OK to wait for rports to
> > become unblocked (or fast_io_failed)?
> > I would guess so.
> >
> Hehe. That's actually a question for _you_ :-)

git says:

commit af4de36d911ab907b92c5f3f81ceff8474ed7485
Author: Christof Schmitt <christof.schmitt@de.ibm.com>
Date:   Tue Nov 24 16:54:16 2009 +0100

    [SCSI] zfcp: Block scsi_eh thread for rport state BLOCKED
   =20
    In case the SCSI error recovery starts because of a SCSI command
    timeout, but then something else triggers the rport to be deleted,
    the SCSI error recovery will run to the end and set the SCSI device
    offline. To prevent this, call the FC transport function
    fc_block_scsi_eh which waits until the rport leaves the BLOCKED
    state. This guarantees that communication is possible if the rport
    is ONLINE, or the SCSI devices will be removed if the rport state
    switches to NOT_PRESENT.


Not sure if this reasoning is (still) valid.

Isn't command timeouts the only reason for scsi eh to kick in?

Martin
--=20
Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
