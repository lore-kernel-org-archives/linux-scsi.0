Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C94C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 11:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B799A613B1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 11:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhFILDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 07:03:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbhFILDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 07:03:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159AxrRw096653;
        Wed, 9 Jun 2021 11:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=uju7O+5XraNZQjssqJeHqm4DA5OyOACA7tF1aMmj5RA=;
 b=G2ZYjrrV1Pp+Co+Z8IJDnRnfm/j/xuoD/upEInAkA/wi2g6v/o+56paRkh+8k4Sv3gMV
 RiZZVyDOHgu9J9Xh197rrlQZ+hbaVIVbS3sNz712tnbDYCNZ9V39E0btUdWg68f4rh3K
 r9Rv/MBUnTo8v4R/rijbD53G7+yS3/hvpFXi5FC7Q3iWu2qjYyh12DrgRCH8g6GKcNMw
 810u9ZziAgBRKj+Hht48aSDvXYYGfFHUW0L4QoykfgqWdAzQfwk3mcaj2F3bS5dRLrlE
 8udDLzpE7ZFM5XgLnBAzIMT9YkAof6cTiGcZeQCu2xkNjWjMDc3/AFP5J5dw2Sy8am1o /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 39017ngry8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 11:01:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159B0c7O024080;
        Wed, 9 Jun 2021 11:01:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3922wumx3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 11:01:08 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 159B17GG029310;
        Wed, 9 Jun 2021 11:01:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3922wumx2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 11:01:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 159B171e027631;
        Wed, 9 Jun 2021 11:01:07 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 11:01:06 +0000
Date:   Wed, 9 Jun 2021 14:01:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
Message-ID: <YMCfbSj7Ui+fzi2N@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: JTwfFMV4zB22lpxk6qx7rj02j8PgoRsG
X-Proofpoint-ORIG-GUID: JTwfFMV4zB22lpxk6qx7rj02j8PgoRsG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090054
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Can Guo,

The patch a45f937110fa: "scsi: ufs: Optimize host lock on transfer
requests send/compl paths" from May 24, 2021, leads to the following
static checker warning:

	drivers/scsi/ufs/ufshcd.c:2998 ufshcd_exec_dev_cmd()
	error: potentially dereferencing uninitialized 'lrbp'.

drivers/scsi/ufs/ufshcd.c
  2948  static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
  2949                  enum dev_cmd_type cmd_type, int timeout)
  2950  {
  2951          struct request_queue *q = hba->cmd_queue;
  2952          struct request *req;
  2953          struct ufshcd_lrb *lrbp;
                                   ^^^^

  2954          int err;
  2955          int tag;
  2956          struct completion wait;
  2957  
  2958          down_read(&hba->clk_scaling_lock);
  2959  
  2960          /*
  2961           * Get free slot, sleep if slots are unavailable.
  2962           * Even though we use wait_event() which sleeps indefinitely,
  2963           * the maximum wait time is bounded by SCSI request timeout.
  2964           */
  2965          req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
  2966          if (IS_ERR(req)) {
  2967                  err = PTR_ERR(req);
  2968                  goto out_unlock;
  2969          }
  2970          tag = req->tag;
  2971          WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
  2972          /* Set the timeout such that the SCSI error handler is not activated. */
  2973          req->timeout = msecs_to_jiffies(2 * timeout);
  2974          blk_mq_start_request(req);
  2975  
  2976          if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
  2977                  err = -EBUSY;
  2978                  goto out;
                        ^^^^^^^^

  2979          }
  2980  
  2981          init_completion(&wait);
  2982          lrbp = &hba->lrb[tag];

This used to be initialized before the goto

  2983          WARN_ON(lrbp->cmd);
  2984          err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
  2985          if (unlikely(err))
  2986                  goto out_put_tag;
  2987  
  2988          hba->dev_cmd.complete = &wait;
  2989  
  2990          ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
  2991          /* Make sure descriptors are ready before ringing the doorbell */
  2992          wmb();
  2993  
  2994          ufshcd_send_command(hba, tag);
  2995          err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
  2996  out:
  2997          ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
  2998                                      (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
                                                                   ^^^^^^^^^^^^^^^^^

  2999  
  3000  out_put_tag:
  3001          blk_put_request(req);
  3002  out_unlock:
  3003          up_read(&hba->clk_scaling_lock);
  3004          return err;
  3005  }

regards,
dan carpenter
