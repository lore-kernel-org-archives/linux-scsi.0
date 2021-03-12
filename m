Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B72C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA03464F80
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhCLHns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:43:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhCLHn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 02:43:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7dc86071233;
        Fri, 12 Mar 2021 07:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8qXFKuT6IO1m5uaet8RXKHu+iCUWOWC2quXJZUDlw7I=;
 b=B++dp3bCy+i5GbpnQdM45is/1AxuqCQQGBrBqROG37sUTd4WDNInDzO91tCjl/0Vr+sr
 PbNCQ7Xrj2jIHc6n80W5/l6kE4AKj9oSFcoXyKjYluV0/j5/2gIIQf5zz0/TESI7LpmA
 uyeHnb8JlS5bc/GTc43Z2O7nEo0H5TNiaErnkUZRhqIi4yYQKghBThA2V0ST4dfCPg9W
 liM3kWFNmNzCL/H1iYXfU3QVf0mCAaAaOyPZB09qY0vlk0G1XB6IaGUwlONT6W9FamTo
 yvuIue6ZXGNhZZ0i3GZw1kArD1XTmWM8UKLOQo86MRTjOLihjjwxkhAsxJIiQRC5ACHN AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 373y8c18b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:43:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7ddpM075640;
        Fri, 12 Mar 2021 07:43:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 374kn3q6tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:43:22 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12C7hLC9017303;
        Fri, 12 Mar 2021 07:43:21 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Mar 2021 07:43:21 +0000
Date:   Fri, 12 Mar 2021 10:43:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dgilbert@interlog.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: sg: NO_DXFER move to/from kernel buffers
Message-ID: <YEsbkuW/CoaDxl0L@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Douglas Gilbert,

The patch b32ac463cb59: "scsi: sg: NO_DXFER move to/from kernel
buffers" from Feb 19, 2021, leads to the following static checker
warning:

	drivers/scsi/sg.c:2990 sg_rq_map_kern()
	error: uninitialized symbol 'k'.

drivers/scsi/sg.c
  2972  static int
  2973  sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *rqq, int rw_ind)
  2974  {
  2975          struct sg_scatter_hold *schp = &srp->sgat_h;
  2976          struct bio *bio;
  2977          int k, ln;
  2978          int op_flags = 0;
  2979          int num_sgat = schp->num_sgat;
  2980          int dlen = schp->dlen;
  2981          int pg_sz = 1 << (PAGE_SHIFT + schp->page_order);
  2982          int num_segs = (1 << schp->page_order) * num_sgat;
  2983          int res = 0;
  2984  
  2985          SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n", __func__, dlen, pg_sz);
  2986          if (num_sgat <= 0)
  2987                  return 0;
  2988          if (rw_ind == WRITE)
  2989                  op_flags = REQ_SYNC | REQ_IDLE;
  2990          bio = sg_mk_kern_bio(num_sgat - k);
                                                ^
"k" isn't initialized.

  2991          if (!bio)
  2992                  return -ENOMEM;
  2993          bio->bi_opf = req_op(rqq) | op_flags;
  2994  
  2995          for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
  2996                  ln = min_t(int, dlen, pg_sz);
  2997                  if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
  2998                          bio_put(bio);

regards,
dan carpenter
