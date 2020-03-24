Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85B4C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 22:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFA72078A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 22:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NT7f2p2/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgCXWfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 18:35:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61498 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728289AbgCXWfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OMYh8A031721;
        Tue, 24 Mar 2020 15:35:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=cMKd2m1+jVHUb7K8u5gG0Sco5EUi72V6LUV0N+4sYBo=;
 b=NT7f2p2/US4ij4ns++B8/c8j6IONlVJ49IoEkSAXUfBSxoxPrnorMFfMLGMkf7VI4Alc
 hQNMDkPWR6c8Z0ainJGdOX/o43rW/dKT+fUT9vml/EM9/qAnEXqboefIcwIWZj0ltuW5
 7201sXTGW3ZJVGnt1L5OymXV47LNqU7SRTTL1n9AseSYUiC/nKMZAJRcWu1RizCK6XeC
 Q3m/wXcZjkCifnI6CJG3GxdW83gKhAZFvsWA/DTtDlE5Sg35maCOLK3v+GCJMHIaRmfv
 FgS4/ZJ/gRkSa5aPiKBTjN/o1qb++paGISwAbZ13pI/hs3dmMa5N9sB6zP2DQfw6ZQ4y bA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqutb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 15:35:43 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 15:35:41 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 15:35:41 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 4AC3E3F703F;
        Tue, 24 Mar 2020 15:35:41 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02OMZeIA003447;
        Tue, 24 Mar 2020 15:35:41 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 24 Mar 2020 15:35:40 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Remove non functional code
In-Reply-To: <20200206135443.110701-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2003241534400.12727@irv1user01.caveonetworks.com>
References: <20200206135443.110701-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_09:2020-03-23,2020-03-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 6 Feb 2020, 5:54am, Daniel Wagner wrote:

> Remove code which has no functional use anymore since
> 3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate
> port loss").
> 
> While at it remove also the stale function documentation.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 23 -----------------------
>  1 file changed, 23 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 79387ac8936f..27a5d0c7e246 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3909,19 +3909,6 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
>  	set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  }
>  
> -/*
> - * qla2x00_mark_all_devices_lost
> - *	Updates fcport state when device goes offline.
> - *
> - * Input:
> - *	ha = adapter block pointer.
> - *	fcport = port structure pointer.
> - *
> - * Return:
> - *	None.
> - *
> - * Context:
> - */
>  void
>  qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
>  {
> @@ -3933,16 +3920,6 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
>  	list_for_each_entry(fcport, &vha->vp_fcports, list) {
>  		fcport->scan_state = 0;
>  		qlt_schedule_sess_for_deletion(fcport);
> -
> -		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
> -			continue;
> -
> -		/*
> -		 * No point in marking the device as lost, if the device is
> -		 * already DEAD.
> -		 */
> -		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
> -			continue;
>  	}
>  }
>  
> 

Looks good. Thanks Daniel.

Reviewed-by: Arun Easi <aeasi@marvell.com>
