From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: qla2xxx: Fix NULL pointer access for fcport
 structure
Date: Tue, 9 Jan 2018 14:06:57 +0300
Message-ID: <20180109110657.aczzcwzrsw6ye6my@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57568 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbeAILHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2018 06:07:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: quinn.tran@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello Quinn Tran,

This is a semi-automatic email about new static checker warnings.

The patch 5c25d451163c: "scsi: qla2xxx: Fix NULL pointer access for
fcport structure" from Dec 28, 2017, leads to the following Smatch
complaint:

    drivers/scsi/qla2xxx/qla_init.c:130 qla2x00_async_iocb_timeout()
    error: we previously assumed 'fcport' could be null (see line 107)

drivers/scsi/qla2xxx/qla_init.c
   106	
   107		if (fcport) {
                    ^^^^^^^
The patch adds a check for NULL.

   108			ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
   109			    "Async-%s timeout - hdl=%x portid=%06x %8phC.\n",
   110			    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
   111	
   112			fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
   113		} else {
   114			pr_info("Async-%s timeout - hdl=%x.\n",
   115			    sp->name, sp->handle);
   116		}
   117	
   118		switch (sp->type) {
   119		case SRB_LOGIN_CMD:
   120			/* Retry as needed. */
   121			lio->u.logio.data[0] = MBS_COMMAND_ERROR;
   122			lio->u.logio.data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
   123				QLA_LOGIO_LOGIN_RETRIED : 0;
   124			memset(&ea, 0, sizeof(ea));
   125			ea.event = FCME_PLOGI_DONE;
   126			ea.fcport = sp->fcport;
   127			ea.data[0] = lio->u.logio.data[0];
   128			ea.data[1] = lio->u.logio.data[1];
   129			ea.sp = sp;
   130			qla24xx_handle_plogi_done_event(fcport->vha, &ea);
                                                        ^^^^^^^^^^^
But there is an unchecked NULL dereference here.

   131			break;
   132		case SRB_LOGOUT_CMD:

regards,
dan carpenter
