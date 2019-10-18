Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F56CA9ED0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 04:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62449222C5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 04:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mMwgWt5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407298AbfJRE6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 00:58:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44166 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395367AbfJRE6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 00:58:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2mksh156550;
        Fri, 18 Oct 2019 02:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Fs6HpkV3apQ/dodLIoBkVpnUIHril7K6KI8m/OHnshI=;
 b=mMwgWt5LZLs0oBF1Kwz36Lq0N9Rs1ENNKkllfO/qeNCHgKvcC9WTwHpMXCRq9FMtuSOd
 gyfm/l7cYtNNsQUnJh93FJmN1/aUfmB2RmX3QyxtpahAwiiZRkEeTvbNP1JWdsHOL9lF
 Rh9/7AyArT7q9AAvirrIIo58QMpF96uRa+RYJTpqi+/Mm02FdknmEwdWEOVGVkBmAjit
 ckgxth1FyxRrXMOF7ALfbNCr+T1wta1WP3qVrZJ2yiuBBTDPkbW2PE/G6ntH/VQetFa9
 VOKzfEAY8rFcUHdKVSVBrm2JJpa5BXgfGBYAvmc+CRswj6ySllgA3gkMWnqN9clT8pcc kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vq0q48w07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:52:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I2lreD085403;
        Fri, 18 Oct 2019 02:50:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vq0ed4wd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:50:51 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9I2oogC003401;
        Fri, 18 Oct 2019 02:50:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 02:50:49 +0000
To:     "zhengbin \(A\)" <zhengbin13@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v4 2/2] scsi: core: fix uninit-value access of variable sshdr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571293177-117087-1-git-send-email-zhengbin13@huawei.com>
        <1571293177-117087-3-git-send-email-zhengbin13@huawei.com>
        <yq1y2xiixms.fsf@oracle.com>
        <e14f87ac-5302-0a5e-0e77-bdc0933e332d@huawei.com>
Date:   Thu, 17 Oct 2019 22:50:47 -0400
In-Reply-To: <e14f87ac-5302-0a5e-0e77-bdc0933e332d@huawei.com> (zhengbin's
        message of "Fri, 18 Oct 2019 10:46:32 +0800")
Message-ID: <yq1tv86ix6g.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=831
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=930 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> I modify these in a patch? or every .c a patch, use a patchset?

A patchset consisting of one patch per file, please.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
