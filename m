Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF8AC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 22:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396C62078D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 22:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EeZ7exKA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgHSWJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 18:09:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgHSWJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 18:09:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JLoARX000484;
        Wed, 19 Aug 2020 15:09:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=RsHMlTR0bBQh8CQo7LsgpJOb0UMZAa94ugrr1OJwXGk=;
 b=EeZ7exKAY/HcjrDLLCsgK2PYK8rdQ9YgKAvWpaSAweKDnmCt/B08G4qJQbth0N2GT2Gh
 FRkTW5WftA9g/V93KAukkjf2gZjVQ46Li0sSLntWg5uy+KVLXXU7U4xDOoEGn0mZFoge
 MvdoI8fQgVP3LTVUuihMZW3x5+zVWoGUW3lt330m8q+wH2F4xJkpQ4q92T+brgm0v7nU
 GPZPPxLfh2irKR7kQDcqtIHaeDQElZEDFGWyQaMsexJB2UDrUiCHpajdaTAIBhhq5BbA
 x00holf+BBwku6NWiUEpXklxGVO5CmQrhC23haroiLJ+wtfrJDJDbvuFl9bnNjgjV4DD +A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhsyy0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 15:09:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 15:09:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 15:09:51 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 8B5623F703F;
        Wed, 19 Aug 2020 15:09:51 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 07JM9psq012999;
        Wed, 19 Aug 2020 15:09:51 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 19 Aug 2020 15:09:50 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Roman Bolshakov <r.bolshakov@yadro.com>
CC:     James Smart <james.smart@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/12] qla2xxx: Allow dev_loss_tmo setting for FC-NVMe
 devices
In-Reply-To: <20200818132408.GB74567@SPB-NB-133.local>
Message-ID: <alpine.LRH.2.21.9999.2008191409410.31539@irv1user01.caveonetworks.com>
References: <20200818123203.20361-1-njavali@marvell.com>
 <20200818123203.20361-4-njavali@marvell.com>
 <20200818132408.GB74567@SPB-NB-133.local>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+James S.

Hi Roman,

On Tue, 18 Aug 2020, 6:24am, Roman Bolshakov wrote:

> 
> On Tue, Aug 18, 2020 at 05:31:54AM -0700, Nilesh Javali wrote:
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > Add a remote port debugfs entry to get/set dev_loss_tmo for NVMe
> > devices.
> > 
> > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_dfs.c | 54 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> > index 3c4b9b549b17..7482e6bf7f7f 100644
> > --- a/drivers/scsi/qla2xxx/qla_dfs.c
> > +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> > @@ -12,6 +12,57 @@
> >  static struct dentry *qla2x00_dfs_root;
> >  static atomic_t qla2x00_dfs_root_count;
> >  
> > +#define QLA_DFS_RPORT_DEVLOSS_TMO	1
> > +
> > +static int
> > +qla_dfs_rport_get(struct fc_port *fp, int attr_id, u64 *val)
> > +{
> > +	switch (attr_id) {
> > +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> > +		/* Only supported for FC-NVMe devices that are registered. */
> > +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> > +			return -EIO;
> > +		*val = fp->nvme_remote_port->dev_loss_tmo;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int
> > +qla_dfs_rport_set(struct fc_port *fp, int attr_id, u64 val)
> > +{
> > +	switch (attr_id) {
> > +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> > +		/* Only supported for FC-NVMe devices that are registered. */
> > +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> > +			return -EIO;
> > +		return nvme_fc_set_remoteport_devloss(fp->nvme_remote_port,
> > +						      val);
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> > +
> > +#define DEFINE_QLA_DFS_RPORT_RW_ATTR(_attr_id, _attr)		\
> > +static int qla_dfs_rport_##_attr##_get(void *data, u64 *val)	\
> > +{								\
> > +	struct fc_port *fp = data;				\
> > +	return qla_dfs_rport_get(fp, _attr_id, val);		\
> > +}								\
> > +static int qla_dfs_rport_##_attr##_set(void *data, u64 val)	\
> > +{								\
> > +	struct fc_port *fp = data;				\
> > +	return qla_dfs_rport_set(fp, _attr_id, val);		\
> > +}								\
> > +DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		\
> > +		qla_dfs_rport_##_attr##_get,			\
> > +		qla_dfs_rport_##_attr##_set, "%llu\n")
> > +
> > +DEFINE_QLA_DFS_RPORT_RW_ATTR(QLA_DFS_RPORT_DEVLOSS_TMO, dev_loss_tmo);
> > +
> >  void
> >  qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
> >  {
> > @@ -24,6 +75,9 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
> >  	fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
> >  	if (!fp->dfs_rport_dir)
> >  		return;
> > +	if (NVME_TARGET(vha->hw, fp))
> > +		debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,
> > +				    fp, &qla_dfs_rport_dev_loss_tmo_fops);
> >  }
> >  
> >  void
> > -- 
> > 2.19.0.rc0
> > 
> 
> Hi Arun,
> 
> I don't think that the setting should be in debugfs. IMO there should be
> separate fc_remote_ports entry for FCP and FC-NVMe, one per PRLI for
> multi-protocol targets.
> 
> That'd be consistent with what exists for FCP and would allow
> similar configuration of dev_loss_tmo from multipath. It'd also provide
> semantics of per-rport PRLO to allow logout from either of the protocol
> but leaving second rport/session online.
> 

Thanks for your comments. This debugfs way is sort of a crutch, but that 
is something a user could use to set for FC-NVME dev_loss_tmo until a 
FC-NVME sysfs node hierarchy for a FC initiator (similar to FCP) comes 
into place.

BTW, the above setting is specific for FC-NVME, and is separate from FCP; 
so PRLO semantics can still be met.

Copying James for his thoughts on the topic (on dev_loss_tmo setting). 
James, would you mind sharing your ideas you'd considered?

Regards,
-Arun
