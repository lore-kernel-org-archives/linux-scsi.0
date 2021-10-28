Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957CAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A68660724
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhJ1PYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 11:24:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhJ1PYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 11:24:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SErSKo011359;
        Thu, 28 Oct 2021 15:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=/hJ3Lm1qbGC4/iVNVxS0v9M4R8V2I6sBbwkXzOuCkVk=;
 b=XJ2jZqHb+vPPsH3SJvRJCja7DGrgu5m9ENvISF0mNVeGbFSc/jyIfe3GikpAglOX4hUA
 srHkdmOXjJWI22e54226DqK/9hF3elNaH+Q0l9N4PwBG3LK07elPC7CwExS0WLF31Apv
 PcKXE38jFnxmHcaRLkMtUCe/plP7e6kyWyBd6ZwyxtKG4aQdajQ+6RCi8col8BQaasi9
 +SmACDoeftAngbW9MmGeQwko+3yD+LsLLgGfhEOrJ+eyTDv564OHSh4p+oFHrNUqPHz/
 6BVDrwWde0g1muXaz8EYuIRiAhIsG1GTi1ls5/ORsPZ6gzEFL9p/fLRnkNY8ib+E8bKs OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byx18rn9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 15:22:11 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SEwZ47024174;
        Thu, 28 Oct 2021 15:22:11 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byx18rn97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 15:22:10 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SFDYJ2002801;
        Thu, 28 Oct 2021 15:22:10 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3bx4f8gueq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 15:22:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SFM8Rq46006544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 15:22:08 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585F878066;
        Thu, 28 Oct 2021 15:22:08 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB8787805F;
        Thu, 28 Oct 2021 15:22:06 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.163.12.226])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 15:22:06 +0000 (GMT)
Message-ID: <431d809cc8c26a9b8dfbf1c209c713e7656a94e4.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Date:   Thu, 28 Oct 2021 11:22:05 -0400
In-Reply-To: <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
         <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iZS2Ahrfr_UutVI-lZKeSJ4HQKOX7Wn-
X-Proofpoint-ORIG-GUID: fg_tG7gemUTsxeV_AR5CKMyLIMfvRIer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+Jens, Christoph and linux-block

On Thu, 2021-10-28 at 07:36 +0900, Daejun Park wrote:
> This patch addresses the issue of using the wrong API to create a
> pre_request for HPB READ.
> HPB READ candidate that require a pre-request will try to allocate a
> pre-request only during request_timeout_ms (default: 0). Otherwise,
> it is
> passed as normal READ, so deadlock problem can be resolved.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 11 +++++------
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 02fb51ae8b25..3117bd47d762 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct
> ufshpb_lu *hpb, struct scsi_cmnd *cmd,
>  				 read_id);
>  	rq->cmd_len = scsi_command_size(rq->cmd);
>  
> -	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> -		return -EAGAIN;
> +	blk_execute_rq_nowait(NULL, req, true,
> ufshpb_pre_req_compl_fn);
>  
>  	hpb->stats.pre_req_cnt++;
>  
> @@ -2315,19 +2314,19 @@ struct attribute_group
> ufs_sysfs_hpb_param_group = {
>  static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>  {
>  	struct ufshpb_req *pre_req = NULL, *t;
> -	int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>  	int i;
>  
>  	INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>  
> -	hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req),
> GFP_KERNEL);
> -	hpb->throttle_pre_req = qd;
> +	hpb->pre_req = kcalloc(HPB_INFLIGHT_PRE_REQ, sizeof(struct
> ufshpb_req),
> +			       GFP_KERNEL);
> +	hpb->throttle_pre_req = HPB_INFLIGHT_PRE_REQ;
>  	hpb->num_inflight_pre_req = 0;
>  
>  	if (!hpb->pre_req)
>  		goto release_mem;
>  
> -	for (i = 0; i < qd; i++) {
> +	for (i = 0; i < HPB_INFLIGHT_PRE_REQ; i++) {
>  		pre_req = hpb->pre_req + i;
>  		INIT_LIST_HEAD(&pre_req->list_req);
>  		pre_req->req = NULL;
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index a79e07398970..411a6d625f53 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -50,6 +50,7 @@
>  #define HPB_RESET_REQ_RETRIES			10
>  #define HPB_MAP_REQ_RETRIES			5
>  #define HPB_REQUEUE_TIME_MS			0
> +#define HPB_INFLIGHT_PRE_REQ			4
>  
>  #define HPB_SUPPORT_VERSION			0x200
>  #define HPB_SUPPORT_LEGACY_VERSION		0x100


