Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BE6C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36A820872
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i7HePejj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504327AbgJ0CDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 22:03:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47528 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgJ0CDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 22:03:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1xKSv028785;
        Tue, 27 Oct 2020 02:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=35Sxldvow+z8Xed162Rpv8J/WbDCcWLZgAUe3vtL2MU=;
 b=i7HePejjdPc3R6whgHxgyMStk73U10WGGHk6V8ujh239SHbET+Za826Tj/aa4cwo0EgV
 9LH7PgwgxVtg1IrhbW1iFTKi8eKPyVaEI2OHvWV687ICYvNA+b0sACx5I3cqZ5RTj2QO
 1r+ndYZJ6l58ZU0v5Mtq0d4xa64zPtBVhezYmdo5i0+FL7eOPYvWPdNGA0BWsW+rN/xm
 hwv4B7e43rTHhwLsI4J6XNslSvnZTMCbWHz6A4iuGDee/KXDhry4pFeqn55YLKhk3+cP
 ePqlQF07z47r8IYvhvKNEVwWd6FKpSrpv5ReEcZpH/BFoaWvzTavfRAWaGhnWECbC1ON Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kqgcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 02:03:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1uOYn018813;
        Tue, 27 Oct 2020 02:03:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwuku4cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 02:03:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R23b56026695;
        Tue, 27 Oct 2020 02:03:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 19:03:36 -0700
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] [SCSI] aic7xxx: change the error value of
 ahx_pci_test_register_access from postive to negative
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn544e8g.fsf@ca-mkp.ca.oracle.com>
References: <20201026091236.68561-1-zhangqilong3@huawei.com>
Date:   Mon, 26 Oct 2020 22:03:34 -0400
In-Reply-To: <20201026091236.68561-1-zhangqilong3@huawei.com> (Zhang Qilong's
        message of "Mon, 26 Oct 2020 17:12:36 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhang,

> A negative error code should be returned instead of a positive one
> when going to error path.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
