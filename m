Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC1DC4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB06D20796
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uswpocyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgJCB3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:29:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCB3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:29:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931RKxa025670;
        Sat, 3 Oct 2020 01:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7b0HhEdUEFqvVt6od23qE4jBAKLwIUjr+ivd1MKqwSk=;
 b=uswpocyBRcbMaizjzWhHgt6nKzLIRSCbAGtKmnRRb47kFGt3NCZH7JK6W//9gXCsLhLa
 kmEYUsXV8MOCL4xG6vFjpZGV7r+GeYgZsJIo95M2zZzYcqSydF45eNOwlRtbi1kGlwuz
 cZ0JFX9U4ugFI6buO60GIi2CGkljhAf/sfSIWlygKZlPGmuPugapcU4qhzQ4fCgjQCzo
 Yxm6J+ihJ9w5QIVUs0fCP3SXJiKXcFR/MAPIAnnsuan1dA0b13PXFoWJXM5aI3bouJKb
 G04NhpYGK5J2hc11f9wUCIf9ReJJ3Oly//BZ4uCe5sJ1sN429rZkaQZa1ga3tO2OqSex Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkmdg1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:28:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931LIpw176278;
        Sat, 3 Oct 2020 01:28:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33xfb8gaxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:28:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0931SrvA002149;
        Sat, 3 Oct 2020 01:28:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:28:53 -0700
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, aacraid@microsemi.com,
        Balsundar.P@microchip.com, Sagar.Biradar@microchip.com,
        Dave.Carroll@microchip.com, Mahesh.Rajashekhara@microchip.com
Subject: Re: [PATCH] aacraid: add a missing iounmap call
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfgocd2u.fsf@ca-mkp.ca.oracle.com>
References: <20200926150015.6187-1-thenzl@redhat.com>
Date:   Fri, 02 Oct 2020 21:28:51 -0400
In-Reply-To: <20200926150015.6187-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Sat, 26 Sep 2020 17:00:15 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=802 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=818 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Add a missing resource cleanup in _aac_reset_adapter

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
