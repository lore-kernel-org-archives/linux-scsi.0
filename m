Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1458DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 19:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF19F20888
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 19:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390394AbgEZTR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 15:17:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:37876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391561AbgEZTR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 15:17:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 49033AE2E;
        Tue, 26 May 2020 19:17:59 +0000 (UTC)
Message-ID: <c8e5cc8030542ee8b39639135534c6fe843a7b33.camel@suse.com>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
From:   Martin Wilck <mwilck@suse.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        stable@vger.kernel.org
Date:   Tue, 26 May 2020 21:17:54 +0200
In-Reply-To: <20200518232248.GG75422@SPB-NB-133.local>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
         <20200518232248.GG75422@SPB-NB-133.local>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-05-19 at 02:22 +0300, Roman Bolshakov wrote:
> On Mon, May 18, 2020 at 09:31:42PM +0300, Roman Bolshakov wrote:
> > 
> 
> P.S. A little bit cleaner alternative would be to avoid session
> deletion
> only if scan needed is set (that allows session deletion of initiator
> ports after fabric discovery if N_Port ID change happened). Please
> let
> me know if I should submit v2 like this:
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c
> b/drivers/scsi/qla2xxx/qla_gs.c
> index 42c3ad27f1cb..b9955af5cffe 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3495,8 +3495,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t
> *vha, srb_t *sp)
>  			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
>  				qla2x00_clear_loop_id(fcport);
>  				fcport->flags |= FCF_FABRIC_DEVICE;
> -			} else if (fcport->d_id.b24 != rp->id.b24 ||
> -				fcport->scan_needed) {
> +			} else if (fcport->d_id.b24 != rp->id.b24 ||
> +				   (fcport->scan_needed &&
> +				    fcport->port_type != FCT_INITIATOR
> &&
> +				    fcport->port_type !=
> FCT_NVME_INITIATOR)) {
>  				qlt_schedule_sess_for_deletion(fcport);
>  			}
>  			fcport->d_id.b24 = rp->id.b24;


Yes, this looks like an improvement to me. To express it in my own
words (as the logic is subtle): wrt the original code, this only
changes the behavior if the NPort ID is unchanged but "scan_needed" is
set - in this case the session used to be deleted, but with this patch
it isn't any more.

Thanks,
Martin


