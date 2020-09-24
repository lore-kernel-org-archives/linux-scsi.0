Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8292C4346E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 08:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D76C23772
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 08:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ebm/7LL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgIXI74 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 04:59:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42664 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIXI7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 04:59:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O8x8r5195318;
        Thu, 24 Sep 2020 08:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=dE2Lou7hZbnLtRutIaHG2ToxInouGVpJfq9Vzf5Lv1g=;
 b=Ebm/7LL7I9IjIYfhxiSrhlxooWKIXQMmCS9YXhUNNbuykf0/fjbvgc8pLPZ0rGXZGdbL
 dPUj9f98JxS2fF9YqBla3QYXWdRoc6W2kkfMnLI7LiUjewBp8D2bqsW/Aqs+7BlI9f2d
 /+Ho2tJb1dG1oFgUIs+a0e+y1mfZsEsqP/YgRByCToyKpZyuBsVCSTcX320Qr5GLyjha
 DxEXQjkc17rsO0Ub97W19tw1GLkLSQmuXlkXXGxhMs/0/dzzklMT8gHfv6IwFk/TqOOy
 FuoFXwX4dqbOQflbzM1+CMX0bwYPWW5SNtVlqWJeMKGx74oSHGMlF6tfe7GX1jnNLsic 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnuq2a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 08:59:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O8sQH6162135;
        Thu, 24 Sep 2020 08:59:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujqn6vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 08:59:52 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08O8xoKV010346;
        Thu, 24 Sep 2020 08:59:51 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 01:59:50 -0700
Date:   Thu, 24 Sep 2020 11:59:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     aeasi@marvell.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: qla2xxx: Setup debugfs entries for remote ports
Message-ID: <20200924085945.GA1569340@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=3 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Arun Easi,

The patch 1e98fb0f9208: "scsi: qla2xxx: Setup debugfs entries for
remote ports" from Sep 3, 2020, leads to the following static checker
warning:

	drivers/scsi/qla2xxx/qla_dfs.c:119 qla2x00_dfs_create_rport()
	warn: 'fp->dfs_rport_dir' is an error pointer or valid

drivers/scsi/qla2xxx/qla_dfs.c
   106  qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
   107  {
   108          char wwn[32];
   109  
   110  #define QLA_CREATE_RPORT_FIELD_ATTR(_attr)                      \
   111          debugfs_create_file(#_attr, 0400, fp->dfs_rport_dir,    \
   112                  fp, &qla_dfs_rport_field_##_attr##_fops)
   113  
   114          if (!vha->dfs_rport_root || fp->dfs_rport_dir)
   115                  return;
   116  
   117          sprintf(wwn, "pn-%016llx", wwn_to_u64(fp->port_name));
   118          fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
   119          if (!fp->dfs_rport_dir)

Just delete this test.  Debugfs functions are not supposed to be checked
in the normal case.

   120                  return;
   121          if (NVME_TARGET(vha->hw, fp))
   122                  debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,

The debugfs_create_file() function has it's own checks built in so no
need to check.

   123                                      fp, &qla_dfs_rport_dev_loss_tmo_fops);
   124  
   125          QLA_CREATE_RPORT_FIELD_ATTR(disc_state);
   126          QLA_CREATE_RPORT_FIELD_ATTR(scan_state);
   127          QLA_CREATE_RPORT_FIELD_ATTR(fw_login_state);

regards,
dan carpenter
