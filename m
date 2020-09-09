Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBCDC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD9F20EDD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rN3Erhrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgIIC5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:57:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIC5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:57:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892tEXP006119;
        Wed, 9 Sep 2020 02:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=p4ZMBdHYJ7MI719ICTFjTrmq8BqKCPkcIp5vFacyU8U=;
 b=rN3ErhrtB/8aUEyFOi7k3qoN+dzofj/R2RbZGCysFQiX5yagPh294h//d5qjRzMu15eN
 nkKyDReVAgLkWzGNkNWDaSaSSQZ/epD6GooAExNr4YbzADmj73BOZ+y/gOBNcd2yntuo
 ruRP5j09UnYJyHLub41nmF/OTH779lkXKe57e0wK9vp/wDvU5uSPsk1cy/S90zl8qgtF
 Cb9RF4DjElHISYJkbBLItkZOez0XUT8aIyr4duRLp1HH+WtZIkcSle6LdkfuZK8Hn8gP
 xtuh1GlIKuWu5h5Np/ecdb1QOEB8Y4l7vH6K4baYyqo6hzGP9AddCUSdBS9MJ+siRDDa cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23qy3mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:57:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892tRag127425;
        Wed, 9 Sep 2020 02:57:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmes04tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:57:08 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892v7Ln024225;
        Wed, 9 Sep 2020 02:57:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:57:06 -0700
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 0/2] SAN Congestion Management (SCM) statistics
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imcn4q6y.fsf@ca-mkp.ca.oracle.com>
References: <20200730061116.20111-1-njavali@marvell.com>
        <DM6PR18MB3052C2991B834B3A93D96E69AF280@DM6PR18MB3052.namprd18.prod.outlook.com>
Date:   Tue, 08 Sep 2020 22:57:04 -0400
In-Reply-To: <DM6PR18MB3052C2991B834B3A93D96E69AF280@DM6PR18MB3052.namprd18.prod.outlook.com>
        (Nilesh Javali's message of "Mon, 7 Sep 2020 10:44:05 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=980 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> A gentle reminder to review this patch set.
>
>> Shyam Sundar (2):
>>   scsi: fc: Update statistics for host and rport on FPIN reception.
>>   scsi: fc: Update documentation of sysfs nodes for FPIN stats

I'm waiting for James to review these changes.

-- 
Martin K. Petersen	Oracle Linux Engineering
