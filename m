Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA4FC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3E2720725
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="blfN/mZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEHBv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 21:51:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHBv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 21:51:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481m8C8187383;
        Fri, 8 May 2020 01:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Kb04Qfg8juvlN/OOx8N74uvmaF50ZCMBUYt2G4DFVYQ=;
 b=blfN/mZ2YV3svdaD/+LMm6SMr2fYKlsEQ5gvmA1D6OZJOdaDPapzMogp8szausQaC2aN
 /HGMob0EZln3/mcAQnnbCNSa0JxlBbNLMHZ1HiZxOljte3YYiVuRUaTafQy+hybRtZCu
 4xO6rPgxQ18Ff2Sw1YmDN5bTZ1KQXalcciNGzsNmR9CH+JZIVth8VOXOcOZdUGgEiG/K
 jyjyy5BM9+63ktjeiZtbXbK8lmmOh9H8pqtpldBDXPOXEGQjUVvNc+cynYXiC1T3G4cq
 TRodI7tl73jC2xGg+t+FKp3K/dG2K+K/r44/Bbk4h8x2g7hfZ/XyxQuSLifqPYA7i7oF ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30vtexrmb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:51:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481pats058565;
        Fri, 8 May 2020 01:51:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30vtdxtw3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:51:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0481prqT031390;
        Fri, 8 May 2020 01:51:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 18:51:53 -0700
To:     Viacheslav Dubeyko <v.dubeiko@yadro.com>
Cc:     <linux-scsi@vger.kernel.org>, <himanshu.madhani@oracle.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux@yadro.com>, <r.bolshakov@yadro.com>, <slava@dubeyko.com>
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
Date:   Thu, 07 May 2020 21:51:50 -0400
In-Reply-To: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
        (Viacheslav Dubeyko's message of "Fri, 24 Apr 2020 15:10:22 +0300")
Message-ID: <yq1h7wr5h3d.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=976 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Viacheslav!

I applied your three patches to 5.8/scsi-queue. Please use git
send-email in the future and please include a cover letter. Both b4 and
patchwork failed to parse your mails. I had to reconstitute each of your
patches by hand and manually add links and review tags.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
