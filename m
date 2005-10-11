From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [SCSI] qla2xxx: fix remote port timeout with qla2xxx driver
Date: Tue, 11 Oct 2005 16:31:08 -0700
Message-ID: <20051011233108.GA25279@plap.qlogic.org>
References: <200510031643.j93GhgRY023585@hera.kernel.org> <20051010170136.GA9736@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:2594 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932352AbVJKXbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 19:31:11 -0400
Content-Disposition: inline
In-Reply-To: <20051010170136.GA9736@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, 10 Oct 2005, Olaf Hering wrote:

>  On Mon, Oct 03, Linux Kernel Mailing List wrote:
> 
> > tree e50f57f9c85bacf3fc07359b1a339432dea31a7a
> > parent 6f3a20242db2597312c50abc11f1e747c5d2326a
> > author Andrew Vasquez <andrew.vasquez@qlogic.com> Wed, 21 Sep 2005 03:32:11 -0700
> > committer James Bottomley <jejb@mulgrave.(none)> Sun, 25 Sep 2005 22:11:35 -0500
> > 
> > [SCSI] qla2xxx: fix remote port timeout with qla2xxx driver
> > diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
> > --- a/drivers/scsi/qla2xxx/qla_rscn.c
> > +++ b/drivers/scsi/qla2xxx/qla_rscn.c
> > @@ -330,6 +330,8 @@ qla2x00_update_login_fcport(scsi_qla_hos
> >  	fcport->flags &= ~FCF_FAILOVER_NEEDED;
> >  	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
> >  	atomic_set(&fcport->state, FCS_ONLINE);
> > +	if (fcport->rport)
> > +		fc_remote_port_unblock(fcport->rport);
> 
> 
> This patch lacks an #include, probably scsi/scsi_transport_fc.h:
> 
> drivers/scsi/qla2xxx/qla_rscn.c:334: error: implicit declaration of function 'fc_remote_port_unblock'

Yes,  here's a one-liner to add the proper include.

---

diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
index 1eba988..11682a2 100644
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -18,6 +18,8 @@
  */
 #include "qla_def.h"
 
+#include <scsi/scsi_transport_fc.h>
+
 /**
  * IO descriptor handle definitions.
  *
