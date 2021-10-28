Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C901CC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D9B60C4A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJ1UOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:14:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhJ1UOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 16:14:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SJx2wW001311;
        Thu, 28 Oct 2021 20:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=Z/3hJoKeT+P0qYCR6I9qk6FbOWD/Ypqht9BjPk9dvmA=;
 b=MoxqXp+VSVa4qIVrDOIoAz1i8g6JaTdv2/Zhdt7ppNLyzqg5G16CzHFDrny2DNs5k/SE
 2S3Cv830A0w3H6yxzFQgwNwopeBl1i0O9SRQZIM4g+4zyHafQvjvWpTNq/6SMyubijWj
 qJEEeu7ESpDO5qprjuV0Q4e/X84L1/HKVosmGCneKL0y1m2v1Z2qAbD+UxB6YWO87OH7
 DJxG6MfQy5dlsBXAAdt5jBl8QATAYlWBiXokNDFAYXrD5Twa4K3ar8BU9QT9uZXgB9MP
 pzltWBGhVndrO2+pNu2s968/bKTVZPzE/dzwxYGsnPXe5IwAwKLfjX/JWYoPMHOwy1Ld vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c02d1gdrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 20:12:08 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SK0JGq004689;
        Thu, 28 Oct 2021 20:12:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c02d1gdr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 20:12:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SJrPbi009183;
        Thu, 28 Oct 2021 20:12:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3bx4fnf9e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 20:12:06 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SKC4fx15597920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 20:12:04 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B7DA78064;
        Thu, 28 Oct 2021 20:12:04 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C673C7808C;
        Thu, 28 Oct 2021 20:12:02 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.163.12.226])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 20:12:02 +0000 (GMT)
Message-ID: <ed088511bfe2414a7f84a459b954192f9992af3b.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Thu, 28 Oct 2021 16:12:01 -0400
In-Reply-To: <42ca5f60-4c57-ade1-5fb7-be935ac4ccce@acm.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
         <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
         <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
         <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
         <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
         <42ca5f60-4c57-ade1-5fb7-be935ac4ccce@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zEUnaoyLhw7QU2dZQxD3DI-_4LJm6DV8
X-Proofpoint-ORIG-GUID: Lt_dkF0Q_MoZawqNaZXpDxKY_36e4Seq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 mlxlogscore=999 impostorscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110280105
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-10-28 at 13:04 -0700, Bart Van Assche wrote:
> On 10/28/21 12:12 PM, James Bottomley wrote:
> > I think the deadlock is triggered if the system is down to its last
> > reserved request on the memory clearing device and the next entry
> > in the queue for this device is one which does a fanout so we can't
> > service it with the single reserved request we have left for the
> > purposes of making forward progress.  Sending it back doesn't help,
> > assuming this is the only memory clearing path, because retrying it
> > won't help ... we have to succeed with a request on this path to
> > move forward with clearing memory.
> > 
> > I think this problem could be solved by processing the WRITE BUFFER
> > and the request serially by hijacking the request sent down, but we
> > can't solve it if we try to allocate a new request.
> 
> Hi James,
> 
> How about fixing the abuse of blk_insert_cloned_request() in the UFS
> HPB before the v5.16 SCSI pull request is sent to Linus and
> implementing the proposal from your email at a later time? I'm
> proposing to defer further UFS HPB rework since the issue described
> above only affects UFS HPB users and does not obstruct maintenance or
> refactoring of the block layer core.

Well, yes, I'm already on record as saying we need to do that and add
the functionality back compatibly in a later release.  I think excising
the WRITE BUFFER path, which is simply an optimization and will affect
performance but not function, solves the above issue (and the clone API
problem as well) completely but I haven't heard the patch I proposed
has actually been tested yet.

James


