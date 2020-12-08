Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED6AC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A97238EE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgLHB54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:57:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45180 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgLHB5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 20:57:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81tGIU156971;
        Tue, 8 Dec 2020 01:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=qHFBxoQXJ1tZdGK8G/rJNLMRM0SUkHEwhvJJiJqqFFI=;
 b=cC01m9XXeLOTD9YNLfOwrpMXFy6POwo6oTxPQTE/K53/NF2JKgh/HgkERJwPArEpLkTs
 vz7axsq+u0S+XUdI2vQK/idU57uMkC7YqFEXS3vYWWl5utbIF1LHCdsl+kNiAU2+Kc70
 7wNJRwPFsQ9d06QSwjkMtrSLe7QeL4CNIBg+3GmgVyNq7+OxJakfBccZrbU44wuWAtYd
 uGL+sMzPsqVDvrOoXK7RvSzAwV/ZsWtatfOVtxabEBAPyhuyfWTmiWhbDnMBZQPvA+E4
 cM36nQ/Cq/UUd65ozIKUZyrzw+oibXtmJ973AJ0OZw1T/0sFo3/XfPs0+4V99G0MDCWe 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbrjwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 01:57:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81sjnG016490;
        Tue, 8 Dec 2020 01:57:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksmxd0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 01:57:04 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B81uvdF014130;
        Tue, 8 Dec 2020 01:56:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 17:56:57 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/9] Rework runtime suspend and SPI domain validation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8j5ysd6.fsf@ca-mkp.ca.oracle.com>
References: <20201130024615.29171-1-bvanassche@acm.org>
Date:   Mon, 07 Dec 2020 20:56:55 -0500
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 29 Nov 2020 18:46:06 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=806 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=818
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The SCSI runtime suspend and SPI domain validation mechanisms both use
> scsi_device_quiesce(). scsi_device_quiesce() restricts
> blk_queue_enter() to BLK_MQ_REQ_PREEMPT requests. There is a conflict
> between the requirements of runtime suspend and SCSI domain
> validation: no requests must be sent to runtime suspended devices that
> are in the state RPM_SUSPENDED while BLK_MQ_REQ_PREEMPT requests must
> be processed during SCSI domain validation. This conflict is resolved
> by reworking the SCSI domain validation implementation.

Applied to 5.11/scsi-staging except for patch #5. Appreciate all that
work that went into this series!

-- 
Martin K. Petersen	Oracle Linux Engineering
