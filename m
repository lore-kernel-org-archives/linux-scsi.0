Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F78CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 10:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD482065C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 10:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zb78n5gd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXKTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 06:19:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgGXKTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 06:19:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OAGbka019953;
        Fri, 24 Jul 2020 10:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=bi7uRtj9UbRbPZIsGZYNbyAvEN8zForiw/cFVhf4GDI=;
 b=zb78n5gdhe+xdpZm6rsYAyaGHYZWZ0MERshQBqZ1xxaUGBhhK3pHcSkvr+H9McAChMuz
 Hk/ICDmpyoJGt1BpYbwhxBhOc+LEUm1ory1Cxw058Am5ftvkK4vyY4g/n+wZyFWdu62h
 396FzWjg46ckBk6zh2RR/ZjqNW5ja1OOfin4tZXEHOLc3Qw5v5cQrarjZv2VTUpntY9K
 4zyRLY+GLnSE6ZMh5VToGwgjR4e1KvXxOX0h36WHbjkwfZP5rJ8m8PNZgq/nqO72AvAN
 0dtj1L1WuxPTBMyktC0EO0ztYjuVDF60IWoyqvU8dGqF29ba8dvLYlKhulpBQF3LxxU/ dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgrxddg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 10:19:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OAIDMn183123;
        Fri, 24 Jul 2020 10:19:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32ft2v2ptr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 10:19:44 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06OAJhVQ023856;
        Fri, 24 Jul 2020 10:19:43 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 10:19:42 +0000
Date:   Fri, 24 Jul 2020 13:19:36 +0300
From:   <dan.carpenter@oracle.com>
To:     kwmad.kim@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [bug report] scsi: ufs: exynos: Implement dbg_register_dump
Message-ID: <20200724101936.GA318943@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=783 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=3 adultscore=0 clxscore=1015 mlxlogscore=799
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240077
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Kiwoong Kim,

The patch 957ee40d413b: "scsi: ufs: exynos: Implement
dbg_register_dump" from Jul 15, 2020, leads to the following static
checker warning:

	drivers/scsi/ufs/ufs-exynos.c:1242 exynos_ufs_dbg_register_dump()
	warn: test_bit() takes a bit number

drivers/scsi/ufs/ufs-exynos.c
  1238  static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
  1239  {
  1240          struct exynos_ufs *ufs = ufshcd_get_variant(hba);
  1241  
  1242          if (!test_and_set_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag)) {
                                      ^^^^^^^^^^^^^^^^^^^^^^^
This is BIT(0) but test_and_set_bit should just take 0, otherwise it's
a double shift.

  1243                  exynos_ufs_dump_info(&ufs->handle, hba->dev);
  1244                  clear_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag);
  1245          }
  1246  }

regards,
dan carpenter
