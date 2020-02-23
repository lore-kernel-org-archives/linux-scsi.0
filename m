Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6EEC35666
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB6C20836
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="OPTTjcUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBWTdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 14:33:04 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:45694 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgBWTdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 14:33:04 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 59E45412E2;
        Sun, 23 Feb 2020 19:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1582486369;
         x=1584300770; bh=+Gr80UM+IWPzIBYxusWxx+o/XgQULd5cPu3/CfSk0dI=; b=
        OPTTjcUCiDzvL28EOu4rCdwoyIBZq3EgLmaZIto3F8PK6GGJrX2jASa9tCGEan1I
        S+Qe/NmFwN2ThXMCSMJ+iEcS6DnmHWzTJefBcOauj7Hb2e6+Xnm4n8pd3uruzE+T
        fLRKMtHBhRHXw6pgEOM2W4OpG2RbfYpEZRuHolv7v+E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6zFYe77i0Bhb; Sun, 23 Feb 2020 22:32:49 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 29026412E0;
        Sun, 23 Feb 2020 22:32:49 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-01.corp.yadro.com
 (172.17.10.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sun, 23
 Feb 2020 22:32:48 +0300
Date:   Sun, 23 Feb 2020 22:32:48 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 2/5] qla2xxx: Suppress endianness complaints in
 qla2x00_configure_local_loop()
Message-ID: <20200223192709.slsitlpfww6t62iu@SPB-NB-133.local>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200220043441.20504-3-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-01.corp.yadro.com (172.17.10.101)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 08:34:38PM -0800, Bart Van Assche wrote:
> Instead of changing endianness in-place, write the data in CPU endian format
> in another buffer and copy that buffer back. This patch does not change any
> functionality but silences some sparse endianness warnings.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |  2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 9e6b56527b25..880f2be062a9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5068,13 +5068,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  			rval = qla24xx_get_port_login_templ(vha,
>  			    ha->init_cb_dma, (void *)ha->init_cb, sz);
>  			if (rval == QLA_SUCCESS) {
> +				__be32 *q = &ha->plogi_els_payld.data[0];
> +
>  				bp = (uint32_t *)ha->init_cb;
> -				for (i = 0; i < sz/4 ; i++, bp++)
> -					*bp = cpu_to_be32(*bp);
> +				cpu_to_be32_array(q, bp, sz / 4);
>  
> -				memcpy(&ha->plogi_els_payld.data,
> -				    (void *)ha->init_cb,
> -				    sizeof(ha->plogi_els_payld.data));
> +				memcpy(bp, q, sizeof(ha->plogi_els_payld.data));

Hi Bart,

Honestly, I'd prefer to drop the memcpy as it has no purpose, but since
you replicated a side-effect of the previous code and fixed sparse
warnings,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman

P.S.

During the review, I looked again where init_cb is used. It seems the
reuse and rewriting of init_cb contents by qla24xx_get_port_login_templ
may corrupt init_cb values expected by qla2x00_fdmi_rpa and
qla2x00_fdmiv2_rpa (they retrieve max frame size from Initialization
Control Block), and qla2x00_async_event (recovers WWPN from init_cb in
case of Fabric-assigned WWPN).

That _rpa functions are invoked if a port is in fabric topology and FDMI
registration is enabled, so a change of topology from P2P to Switched
Fabric may result in FDMI registration with wrong max frame size. I
don't know how FC switches use the value though.

If the fabric assigns WWPNs (FA-WWPN) and a disconnect happens (Loop
Down Event), the driver will try to recover WWPN from init_cb that is
corrupted by qla24xx_get_port_login_templ.

Probably, the wrong state may be recovered by reclaiming the underlying
PCI device. init_cb is set to correct values in probe() handler.
