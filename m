Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F397C35257
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEDA20758
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJaFsovM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgJCCbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 22:31:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJCCbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 22:31:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0932UnEo125073;
        Sat, 3 Oct 2020 02:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=AHIJHndUWDOhZ1tf2gXu+pgSucaKlmzUp8l2/R/cryU=;
 b=CJaFsovMPP/JaHJz/b5KEkBP8SH/VxYhi8NCOAEsredQfNXMnuJgd/LxkMglNakbg8CG
 +cfLGIhQWUtUFB6iIhk2V2VGdSzrDqWvoMrP4+Knw2oqWQiVlsOXy0R1JtDKo+lz25ml
 A/SAOTmaohBaHjlQlfSGwTncYfnCf20rSKfIaDRChbafLjmJz/jw0Jzzzbf+lUPY7zao
 n2cOzgT55Ta/1iF2lotE+F848xBTgVFWPmOrt/Lslnrx/z82MS8Lkiy/A0vQvBauFz2K
 EqDmVedqJclJfaqjc8OQupmyX8WXvzqV5WAU+UyfWkAOKekPUhbP2iLIOOXJPdhQTT/b 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9nnga1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 02:30:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0932Ubj5069975;
        Sat, 3 Oct 2020 02:30:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfj3t8q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 02:30:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0932UeUt032414;
        Sat, 3 Oct 2020 02:30:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 19:30:40 -0700
To:     ching Huang <ching2048@areca.com.tw>
Cc:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Subject: Re: [PATCH 0/4] scsi: arcmsr: Fix timer stop and support new
 adapter ARC-1886 series
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7rcavne.fsf@ca-mkp.ca.oracle.com>
References: <0fcd9588bb87f47856316677e8bb495f14fcb597.camel@areca.com.tw>
Date:   Fri, 02 Oct 2020 22:30:38 -0400
In-Reply-To: <0fcd9588bb87f47856316677e8bb495f14fcb597.camel@areca.com.tw>
        (ching Huang's message of "Mon, 28 Sep 2020 18:19:24 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=853 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=868 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ching,

> This patch series are against to mkp's 5.10/scsi-queue.
>
> 1. Remove unnecessary syntax.
> 2. Fix device hot-plug monitoring timer stop.
> 3. Add supporting ARC-1886 series Raid controllers.
> 4. Update driver version to v1.50.00.02-20200819.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
