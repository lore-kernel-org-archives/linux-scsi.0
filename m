Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8077C4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236A320759
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkM4ubVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJ3CGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 22:06:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3CGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 22:06:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U24dnh196306;
        Fri, 30 Oct 2020 02:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=+wldT11vFPJ9rs9PNi/y3qEg4AnU+T5sXnI3kPvUu0o=;
 b=BkM4ubVFCMAJFo3K/hQ8v5krvlJmKKI6ts99KjHjW0JJMPPFBbQJ3ydX78BoOXm3TyxK
 za5VdjK33+8i2JEWpsT9D5nMFiCIBAKAkQegr7v5UTYle1sUcmpiAW2oA+aanpMlr+QM
 z3Cyn5JeAPVpS1dceJMYJktNOI6/DfWh4N/M3WQZwEuhTr35LL4Q9aiAypj+6Uhu0Mvu
 moiEd0AhiGKxMHwgJMnIhhAdfI072w7aXVajN5239uut1hVNf1/BSCMmk3Y89dvoJEeu
 iJrseueMKwlOu95kcB+DDYWYdEd5MeaTb2nFZsnB+RBm6VpXgF5Y42zKS3xkAG8ltUMm bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm4daga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 02:06:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U1sX2l007464;
        Fri, 30 Oct 2020 02:06:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwuqfajg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 02:06:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09U262XX028616;
        Fri, 30 Oct 2020 02:06:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 19:06:02 -0700
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
References: <20201026190646.8727-1-ddiss@suse.de>
        <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com>
Date:   Thu, 29 Oct 2020 22:06:00 -0400
In-Reply-To: <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Thu, 29 Oct 2020 22:02:08 -0400")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> This patchset adds missing functionality to return the offset of
>> non-matching read/compare data in the sense INFORMATION field on
>> COMPARE AND WRITE miscompare.
>
> Applied 2-5 to 5.11/scsi-staging, thanks!

Dropped again, breaks IB.

-- 
Martin K. Petersen	Oracle Linux Engineering
