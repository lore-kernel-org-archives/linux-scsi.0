Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DDCC4345C
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD78C20748
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1aM1sq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGJORj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 10:17:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgGJORi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2020 10:17:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AEGfWO169734;
        Fri, 10 Jul 2020 14:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=D0uY635+dAnXCMcGofOGy1zmwg6jXwBEwm7ejm/4Mqc=;
 b=K1aM1sq+0zG0osyyr3Q8jfqyTg/uSOkYS0M+/LscUzufSYRGGqfAqZ1f8odTH3/vNGAz
 VQtDCXrAcbFB8huj4KlzjERz5Ao+nbVeY0av1g/pLnoBuNw6LSqbkzo28i9pPKrTj/lx
 sJ+/nR+6DfroikZh2i7kOzgFe/kRthVYc6ZXq/7Fs79mMNOOVsSfLsn3CAJnr57nfes+
 rAgjqJzGr8dyvaepToie35+FJ3c7npypwN/WBRKG59uXH2mswuJJtG6/kvcFcxXzSJeM
 MW8x+A6+yFlnKplIENGGL0qMbKZ17Hz2yLmryoIOUNQQDY2sFn8kIQZzWKO63Hb+vj/c tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 325y0aqpx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:17:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AE9O6H072266;
        Fri, 10 Jul 2020 14:17:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 325k3kdfha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:17:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06AEHYSW031402;
        Fri, 10 Jul 2020 14:17:35 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:17:34 -0700
Date:   Fri, 10 Jul 2020 17:17:29 +0300
From:   <dan.carpenter@oracle.com>
To:     <varun@chelsio.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation offload
Message-ID: <20200710141729.GA135776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=3
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Varun Prakash,

This is a semi-automatic email about new static checker warnings.

The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI 
segmentation offload" from Jun 29, 2020, leads to the following 
Smatch complaint:

    drivers/scsi/cxgbi/libcxgbi.c:2158 cxgbi_conn_init_pdu()
    warn: variable dereferenced before check 'tdata' (see line 2150)

drivers/scsi/cxgbi/libcxgbi.c
  2149		struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
  2150		struct sk_buff *skb = tdata->skb;
                                      ^^^^^^^^^^
The old code doesn't check for NULL.

  2151		struct scsi_cmnd *sc = task->sc;
  2152		u32 expected_count, expected_offset;
  2153		u32 datalen = count, dlimit = 0;
  2154		u32 i, padlen = iscsi_padding(count);
  2155		struct page *pg;
  2156		int err;
  2157	
  2158		if (!tcp_task || !tdata || tcp_task->dd_data != tdata) {
                                 ^^^^^^
The new check is too late.

  2159			pr_err("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
  2160			       task, task->sc, tcp_task,

regards,
dan carpenter
