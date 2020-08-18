Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB43C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 13:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D96206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 13:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="R1fOEhuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHRNYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:24:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35016 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726398AbgHRNYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 09:24:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B69D054DBE;
        Tue, 18 Aug 2020 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1597757049;
         x=1599571450; bh=9q5tbBV8fz/T9bKzQ+Ps/f/p4Amywfsfi2ipSr+wRMw=; b=
        R1fOEhuwrk6Ddt/Ol/8VYShSZZq2U6IB22Hq52+t0XiJ2FG5VPFjelsor9g2M06s
        sTr4BM22vJfMsNqifc3giFUUYYSDOhSDzvYz2F7Lv0/4oPiBuRBEqiliETf0RhkQ
        4YYCDNBLn5dVenFHhXcIq8PwmRlApVoHhONrqbY/xq4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NSN3-LQLpvbF; Tue, 18 Aug 2020 16:24:09 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2DCA254D38;
        Tue, 18 Aug 2020 16:24:09 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 18
 Aug 2020 16:24:09 +0300
Date:   Tue, 18 Aug 2020 16:24:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/12] qla2xxx: Allow dev_loss_tmo setting for FC-NVMe
 devices
Message-ID: <20200818132408.GB74567@SPB-NB-133.local>
References: <20200818123203.20361-1-njavali@marvell.com>
 <20200818123203.20361-4-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200818123203.20361-4-njavali@marvell.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 18, 2020 at 05:31:54AM -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Add a remote port debugfs entry to get/set dev_loss_tmo for NVMe
> devices.
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_dfs.c | 54 ++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> index 3c4b9b549b17..7482e6bf7f7f 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -12,6 +12,57 @@
>  static struct dentry *qla2x00_dfs_root;
>  static atomic_t qla2x00_dfs_root_count;
>  
> +#define QLA_DFS_RPORT_DEVLOSS_TMO	1
> +
> +static int
> +qla_dfs_rport_get(struct fc_port *fp, int attr_id, u64 *val)
> +{
> +	switch (attr_id) {
> +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> +		/* Only supported for FC-NVMe devices that are registered. */
> +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> +			return -EIO;
> +		*val = fp->nvme_remote_port->dev_loss_tmo;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int
> +qla_dfs_rport_set(struct fc_port *fp, int attr_id, u64 val)
> +{
> +	switch (attr_id) {
> +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> +		/* Only supported for FC-NVMe devices that are registered. */
> +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> +			return -EIO;
> +		return nvme_fc_set_remoteport_devloss(fp->nvme_remote_port,
> +						      val);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +#define DEFINE_QLA_DFS_RPORT_RW_ATTR(_attr_id, _attr)		\
> +static int qla_dfs_rport_##_attr##_get(void *data, u64 *val)	\
> +{								\
> +	struct fc_port *fp = data;				\
> +	return qla_dfs_rport_get(fp, _attr_id, val);		\
> +}								\
> +static int qla_dfs_rport_##_attr##_set(void *data, u64 val)	\
> +{								\
> +	struct fc_port *fp = data;				\
> +	return qla_dfs_rport_set(fp, _attr_id, val);		\
> +}								\
> +DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		\
> +		qla_dfs_rport_##_attr##_get,			\
> +		qla_dfs_rport_##_attr##_set, "%llu\n")
> +
> +DEFINE_QLA_DFS_RPORT_RW_ATTR(QLA_DFS_RPORT_DEVLOSS_TMO, dev_loss_tmo);
> +
>  void
>  qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
>  {
> @@ -24,6 +75,9 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
>  	fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
>  	if (!fp->dfs_rport_dir)
>  		return;
> +	if (NVME_TARGET(vha->hw, fp))
> +		debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,
> +				    fp, &qla_dfs_rport_dev_loss_tmo_fops);
>  }
>  
>  void
> -- 
> 2.19.0.rc0
> 

Hi Arun,

I don't think that the setting should be in debugfs. IMO there should be
separate fc_remote_ports entry for FCP and FC-NVMe, one per PRLI for
multi-protocol targets.

That'd be consistent with what exists for FCP and would allow
similar configuration of dev_loss_tmo from multipath. It'd also provide
semantics of per-rport PRLO to allow logout from either of the protocol
but leaving second rport/session online.

Thanks,
Roman
