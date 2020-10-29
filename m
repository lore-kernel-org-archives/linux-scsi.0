Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D9CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 08:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153FD2080C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 08:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mh8HX1KJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgJ2IxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 04:53:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgJ2IxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 04:53:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6iadP037295;
        Thu, 29 Oct 2020 06:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=2udq09tDuPV0uDwPZtaCLxvdvFeYjvWC7AmoJ/LH/kM=;
 b=mh8HX1KJhxVQZKCep7pa9RITtfKYtDBjj9yLI2CQNwV4xA521lo0OzF6wq4a0wm3RG1a
 QH2Zk9OGWxLv8IRqeoH9kvIyNDb6VccP1xIyjRC4pOR6tOpzKuwHNnoIiJQ/SZ7wrfKf
 pQdl+A5ZcujNzHjNzCpXCgeRfLSJVT931eLiYofTZhiBmRHhAlS9ZFWUY3ycVN6S2YAc
 FbwNHDX22nkcpl8FAdsn3uZTQjzeCxinKaQJcQ/P/NhjATl5QbXaj4mM4rPsQe4fmcCQ
 RwedLN1Q8shifISro+Tp8PLRQWlf1SNCI8jedAcpbycwj116R8tLWMRNABt4xQygIhBq Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm48pfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 06:49:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6kMO0178488;
        Thu, 29 Oct 2020 06:49:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1svd44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 06:49:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09T6neKB014497;
        Thu, 29 Oct 2020 06:49:40 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 23:49:40 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 0/8] target: fix up locking in IO paths
Date:   Thu, 29 Oct 2020 01:49:23 -0500
Message-Id: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's staging branch fix some
ref counting issues I hit while testing and improves the locking
in the IO paths. To do the latter, the patches:

1. move the sess_cmd_lock to tcm_qla2xxx since it was the only
driver using the sess_cmd_list.

2. makes the execution lock/list per cpu'ish. I just allocate
nr_cpu_ids's worth of lock/lists then make sure we complete
the cmd on the cpu it was started on.

With the patches I'm seeing a 25% improvement in IOPs for small
IO tests like:

fio  --filename=/dev/sdXYZ  --direct=1 --rw=randrw --bs=4k \
--iodepth=128  --numjobs=16

with drivers like vhost (with those other patches on the list to
fix up multiple virtqueue support) and with the included loop
patch when nr hw queues is increased.

I've dropped the RFC, because Himanshu got my hw working and I've
test the qlogic patches, so please review.


