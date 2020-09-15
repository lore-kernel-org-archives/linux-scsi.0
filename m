Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB38DC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 957B12078E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uQb5YDGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgIOVqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:46:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgIOVqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 17:46:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLSwWt096490;
        Tue, 15 Sep 2020 21:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=gDATj3HQu5NX3oZavtrEX8T1UG7fxQo1Pj8JOqxXU+o=;
 b=uQb5YDGRqJZ8BQoTIrtCu4YuTgZb2evLd14yOxSBHm2RIdFAFC5Eavn+KFhGlbLK0ZZ1
 FRdm/wdR5WFH5VxPuDVXrhYEORylzbZZ9uHblLfNFXB2upQoe3FQNpQTII2iteZ1WTet
 xKruFtnNSYPIJqajW3VOZLf7lfchHSJ4Hd6/M0qoyXDYGw/MP7kpBmXged7Oi/PEwX/s
 Xgr2Uzp/G8kLALs51oujYpy3aDpXNTvrNOuCiplJ45srzgt0vVqSYp8HzzhlGIjjtQft
 4m0eSdKzVoYbgqZelsEfzJBoCmCqrK47DoNTNfJGpCEaMFTRmDMGsHaTRxsCxgdFMdgg TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9m7r5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 21:46:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLUhtW026571;
        Tue, 15 Sep 2020 21:44:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h89031h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 21:44:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FLi3Ym015438;
        Tue, 15 Sep 2020 21:44:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 21:44:02 +0000
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <linuxdrivers@attotech.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: esas2r: prevent a potential NULL dereference in
 esas2r_probe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rj267ij.fsf@ca-mkp.ca.oracle.com>
References: <20200909084653.79341-1-jingxiangfeng@huawei.com>
Date:   Tue, 15 Sep 2020 17:44:00 -0400
In-Reply-To: <20200909084653.79341-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Wed, 9 Sep 2020 16:46:53 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> esas2r_probe() calls scsi_host_put() in an error path. However,
> esas2r_log_dev() may hit a potential NULL dereference. So use NUll instead.

Wouldn't it be better to move the scsi_host_put() call after the error
message?

-- 
Martin K. Petersen	Oracle Linux Engineering
