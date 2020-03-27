Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56C8C2D0EC
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDCF22082D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cpr41H4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgC0Cf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:35:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgC0Cf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 22:35:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2YLWN196219;
        Fri, 27 Mar 2020 02:35:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=O5oH+1g/wW/zCAcvpnmv8tlMXqEAtaY6BUDS4t74tSo=;
 b=Cpr41H4jckmm7xekGmZ4YnFkR4v4FIjQZFHyXSFfVIOcK+oXCU9XnLiXszPynv2bB7kU
 PxOYtVBrrVOWxx2l0YTpo3NTm50cuhUXa9SQmIvbczAJ/H/LRzotvSs/ESWCYBRY49jl
 e4tGAkgzjkF8n5mbeVnPVwUNcOizF9BIPBuh1JKbjFRukLX7lnTlUWEFCh4YBJUdJGwi
 a1taLpwp0GSGJyT/MXsmbfew/VEJ8oo6Vx90XhRDwfKLl6Vc8jhm2OL+na7LYmhcbrgH
 UXyUIKRX5RLsINlEbIaMFu4JR76VN4sIsfBTmws9FLYWBmi9XpG9/jPCk7wAn7gvJOcH jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3pyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:35:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2ZOY0190871;
        Fri, 27 Mar 2020 02:35:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3006r9h912-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:35:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02R2ZLKb031985;
        Fri, 27 Mar 2020 02:35:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:35:21 -0700
To:     Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/6] Fix qla2xxx endianness annotations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200305045431.30061-1-bvanassche@acm.org>
Date:   Thu, 26 Mar 2020 22:35:19 -0400
In-Reply-To: <20200305045431.30061-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 4 Mar 2020 20:54:25 -0800")
Message-ID: <yq17dz6ed94.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arun, Quinn: This series still needs review.

Thanks!

> This patch series fixes the endianness annotations in the qla2xxx
> driver.  Please consider this patch series for the v5.7 kernel.
>
> Thanks,
>
> Bart.
>
> Changes compared to v2:
> - Removed one BUILD_BUG_ON() statement.
>
> Changes compared to v1:
> - Left out the raw_smp_processor_id() patch because it may take time to achieve
>   agreement about this patch.
> - Added three patches to this series: two patches for verifying structure size
>   at compile time and one patch for changing function names from upper case to
>   lower case.
>
> Bart Van Assche (6):
>   qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
>   qla2xxx: Add more BUILD_BUG_ON() statements
>   qla2xxx: Fix endianness annotations in header files
>   qla2xxx: Fix endianness annotations in source files
>   qla2xxx: Fix the code that reads from mailbox registers
>   qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
>     lower case
>
>  drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
>  drivers/scsi/qla2xxx/qla_bsg.c     |   4 +-
>  drivers/scsi/qla2xxx/qla_dbg.c     | 672 +++++++++++++-------------
>  drivers/scsi/qla2xxx/qla_dbg.h     | 442 ++++++++---------
>  drivers/scsi/qla2xxx/qla_def.h     | 711 ++++++++++++++-------------
>  drivers/scsi/qla2xxx/qla_fw.h      | 738 ++++++++++++++---------------
>  drivers/scsi/qla2xxx/qla_init.c    | 279 +++++------
>  drivers/scsi/qla2xxx/qla_inline.h  |   8 +-
>  drivers/scsi/qla2xxx/qla_iocb.c    | 121 ++---
>  drivers/scsi/qla2xxx/qla_isr.c     | 217 +++++----
>  drivers/scsi/qla2xxx/qla_mbx.c     | 111 +++--
>  drivers/scsi/qla2xxx/qla_mr.c      | 111 +++--
>  drivers/scsi/qla2xxx/qla_mr.h      |  32 +-
>  drivers/scsi/qla2xxx/qla_nvme.c    |  12 +-
>  drivers/scsi/qla2xxx/qla_nvme.h    |  46 +-
>  drivers/scsi/qla2xxx/qla_nx.c      | 161 +++----
>  drivers/scsi/qla2xxx/qla_nx.h      |  36 +-
>  drivers/scsi/qla2xxx/qla_nx2.c     |  12 +-
>  drivers/scsi/qla2xxx/qla_os.c      | 128 +++--
>  drivers/scsi/qla2xxx/qla_sup.c     | 345 +++++++-------
>  drivers/scsi/qla2xxx/qla_target.c  |  84 ++--
>  drivers/scsi/qla2xxx/qla_target.h  | 208 ++++----
>  drivers/scsi/qla2xxx/qla_tmpl.c    |  12 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
>  24 files changed, 2317 insertions(+), 2190 deletions(-)

-- 
Martin K. Petersen	Oracle Linux Engineering
