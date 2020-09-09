Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7235AC2BC11
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D185216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gjWo4A9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIICEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:04:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIICEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:04:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08920GpD146724;
        Wed, 9 Sep 2020 02:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bI725EQwXGyV5rV6Dx/1p9ZvC5gDqSHkDjKs8RyZZcI=;
 b=gjWo4A9OdkpmR2GgRZ7/WDzHi5WH6OLxxR+kVVkaSoeLdY3LHQetaawlDsEUKImatxYK
 3qzOhDFguUcP2+q3t3CxXxJHBRXDry8LxpvtK25pLktHkSkemLZD+l3ftM8fYmUdmURm
 dPYzlQT0tjr2MtLNqRqcOjh6K5kP5FwePUZVTl8I3Y4oXtVqgBIQla4V/4oty6PZopQm
 +594hG96mkFC64N9ia8fYB2rhAAKXw/MI1wpxaqPnlVaVF9NWnFcs1eNk3xjah5exAp1
 QYlM9XIysLNiBx+OnmlJYWtw2YQMSxosjdmAnEcdEWkS9b5oKCzT41TIVXOCNlu7zffW 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33c3amxtaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:04:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08920LeC172607;
        Wed, 9 Sep 2020 02:04:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33cmkwwanq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:04:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08924RJu009260;
        Wed, 9 Sep 2020 02:04:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:04:25 -0700
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v3 1/2] scsi: ibmvfc: use compiler attribute defines
 instead of __attribute__()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6xz66zs.fsf@ca-mkp.ca.oracle.com>
References: <20200904232936.840193-1-tyreld@linux.ibm.com>
Date:   Tue, 08 Sep 2020 22:04:23 -0400
In-Reply-To: <20200904232936.840193-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Fri, 4 Sep 2020 18:29:35 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=945 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=977 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> Update ibmvfc.h structs to use the preferred  __packed and __aligned()
> attribute macros defined in include/linux/compiler_attributes.h in place
> of __attribute__().

Applied 1+2 to my 5.10 staging tree. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
