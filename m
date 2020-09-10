Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06F2C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC1B21D6C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b05AJ5Qm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgIJCqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:46:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgIJCqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:46:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2eQDU147813;
        Thu, 10 Sep 2020 02:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=JSbb0b1+sYg2K7gSsSVOpFLen5pl/otZ2V+3AB36FZ8=;
 b=b05AJ5QmA6AAfsAS4JFGRjVNJs+BQcGRRlFds26Q4igp5DElI+p4xKDgA+tcNXx5Gdhw
 SYZXQYm3pTCYtbLFVpHdFBQJyonrWnRpB+1MWgcVIMzmnXxwR5ZmrEmzTrRuzpfZYJ3g
 cGyMU03nM+kO7QZWlVVaIh6KOENW3hs/2r3D65Fq6oYikZF5Jfc4yIajxTtM5Bk6WSzv
 Am6LRMAgDlV16I1MiLTQ3hEU4oIcFK8puatLPNV4b2Yve8XJwkfDHwehwBiWxkOqPIQ6
 +UjIBWetjjfx+N8aQsqkTS3HteYRntY5BykwBoIGmC+JBAqeJL/4OpP2f+/EfjGN/Yuo kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3an56xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:46:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2dVRO157422;
        Thu, 10 Sep 2020 02:44:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33cmeu09sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:44:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08A2iCOJ011750;
        Thu, 10 Sep 2020 02:44:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:44:12 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: gdth: Remove set but used 'cmd_index'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgbq1hed.fsf@ca-mkp.ca.oracle.com>
References: <20200909082627.101984-1-yebin10@huawei.com>
Date:   Wed, 09 Sep 2020 22:44:09 -0400
In-Reply-To: <20200909082627.101984-1-yebin10@huawei.com> (Ye Bin's message of
        "Wed, 9 Sep 2020 16:26:26 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> This addresses the following gcc warning with "make W=1":

Applied your gdth, pmcraid, and lpfc fixes to the 5.10 SCSI staging
tree. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
