Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473B0C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C83123C41
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgLIQrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 11:47:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgLIQrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 11:47:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9GdMd7154126;
        Wed, 9 Dec 2020 16:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Jn85YTus4rlmzXRn6jalP/oZELEf3DpzvOLjDSF/rI0=;
 b=wtzzo5YG1bXLAmxMgJUGDCVQxGWU+Rq2ad4b/Pmq4HMhZumc8E9uiq30v83s10TRvf2y
 ZiU0k2fs9WFCMgSDDAPVQ8q06rbm/xAOEUkvqt46FJPxwqmzaLN1iTb5NRARpxiDn9wg
 0pYe3EGX2IPc/OniWJscmi197MHG9sx0/bxYwtQPgXt5mCby9k80X+bSeNPTD7bTCFRu
 iRq104DGFekjZmkpy09cp27uND10XM1j7dizTLSDONtNp3g72XYJEBAvKT1YB2HYF1Fe
 Iy6oN6dqujR3DNHGnVeamrIFfBANe2lDGsxlzFUQnyn2pGKH1CQ+FbpoRffDy1U0VjNM Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc1932-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 16:46:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9GewHR162343;
        Wed, 9 Dec 2020 16:44:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358ksqbw5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 16:44:22 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9GiIqM032606;
        Wed, 9 Dec 2020 16:44:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 08:44:18 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v5 0/8] Rework runtime suspend and SPI domain validation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2i7q6ay.fsf@ca-mkp.ca.oracle.com>
References: <20201209052951.16136-1-bvanassche@acm.org>
Date:   Wed, 09 Dec 2020 11:44:13 -0500
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 8 Dec 2020 21:29:43 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=992 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090117
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

Applied to 5.11/scsi-staging. Thanks for fixing up the -next issue!

-- 
Martin K. Petersen	Oracle Linux Engineering
