Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42A8C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 15:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A01207E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 15:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMVhXmWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgAMP3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 10:29:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgAMP3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 10:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578929393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7/u5aAd44E0y5Zjk/8NnL1JzNYBW86t+w83BW1uCgI=;
        b=aMVhXmWcjwvkVKSZCHXSHUchUaVmXycMTpq7s2aOCmRg34lBQAXg8KhytAdHmBtG0I8cci
        pIgMbV/8JJp5TGV9WJSikPxWh5S/bGjUa+puzm5aglP6Bblf3QKyXRHhQMUFmGlWJW/ekZ
        P+SoOUJzcfKueDdWPrmuB38x1EMy43g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-Bqy38XnkMOeDTb52kuMEXA-1; Mon, 13 Jan 2020 10:29:49 -0500
X-MC-Unique: Bqy38XnkMOeDTb52kuMEXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E0710054E3;
        Mon, 13 Jan 2020 15:29:48 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63E361A7E3;
        Mon, 13 Jan 2020 15:29:47 +0000 (UTC)
Message-ID: <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Mon, 13 Jan 2020 10:29:46 -0500
In-Reply-To: <20200112210846.13421-1-bvanassche@acm.org>
References: <20200112210846.13421-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-01-12 at 13:08 -0800, Bart Van Assche wrote:
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
> > > >     CID 353340:    (FORWARD_NULL)
> > > >     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
> 
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
> > > >     CID 353340:    (FORWARD_NULL)
> > > >     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
> 
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
> Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index c4e087217484..6560908ed50e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4895,6 +4895,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
>  void
>  qla2x00_free_fcport(fc_port_t *fcport)
>  {
> +	if (!fcport)
> +		return;
>  	if (fcport->ct_desc.ct_sns) {
>  		dma_free_coherent(&fcport->vha->hw->pdev->dev,
>  			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,
> 

I would have fixed this by moving the label to be after the qla2x00_free_fcport()
call in qla2x00_configure_local_loop(), which Coverity complained about.  And
called it something different.  (The code could probably be simplified by only
making a call to qla2x00_alloc_fcport() in one place, something to think about...)

I also notice that there is duplicate code in qla2x00_alloc_fcport() that tests for:

        if (!fcport->ct_desc.ct_sns)

But, this should fix the Coverity issue.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

