Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD14C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C437B6124C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhFRNiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:38:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42988 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232427AbhFRNiq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 09:38:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IDW5kW024749;
        Fri, 18 Jun 2021 13:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=4wGTS9vcm0ALr/iymzUJeDHZBOYGIbdH5sgcwSIF+f0=;
 b=m+c3EGAFSq/bs4aWJ4nLpR/ohcNWUYeS2MSlsjscWk2EMLArRyRPIJcvZuiffJ9lbrU0
 eEE5fV/TNmGtLdvUlwpNQaWnOjDm5Simjo/+BQ/+dv1JtOsjgnPlEfVY0SceTjPbdKZt
 4VWMAs9msvPslqAN/utZmwVfJ0gcvhMgPSfO/kxbpU6EXWLZU6bOwL9IoR+AIsZl9m13
 t+gJqOUl0j2aHZUI9wbfenga35flpGr9BnK020/vPIjQpHfx8/+XI1m2Kj8OX4YIpGWU
 gk7C6j0l3KZCpF+XqozJMUDZ1lnpsew0FQ6JM18tJiLO4yCCpGJ1lwEqQfCTdoDDnlfq aA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 397jnqv9ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:36:36 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15IDYfuF142411;
        Fri, 18 Jun 2021 13:36:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 396ware3kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:36:35 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15IDaZvf146670;
        Fri, 18 Jun 2021 13:36:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 396ware3k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:36:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15IDaYYp007699;
        Fri, 18 Jun 2021 13:36:34 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 06:36:33 -0700
Date:   Fri, 18 Jun 2021 16:36:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: elx: efct: Driver initialization routines
Message-ID: <YMyhWpF5q0RVgfJU@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: nT0NE3p5qKprcqM9ybHwnAp3THvzHGQz
X-Proofpoint-ORIG-GUID: nT0NE3p5qKprcqM9ybHwnAp3THvzHGQz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 4df84e846624: "scsi: elx: efct: Driver initialization
routines" from Jun 1, 2021, leads to the following static checker
warning:

	drivers/scsi/elx/efct/efct_xport.c:46 efct_xport_init_debugfs()
	warn: 'efct_debugfs_root' is an error pointer or valid

drivers/scsi/elx/efct/efct_xport.c
    39  static int
    40  efct_xport_init_debugfs(struct efct *efct)
    41  {
    42          /* Setup efct debugfs root directory */
    43          if (!efct_debugfs_root) {
    44                  efct_debugfs_root = debugfs_create_dir("efct", NULL);
    45                  atomic_set(&efct_debugfs_count, 0);
    46                  if (!efct_debugfs_root) {
    47                          efc_log_err(efct, "failed to create debugfs entry\n");
    48                          goto debugfs_fail;
    49                  }

This test can just be deleted.  We don't need to check for IS_ERR()
because it's okay if it fails.  Normally, drivers are not supposed to
check the return from debugfs_create_dir().

    50          }
    51  
    52          /* Create a directory for sessions in root */
    53          if (!efct->sess_debugfs_dir) {
    54                  efct->sess_debugfs_dir = debugfs_create_dir("sessions", NULL);
                                                                                ^^^^
This should be "efct_debugfs_root"


    55                  if (!efct->sess_debugfs_dir) {

Here, we do care so it should be updated to if (IS_ERR(efct->sess_debugfs_dir)) {

    56                          efc_log_err(efct,
    57                                      "failed to create debugfs entry for sessions\n");
    58                          goto debugfs_fail;
    59                  }
    60                  atomic_inc(&efct_debugfs_count);
    61          }
    62  
    63          return 0;
    64  
    65  debugfs_fail:
    66          return -EIO;
    67  }

regards,
dan carpenter
