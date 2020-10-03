Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C918C4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07352074B
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ElfUmbDb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJCBTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:19:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCBTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:19:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931Gcic190673;
        Sat, 3 Oct 2020 01:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=u+WOYGQm2TdPEim6psTHO90mJaZMy6UlRYxft+Mrtj4=;
 b=ElfUmbDbY/Yd4eUYBh0qjbET52FuS17DTs/+9MF5o6zgiTEEVB28E32mCKHio33WKJ8+
 OslkHxzl6JKynjee0o6VTojz3h6Sla6Jw0fpz3K2rOEb7R21rtuIDrOc7+NQadjd3mXi
 woIRksZ7rbA4SK3xgURovOVOSFnk3HOU+uT5WBmets377jjHt97juH65yyVjxGcwOpXC
 R45d585qmD6VYo7Ys4CRPnsT9y3+QySiUwFisuD7306XNuCqAltNMt7Sk7yR63iDC7E0
 U65k27maYwqY9vLmZb7cbbPX1n88vxr2CyuFZqmtE04pkZCFq4LDVJQmEMGYxTsPxfCe ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9nnecs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:18:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931EaHR112383;
        Sat, 3 Oct 2020 01:16:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfj3rqpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:16:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0931GpLN029039;
        Sat, 3 Oct 2020 01:16:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:16:51 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: fnic: Fix inconsistent of format with argument
 type in fnic_debugfs.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1362wds7d.fsf@ca-mkp.ca.oracle.com>
References: <20200930021919.2832860-1-yebin10@huawei.com>
Date:   Fri, 02 Oct 2020 21:16:49 -0400
In-Reply-To: <20200930021919.2832860-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:19:18 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> fix follow warnings:
> [drivers/scsi/fnic/fnic_debugfs.c:123]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.
> [drivers/scsi/fnic/fnic_debugfs.c:125]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.
> [drivers/scsi/fnic/fnic_debugfs.c:127]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
