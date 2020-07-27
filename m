Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A857C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E978A2078A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ADy5gNMg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgG0LTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:19:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgG0LTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 07:19:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RBCjHk079728;
        Mon, 27 Jul 2020 11:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=mUE8Kqn82x7K5jXb1sLaucmtLSAtAtmz1DPQYU4LCE8=;
 b=ADy5gNMg0gJJ/HRQPVnH3PKgK+3LYuimC3y0Q3KUJBxUrEv5esophDz5jvHkSyKMNk0r
 UNXnydHzDmiMlQy01gLDNLIYcUnCXLa41k4rt8NZunoTWvrXTs5NqNq0oe4NQNLBMPLc
 J/aal2o/5n8jx+jLOwzvfN06EmGzJTSLpyxR2hL/Wb7wbC4epcfeSWEb3D/VAXLv2Iba
 ktCjQ9sTigk4wJByI0vXemi9euuy34GGLQ7IGnHf5Rp/D9XPiL0A7mDBA/MJlUbYe59B
 2h3Jl453lpZlbgITn2WeiwTMe3morBsLbyCmljam6HEAkf2Ptfr3Srt2Gq0lShG7iXSO PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32hu1j0xcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 11:19:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RBEI5v045398;
        Mon, 27 Jul 2020 11:19:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5qgqrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 11:19:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RBJO03002530;
        Mon, 27 Jul 2020 11:19:25 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 04:19:23 -0700
Date:   Mon, 27 Jul 2020 14:19:16 +0300
From:   <dan.carpenter@oracle.com>
To:     don.brace@microsemi.com
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: hpsa: Increase controller error handling timeout
Message-ID: <20200727111916.GC389488@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=3 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=3 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270083
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Don Brace,

The patch c73deaf3b001: "scsi: hpsa: Increase controller error
handling timeout" from Jul 20, 2020, leads to the following static
checker warning:

	drivers/scsi/hpsa.c:2163 hpsa_slave_configure()
	error: uninitialized symbol 'queue_depth'.

drivers/scsi/hpsa.c
  2136  /* configure scsi device based on internal per-device structure */
  2137  #define CTLR_TIMEOUT (120 * HZ)
  2138  static int hpsa_slave_configure(struct scsi_device *sdev)
  2139  {
  2140          struct hpsa_scsi_dev_t *sd;
  2141          int queue_depth;
                ^^^^^^^^^^^^^^^

  2142  
  2143          sd = sdev->hostdata;
  2144          sdev->no_uld_attach = !sd || !sd->expose_device;
  2145  
  2146          if (sd) {
  2147                  sd->was_removed = 0;
  2148                  if (sd->external) {
  2149                          queue_depth = EXTERNAL_QD;
  2150                          sdev->eh_timeout = HPSA_EH_PTRAID_TIMEOUT;
  2151                          blk_queue_rq_timeout(sdev->request_queue,
  2152                                                  HPSA_EH_PTRAID_TIMEOUT);
  2153                  } else if (is_hba_lunid(sd->scsi3addr)) {
  2154                          sdev->eh_timeout = CTLR_TIMEOUT;
  2155                          blk_queue_rq_timeout(sdev->request_queue, CTLR_TIMEOUT);

Not set on this path.

  2156                  } else {
  2157                          queue_depth = sd->queue_depth != 0 ?
  2158                                          sd->queue_depth : sdev->host->can_queue;
  2159                  }
  2160          } else
  2161                  queue_depth = sdev->host->can_queue;
  2162  
  2163          scsi_change_queue_depth(sdev, queue_depth);
                                              ^^^^^^^^^^^
  2164  
  2165          return 0;
  2166  }

regards,
dan carpenter
