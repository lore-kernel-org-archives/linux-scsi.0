Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8B2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0108613C4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhDTRfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:35:48 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:50012 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233385AbhDTRfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 13:35:47 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 43031413BC;
        Tue, 20 Apr 2021 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1618940112;
         x=1620754513; bh=gtHB4X6OBPtphw6qgVBbtxFbjmv0plZPhR8HC/80iRY=; b=
        S43gJTr6XmwUOfpkuXHu4WW5J1ZRr0ADax1HjpKq3PRkd5n1QOJRvAKFl/meo3HB
        CSVYElRzhzX26kwQ7s1vMzhnTCX9KsPu+vODvnlr2GiFzZalh4eapTPK8Xs9ODvE
        RDF/TSQJlYyoqkN/dfxNCYnbMd4CYC7/9XoCZQM1qiY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vdTIneeNX64c; Tue, 20 Apr 2021 20:35:12 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2D48F41312;
        Tue, 20 Apr 2021 20:35:11 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 20
 Apr 2021 20:35:11 +0300
Date:   Tue, 20 Apr 2021 20:35:10 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-nvme@lists.infradead.org>, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Message-ID: <YH8QzgWiec8vka20@SPB-NB-133.local>
References: <20210419100014.47144-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210419100014.47144-1-dwagner@suse.de>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 12:00:14PM +0200, Daniel Wagner wrote:
> 
> The QLogic only expose the rports via fc_remote_ports if SCSI is used.
> There is the debugfs interface to set the dev_loss_tmo but this has
> two issues. First, it's not watched by udevd hence no rules work. This
> could be somehow worked around by setting it statically, but that is
> really only an option for testing. Even if the debugfs interface is
> used there is a bug in the code. In qla_nvme_register_remote() the
> value 0 is assigned to dev_loss_tmo and the NVMe core will use it's
> default value 60 (this code path is exercised if the rport droppes
> twice).
> 
> Anyway, this patch is just to get the discussion going. Maybe the
> driver could implement the fc_remote_port interface? Hannes was
> pointing out it might make sense to think about an controller sysfs
> API as there is already a host and the NVMe protocol is all about host
> and controller.
> 

Hi Daniel,

I agree that proper fc_remote_ports interface is needed for NVMe in
qla2xxx.

There was a similar concern from me when the dev_loss_tmo setting in
debugfs was added to the driver. Arun agreed the debugfs approach is a
crutch but the discussion never took off beyond that:

https://patchwork.kernel.org/project/linux-scsi/patch/20200818123203.20361-4-njavali@marvell.com/#23553423

+ James S.

Daniel, WRT to your patch I don't think we should add one more approach
to set dev_loss_tmo via kernel module parameter as NVMe adopters are
going to be even more confused about the parameter. Just imagine
knowledge bases populated with all sorts of the workarounds, that apply
to kernel version x, y, z, etc :)

What exists for FCP/SCSI is quite clear and reasonable. I don't know why
FC-NVMe rports should be way too different.

Thanks,
Roman

> Thanks,
> Daniel
> 
>  drivers/scsi/qla2xxx/qla_attr.c | 4 ++--
>  drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 5 +++++
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3aa9869f6fae..0d2386ba65c0 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3036,7 +3036,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
>  	}
>  
>  	/* initialize attributes */
> -	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
> +	fc_host_dev_loss_tmo(vha->host) = ql2xdev_loss_tmo;
>  	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
>  	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
>  	fc_host_supported_classes(vha->host) =
> @@ -3260,7 +3260,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
>  	struct qla_hw_data *ha = vha->hw;
>  	u32 speeds = FC_PORTSPEED_UNKNOWN;
>  
> -	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
> +	fc_host_dev_loss_tmo(vha->host) = ql2xdev_loss_tmo;
>  	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
>  	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
>  	fc_host_supported_classes(vha->host) = ha->base_qpair->enable_class_2 ?
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..0b9c24475711 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -178,6 +178,7 @@ extern int ql2xdifbundlinginternalbuffers;
>  extern int ql2xfulldump_on_mpifail;
>  extern int ql2xenforce_iocb_limit;
>  extern int ql2xabts_wait_nvme;
> +extern int ql2xdev_loss_tmo;
>  
>  extern int qla2x00_loop_reset(scsi_qla_host_t *);
>  extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0cacb667a88b..cdc5b5075407 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -41,7 +41,7 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
>  	req.port_name = wwn_to_u64(fcport->port_name);
>  	req.node_name = wwn_to_u64(fcport->node_name);
>  	req.port_role = 0;
> -	req.dev_loss_tmo = 0;
> +	req.dev_loss_tmo = ql2xdev_loss_tmo;
>  
>  	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_INITIATOR)
>  		req.port_role = FC_PORT_ROLE_NVME_INITIATOR;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d74c32f84ef5..c686522ff64e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -338,6 +338,11 @@ static void qla2x00_free_device(scsi_qla_host_t *);
>  static int qla2xxx_map_queues(struct Scsi_Host *shost);
>  static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
>  
> +int ql2xdev_loss_tmo = 60;
> +module_param(ql2xdev_loss_tmo, int, 0444);
> +MODULE_PARM_DESC(ql2xdev_loss_tmo,
> +		"Time to wait for device to recover before reporting\n"
> +		"an error. Default is 60 seconds\n");
>  
>  static struct scsi_transport_template *qla2xxx_transport_template = NULL;
>  struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
> -- 
> 2.29.2
> 
