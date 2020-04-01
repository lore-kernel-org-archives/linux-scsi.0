Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1194C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA1820719
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SO9XJ0cc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbgDARM5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 13:12:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47630 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgDARM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 13:12:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031H9adh030504;
        Wed, 1 Apr 2020 10:12:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=JtyEZ8KPf7pW3KsuhyczQJ2ndYqR/DLwexHAjuvJ8GM=;
 b=SO9XJ0cce92I05An+afR/Dv8EO866EMcHGIvhnge/cnhgkW9cf7a8P6ZIvYgUpohDkjr
 0wx/WcfYJzUOxClqIOX4lrbfFuUWiPUoy2vn4LQPC0QSmpiRwU8lA/C3aREIfa7Dq9KN
 HHVBOPb7IFYTmr/+0qhTmxgqngt84IiMOFoofsckcC98Tt6iFvL8wS1K8Jo2SUpwmNsA
 wopQcugzsy6L2FX3FLptJuyDV+tdyUox6ZnvQtEcc5amerMlnwFpWw3CbSyCJf6DbTCg
 5IlSWWNgYxDGDkrmflll1Zj74bDD/S1VdlM8dLdEFi7LhcRjbwdbBJF3bZoEHM7I3KZa zg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855nyep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 10:12:44 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:12:42 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Apr 2020 10:12:42 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id E13883F703F;
        Wed,  1 Apr 2020 10:12:42 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 031HCgPv014016;
        Wed, 1 Apr 2020 10:12:42 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 1 Apr 2020 10:12:42 -0700
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
Subject: Re: [EXT] [PATCH v3 3/5] Revert "scsi: qla2xxx: Fix unbound sleep
 in fcport delete path."
In-Reply-To: <20200327164711.5358-4-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2004011007350.12727@irv1user01.caveonetworks.com>
References: <20200327164711.5358-1-mwilck@suse.com>
 <20200327164711.5358-4-mwilck@suse.com>
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

> External Email
> 
> ----------------------------------------------------------------------
> From: Martin Wilck <mwilck@suse.com>
> 
> This reverts commit c3b6a1d397420a0fdd97af2f06abfb78adc370df.
> Aborting the sleep was risky, because after return from
> qlt_free_session_done() the driver starts freeing resources,
> which is dangerous while we know that there's pending IO.
> 
> The previous patch "scsi: qla2xxx: check UNLOADING before posting async
> work" avoids sending this IO in the first place, and thus obsoletes
> the dangerous timeout.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 622e733..eec1338 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1019,7 +1019,6 @@ void qlt_free_session_done(struct work_struct *work)
>  
>  	if (logout_started) {
>  		bool traced = false;
> -		u16 cnt = 0;
>  
>  		while (!READ_ONCE(sess->logout_completed)) {
>  			if (!traced) {
> @@ -1029,9 +1028,6 @@ void qlt_free_session_done(struct work_struct *work)
>  				traced = true;
>  			}
>  			msleep(100);
> -			cnt++;
> -			if (cnt > 200)
> -				break;

By taking this code out, it would leave a stuck FC target delete thread 
and thus preventing the module unload itself, in case of a bug in this 
logic (which was seen in some instances).

How about increasing the wait time to say 25 seconds (typical worst case 
is 2 * RA_TOV = 20 seconds) and then alerting user with a "WARN", but 
still break out?

Regards,
-Arun

>  		}
>  
>  		ql_dbg(ql_dbg_disc, vha, 0xf087,
> 
