Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DD8C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 23:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F097C2072E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 23:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Zb6Ug0AE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCXXvr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 19:51:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16220 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgCXXvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 19:51:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ONpbep019885;
        Tue, 24 Mar 2020 16:51:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=wNjZYgLBk9FU28dg4uTGsjIEHclN9BslL6umU7xYED0=;
 b=Zb6Ug0AE0cjdCC+iqkf6fF78SXK43JylyVTzLuV5jIzwY04o6u0a2TjPSQNggUAyTfS1
 8SUAUSNruJ0PZpRN8t3VI8EVxUVtEw6MBNJu1+Mc3glSiGFZcJ03+uCzysfWWuJLYm7+
 KC/G0JoUJndzUqL3AUvuNAZ+RLJTZroMOe63FHaa14kEaeyvNTwKOKNX1g6nYfylGx2v
 YAtB4Z+BTxTb6mDLFCkSHXHNF8Mso1IhFvAU9CqCXSQlMIF4LGGmp5pTl0SE264kXB+I
 +Kf1HDP9fVSROjIw1R40SEIFdVWzpE+iJd2kvMQLD0BXOvIsiJBoP9JYz4KdEXnqT5/u Zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqv2qp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 16:51:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 16:51:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 16:51:33 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 16:51:33 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 1358B3F703F;
        Tue, 24 Mar 2020 16:51:33 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02ONpWFr022511;
        Tue, 24 Mar 2020 16:51:32 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 24 Mar 2020 16:51:32 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
In-Reply-To: <20200205214422.3657-2-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2003241648560.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-2-mwilck@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_10:2020-03-23,2020-03-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 5 Feb 2020, 1:44pm, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip"),
> it is possible that FC commands are scheduled after the adapter firmware
> has been shut down. IO sent to the firmware in this situation hangs
> indefinitely. Avoid this for the LOGO code path that is typically taken
> when adapters are shut down.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
>  drivers/scsi/qla2xxx/qla_os.c  | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 9e09964..53129f2 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2644,6 +2644,9 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
>  	    "Entered %s.\n", __func__);
>  
> +	if (!ha->flags.fw_started)
> +		return QLA_FUNCTION_FAILED;
> +

Ok.

>  	lg = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
>  	if (lg == NULL) {
>  		ql_log(ql_log_warn, vha, 0x106e,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index b520a98..2dafb46 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4878,6 +4878,9 @@ qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
>  	unsigned long flags;
>  	bool q = false;
>  
> +	if (!vha->hw->flags.fw_started)
> +		return QLA_FUNCTION_FAILED;
> +

I'd probably not do it here; rather in qla2x00_get_sp() 
/qla2x00_start_sp()/ qla2xxx_get_qpair_sp() time. Not all works are for 
posting to firmware (QLA_EVT_IDC_ACK, QLA_EVT_UNMAP etc.).

Regards,
-Arun

>  	spin_lock_irqsave(&vha->work_lock, flags);
>  	list_add_tail(&e->list, &vha->work_list);
>  
> 
