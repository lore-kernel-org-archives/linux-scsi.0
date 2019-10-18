Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594E5CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FF920700
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:46:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bkuzr4nW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbfJRVqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:46:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34462 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394511AbfJRVqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:46:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILhumN080377;
        Fri, 18 Oct 2019 21:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=2F0XOCRHLUkak6GPRfTWsz3EwXt23ecGMafjjNpfWYY=;
 b=Bkuzr4nW/kSxEKqbOyYc4twMeEEHIV97OiiQE1jCMyYnZLuundyJTBEcaTAs1oKF0xtc
 buQ+3GM5YgMa5Z6PVV8IK/X1CxKaGOgos/ZjltgjjG7FjxGmp6sG9QP5aumZLIaCDBCu
 ukQSfuY44MNgZy0bNo/ndLvfVfDxe5iK+LutSfgr+g61jL1PS09lpiHBedqs3l+b5C7u
 D1mk+nAIcToi7HtaxVWN70Qy/7TZSKuUz4vzs+5BCg/nOtUbdncTSKEGkLXIBHhHmD19
 IQgOmCjG74RZnJdf2nA3FkwuMU3y1PMIDUmTbPLE00P1KoZISxLxa1NuORNtsxVaqypU Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vq0q468pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 21:44:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILhBvi070410;
        Fri, 18 Oct 2019 21:44:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vq0eewhur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 21:44:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9ILilhD006030;
        Fri, 18 Oct 2019 21:44:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 21:44:47 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi_dh_alua: Do not run STPG for implicit ALUA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191018135537.69462-1-hare@suse.de>
Date:   Fri, 18 Oct 2019 17:44:44 -0400
In-Reply-To: <20191018135537.69462-1-hare@suse.de> (Hannes Reinecke's message
        of "Fri, 18 Oct 2019 15:55:37 +0200")
Message-ID: <yq1mudxhgoj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=947
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180191
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> If a target only supports implicit ALUA sending a SET TARGET PORT
> GROUPS command is not only pointless, but might actually cause issues.

We already have a conditional in alua_stpg():

        if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
                /* Only implicit ALUA supported, retry */
                return SCSI_DH_RETRY;
        }

> @@ -832,6 +832,10 @@ static void alua_rtpg_work(struct work_struct *work)
>  		if (err != SCSI_DH_OK)
>  			pg->flags &= ~ALUA_PG_RUN_STPG;
>  	}
> +	/* Do not run STPG if only implicit ALUA is supported */
> +	if (scsi_device_tpgs(sdev) == TPGS_MODE_IMPLICIT)
> +		pg->flags &= ~ALUA_PG_RUN_STPG;
> +
>  	if (pg->flags & ALUA_PG_RUN_STPG) {
>  		pg->flags &= ~ALUA_PG_RUN_STPG;
>  		spin_unlock_irqrestore(&pg->lock, flags);

Instead of checking for EXPLICIT one place and checking for !IMPLICIT
another, can we consolidate the two and maybe do:

  	if (pg->flags & ALUA_PG_RUN_STPG &&
            scsi_device_tpgs(sdev) == TPGS_MODE_EXPLICIT) {
        	[...]

and then remove the redundant check in alua_stpg()?

-- 
Martin K. Petersen	Oracle Linux Engineering
