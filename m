Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED101C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F86207BB
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqcTqw8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGJOPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 10:15:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGJOPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2020 10:15:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AEBqIx003440;
        Fri, 10 Jul 2020 14:15:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=YupB3oPXVFBoVUK1R/GAunaNzVNrpH4fIfABhOLnn+o=;
 b=pqcTqw8LO53gzQSYaaT6TH7oy22QiaYTaGMGPuanrsUDpyWH2Jqg2+wMRY+xrHjTkq0M
 Lve505QyxFSahLofuy85ESpu5Xy18ks3EaOV93f6Vwx5fpN37NhViw/Y/P2wqe/ETSln
 3gMNvl5VCVLNTpcudzJcvihIbmGdA3+SpAdl3GIG92nFFh3FsZXGsM3vtecA2bl6xF1C
 F7Ev/Ps+ASR3Orjw1rYWVWHkD4qCFQT0TqA40aJ5SHvA5I9WZOfpPL/bvKE20JYfw7BI
 8pQaDHHLXZtGC36MAJzFdJN4pGWHzUcrGPKPoBTaqTg+cL40kXpg1SFStFLrV86bywR4 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 325y0aqpth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:15:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AE8Oqs022315;
        Fri, 10 Jul 2020 14:15:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 325k42h112-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:15:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06AEExxv030067;
        Fri, 10 Jul 2020 14:14:59 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:14:59 -0700
Date:   Fri, 10 Jul 2020 17:14:54 +0300
From:   <dan.carpenter@oracle.com>
To:     <varun@chelsio.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation offload
Message-ID: <20200710141454.GA135495@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 mlxlogscore=914 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=3 mlxlogscore=929 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100099
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Varun Prakash,

This is a semi-automatic email about new static checker warnings.

The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI
segmentation offload" from Jun 29, 2020, leads to the following
Smatch complaint:

    drivers/scsi/cxgbi/libcxgbi.c:1892 cxgbi_conn_alloc_pdu()
    warn: variable dereferenced before check 'cconn' (see line 1891)

drivers/scsi/cxgbi/libcxgbi.c
  1890		struct cxgbi_conn *cconn = tcp_conn->dd_data;
  1891		struct cxgbi_device *cdev = cconn->chba->cdev;
                                            ^^^^^^^^^^^
Unchecked dereference in old code.

  1892		struct cxgbi_sock *csk = (cconn && cconn->cep) ? cconn->cep->csk : NULL;
                                          ^^^^^
New code adds a check for NULL but it's too late.

  1893		struct iscsi_tcp_task *tcp_task = task->dd_data;
  1894		struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);

regards,
dan carpenter
