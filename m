Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B5EC43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C06206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="m6eZD4lA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbgDARE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 13:04:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24698 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727541AbgDARE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 13:04:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031Goc79029912;
        Wed, 1 Apr 2020 10:04:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=DDmB4BlH7i+xRFcs6qsmghF9VoYni7F3NM6DuiHZdd4=;
 b=m6eZD4lAKCFmph5GS9Ur/VBRhouEFgElToRtMU8J46G2ofUhJVSK64+Xx2LkoCVzFKiQ
 N4MOueTMQMc1NQiMBLoSNCTyqD3M/aYHPoUTm7633cZ7jEYPd4PresSxe49OwaEuTdkk
 ejAkEphp9DTgf5DrEmnM4pQyGUoB+9cDDTU87NnRLCsr2mVj4e1XuMfM1LGzyqv+wzvy
 eVdNS3p4qD/ddLUwHwMWRR9JCxZ/JbFgJ2KoCu6tj8s/uCxyYHJ+PKuecCWukWo497bM
 0oz9JQDrB18jcix1GCg1CLQwh9dtaCG+IEGfS1PeV4QwO046BTd1SJWAVK+02g4fxYEI QA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h5xd0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 10:04:03 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:04:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Apr 2020 10:04:00 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 1D82E3F703F;
        Wed,  1 Apr 2020 10:04:01 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 031H40J8011398;
        Wed, 1 Apr 2020 10:04:00 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 1 Apr 2020 10:04:00 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] scsi: qla2xxx: check UNLOADING before posting
 async work
In-Reply-To: <20200327164711.5358-3-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2004011002190.12727@irv1user01.caveonetworks.com>
References: <20200327164711.5358-1-mwilck@suse.com>
 <20200327164711.5358-3-mwilck@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_03:2020-03-31,2020-04-01 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 27 Mar 2020, 9:47am, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> qlt_free_session_done() tries to post async PRLO / LOGO, and
> waits for the completion of these async commands. If UNLOADING
> is set, this is doomed to timeout, because the async logout
> command will never complete.
> 
> The only way to avoid waiting pointlessly is to fail posting
> these commands in the first place if the driver is in UNLOADING state.
> In general, posting any command should be avoided when the driver
> is UNLOADING.
> 
> With this patch, "rmmod qla2xxx" completes without noticeable delay.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index ce0dabb..eb25cf5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4933,6 +4933,9 @@ int qla2x00_post_async_##name##_work(		\
>  {						\
>  	struct qla_work_evt *e;			\
>  						\
> +	if (test_bit(UNLOADING, &vha->dpc_flags)) \
> +		return QLA_FUNCTION_FAILED;	\
> +						\

Martin,

Could you move this check to qla2x00_alloc_work() so that other callers of 
qla2x00_alloc_work() can also benefit.

Regards,
-Arun

>  	e = qla2x00_alloc_work(vha, type);	\
>  	if (!e)					\
>  		return QLA_FUNCTION_FAILED;	\
> 
