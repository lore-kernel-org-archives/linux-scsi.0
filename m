Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8370ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577C021897
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VDIFG3rR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfJRIyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:54:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731444AbfJRIyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 04:54:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2dIMw132639;
        Fri, 18 Oct 2019 02:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6pqyrIv3f9cOfHiZ/l0SMfNyGHEl0Rc+AgdlmuG5jvQ=;
 b=VDIFG3rRA0YXxuEmOm1gHGR5qKWdp/DU2IsCXmccDRgGlzKFSGOO2PLeo3q/G3LimlsX
 n/Fk/lKnHRdwYRSRPdiX1B9Z3i+sRwU4OKFdAZPRF1nez5iO4fWptKxl2CSqKxcSNZUa
 jdqIIFF1dDhFFYFtHui3E7P2FZmdyDZ2/ZNN2n+3OAMuEkdTtNSHtOtpILrOP0dFNaZ5
 X/FjEl5zItp3007waj/K0f5AZtmFBewV1Jdn+CpQKDCy6TdI3E9utZ0xK9Kk0GQs3M7/
 nwdyyCWPJAvLPXHqCEcxWTox63liO8Zr9acKYsf3zrAtWtxRpKtB1iXCijs2XK+bxcEl jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vq0q40ux2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:41:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2cMs1065697;
        Fri, 18 Oct 2019 02:41:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vq0ed4eqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:41:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9I2f4um030984;
        Fri, 18 Oct 2019 02:41:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 02:41:04 +0000
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v4 2/2] scsi: core: fix uninit-value access of variable sshdr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571293177-117087-1-git-send-email-zhengbin13@huawei.com>
        <1571293177-117087-3-git-send-email-zhengbin13@huawei.com>
Date:   Thu, 17 Oct 2019 22:40:59 -0400
In-Reply-To: <1571293177-117087-3-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Thu, 17 Oct 2019 14:19:37 +0800")
Message-ID: <yq1y2xiixms.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=867
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=954 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> We can init sshdr in sr_get_events, but there have many callers of
> scsi_execute, scsi_execute_req, we have to troubleshoot all callers,
> the simpler way is init sshdr in __scsi_execute.

There aren't that many callers. I'd prefer to make sure that everybody
is handling DRIVER_SENSE and scsi_sense_valid() correctly. Looks like
we're generally OK, but please verify.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
