Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB8EC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5910E206BE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kPObZoXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgIOWiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:38:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgIOWiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 18:38:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMXihO107584;
        Tue, 15 Sep 2020 22:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=qRdlesPSJAprlMkfqOmIvb04nMBCKy0yof1m9GqqBko=;
 b=kPObZoXJ6xIk79izAMox1ThWSbYli1Jp0v8aZKJfhnArwqwLK8fwhrcuHuysdc6h4WRe
 +t5oA6agIWewIO7yd7Nadam0VAk+5fKZf7dm+O0Fl8HJNfkEAIH04neVSjQ0s1b6PZl7
 87DTg+vTGDeU6bKZSfCKVv9V5xCFDh/2aMeOI1VU1H8qkeEJFKeiz4b48kXnbotJTU4K
 w5ENgveTKneMWfm5xL439j5irrJSsdg7xufAMR7i2b9gQdxcKxhqoqpmA9w8yO/KNJ8g
 oDCRLK/Dm2iVjQsU9NPlshfVu0Fn5Ko5xD3sAmrAJKsnv24Vi4U/4MuzKgrbWZvcODBV cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrqyx8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 22:38:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMZxoH152817;
        Tue, 15 Sep 2020 22:38:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33h7wpuaec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 22:38:07 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FMc5qn015645;
        Tue, 15 Sep 2020 22:38:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 22:38:05 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: a small correction in _base_process_reply_queue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgbi3buj.fsf@ca-mkp.ca.oracle.com>
References: <20200911180057.14633-1-thenzl@redhat.com>
Date:   Tue, 15 Sep 2020 18:38:03 -0400
In-Reply-To: <20200911180057.14633-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 11 Sep 2020 20:00:57 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> There is no need to compute module a simple comparision is good
> enough.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
