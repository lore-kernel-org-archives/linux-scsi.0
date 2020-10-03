Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F24BC35257
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE767206FA
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yhSEwJQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgJCDLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 23:11:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgJCDLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 23:11:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09339FnJ181646;
        Sat, 3 Oct 2020 03:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=oItmdEaeIAaqyxoLoOo5RezFovUnw4M8ThBzmA7X9uE=;
 b=yhSEwJQVGzslOQ61C/U4ZYqEb3s/SR91nw67qCXhSLJKAqdEnfwDFk8WDcpIMC13HvkP
 dXgfkCtNVwftK13lssttTpWh1fUpT4MdUgVk+aaVMNTCBKc5eplxyGV9zKUrzbfpIXah
 6Hf2hT2nmlhItnJ+IhI7aWN6uMtBI6NbvYyRsA5COes2AutykhWBIdt9TfIu8j4ehfPF
 xEkBiU6axiOyYzf8Bgn6ES8uDTrmb5MjN9mQ8GwvJxoK1ieDJclVgJcIAPJKRE9ed2xd
 Q/1l7Pvj2VY4dj4tH5TWwX10pyNWkJZMrek/zGrOImNorSDg3cnyD9w8W4b95d89zRfQ YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9nnhpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 03:11:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09339sI7001503;
        Sat, 3 Oct 2020 03:11:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33xeds588y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 03:11:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0933BSsu004954;
        Sat, 3 Oct 2020 03:11:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 20:11:28 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH 0/7] hisi_sas: Add runtime PM support for v3 hw
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6x4atrp.fsf@ca-mkp.ca.oracle.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
Date:   Fri, 02 Oct 2020 23:11:26 -0400
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 2 Oct 2020 22:30:31 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series adds runtime PM support for v3 hw. Consists of:
> - Switch to new PM suspend and resume framework
> - Add links to devices to ensure host cannot be suspended while devices
>   are not
> - Filter out phy events during suspend to avoid deadlock
> - Add controller RPM support
> - And some more minor misc related changes

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
