Return-Path: <SRS0=obCF=3E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B0AC33CB1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0917F214AF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjwdAYzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgAOQJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:09:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726132AbgAOQJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 11:09:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579104540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34KrPuJhSpABWmACd7lnUMtN40WHMToLq6uEajza/1M=;
        b=AjwdAYzU82jBqstFvxaq6oefpGX1/Yt7luPbjNunC3bn0/pwZZMcCYP9HLrvzpA2ZppTlg
        BQ501WYRTl9cymGDwaJuZCv/AyPJ6ScZN0P89y0xIQ4CF2F5kljZio9HeDB1xrsjdd8L9h
        v8ro5SBBNLOXw6KSxkdUCMDzJXxPknc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-MUNzfKqxMECq7_8YSWkulA-1; Wed, 15 Jan 2020 11:08:57 -0500
X-MC-Unique: MUNzfKqxMECq7_8YSWkulA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE2F718552D7;
        Wed, 15 Jan 2020 16:08:55 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C82008432B;
        Wed, 15 Jan 2020 16:08:54 +0000 (UTC)
Message-ID: <a6db9ede34fe62f849004801b5603179c7d6aa23.camel@redhat.com>
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
Date:   Wed, 15 Jan 2020 11:08:54 -0500
In-Reply-To: <feb96690-cedb-586b-d040-127c9c6262c2@acm.org>
References: <20200112210846.13421-1-bvanassche@acm.org>
         <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
         <086f02b8-b8d8-5336-bf2c-031293d95890@acm.org>
         <c2baf21f60daf91593bc4a7088427257434e2040.camel@redhat.com>
         <feb96690-cedb-586b-d040-127c9c6262c2@acm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-01-14 at 18:56 -0800, Bart Van Assche wrote:
> On 2020-01-14 10:13, Ewan D. Milne wrote:
> > Yes, but isn't that after "if (new_fcport == NULL)" where the code has
> > put the previously allocated fcport into the &vha->vp_fcports list and
> > was unable to allocate another one?
> 
> How about the (untested) patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> From 436e1552f79b3a3b7d3f3b1dea1df27c33bd0d49 Mon Sep 17 00:00:00 2001
> From: Bart Van Assche <bvanassche@acm.org>
> Date: Sun, 12 Jan 2020 09:17:37 -0800
> Subject: [PATCH v2] qla2xxx: Fix a NULL pointer dereference in an error path
> 
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
>  drivers/scsi/qla2xxx/qla_init.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index c4e087217484..62df78258269 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5109,7 +5109,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
>  	    &entries);
>  	if (rval != QLA_SUCCESS)
> -		goto cleanup_allocation;
> +		goto err;
> 
>  	ql_dbg(ql_dbg_disc, vha, 0x2011,
>  	    "Entries in ID list (%d).\n", entries);
> @@ -5139,7 +5139,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  		ql_log(ql_log_warn, vha, 0x2012,
>  		    "Memory allocation failed for fcport.\n");
>  		rval = QLA_MEMORY_ALLOC_FAILED;
> -		goto cleanup_allocation;
> +		goto err;
>  	}
>  	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
> 
> @@ -5229,7 +5229,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  				ql_log(ql_log_warn, vha, 0xd031,
>  				    "Failed to allocate memory for fcport.\n");
>  				rval = QLA_MEMORY_ALLOC_FAILED;
> -				goto cleanup_allocation;
> +				goto err;
>  			}
>  			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
>  			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
> @@ -5272,15 +5272,14 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  			qla24xx_fcport_handle_login(vha, fcport);
>  	}
> 
> -cleanup_allocation:
>  	qla2x00_free_fcport(new_fcport);
> 
> -	if (rval != QLA_SUCCESS) {
> -		ql_dbg(ql_dbg_disc, vha, 0x2098,
> -		    "Configure local loop error exit: rval=%x.\n", rval);
> -	}
> +	return rval;
> 
> -	return (rval);
> +err:
> +	ql_dbg(ql_dbg_disc, vha, 0x2098,
> +	       "Configure local loop error exit: rval=%x.\n", rval);
> +	return rval;
>  }
> 
>  static void
> 

That looks fine.  Thanks.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

