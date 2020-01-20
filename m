Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D87C33CB1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 08:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44AD7207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 08:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgATI6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 03:58:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:52778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgATI6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 03:58:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EEFE8AE92;
        Mon, 20 Jan 2020 08:58:44 +0000 (UTC)
Date:   Mon, 20 Jan 2020 09:58:44 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
Message-ID: <20200120085844.icz5cvx5vx5erao3@beryllium.lan>
References: <20200118042056.32232-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118042056.32232-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 08:20:56PM -0800, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint:
> 
> FORWARD_NULL
> 
> qla_init.c: 5275 in qla2x00_configure_local_loop()
> 5269
> 5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
> 5271     			qla24xx_fcport_handle_login(vha, fcport);
> 5272     	}
> 5273
> 5274     cleanup_allocation:
> >>>     CID 353340:    (FORWARD_NULL)
> >>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
> 5275     	qla2x00_free_fcport(new_fcport);
> 5276
> 5277     	if (rval != QLA_SUCCESS) {
> 5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
> 5279     		    "Configure local loop error exit: rval=%x.\n", rval);
> 5280     	}
> qla_init.c: 5275 in qla2x00_configure_local_loop()
> 5269
> 5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
> 5271     			qla24xx_fcport_handle_login(vha, fcport);
> 5272     	}
> 5273
> 5274     cleanup_allocation:
> >>>     CID 353340:    (FORWARD_NULL)
> >>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
> 5275     	qla2x00_free_fcport(new_fcport);
> 5276
> 5277     	if (rval != QLA_SUCCESS) {
> 5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
> 5279     		    "Configure local loop error exit: rval=%x.\n", rval);
> 5280     	}
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

