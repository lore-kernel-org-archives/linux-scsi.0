Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A9DC83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 01:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814602051A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 01:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OTEWS7wo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD1Bsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 21:48:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgD1Bsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 21:48:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S1gijB194611;
        Tue, 28 Apr 2020 01:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=fhKLJ893u690XV8dqxeEV2iPiR/BZuKXc4gcS8Su49A=;
 b=OTEWS7wobXNvL6ztC23ac1S7DbFNM8Ej6DW478gagXbdTjjJnHJCWOhhfdfFWkl54JK7
 3P9OZPCsoespgzCfKYi2tHzrO93QHHg2Sc9OYrGoGKn5c+f3J4VdkmMtYHRNqydAkXqK
 lbDthbiOvV/RN/hofR84NXm5t0RG+dCMHqwGFCNqhRnEakk6Pn/XeOTIeoD5oZIsEZR5
 k/jxbcu1mFo9fmdXhb4vmxPUkVIZN/hP+s0xWj7oMiZ2F6ZzwAEVnDSHyoX7NO7HWcoZ
 nlUURMHRcnUt5bPhkn7c7YIXWVP5dwmBsCRjRLzw08TKcyfks6fNxQZTEP6qIDghanh9 Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfvyjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 01:48:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S1lqxv056035;
        Tue, 28 Apr 2020 01:48:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30mxwxgby7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 01:48:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03S1mcNR031134;
        Tue, 28 Apr 2020 01:48:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 18:48:38 -0700
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        brking@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvfc: don't send implicit logouts prior to NPIV login
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200427214824.6890-1-tyreld@linux.ibm.com>
Date:   Mon, 27 Apr 2020 21:48:34 -0400
In-Reply-To: <20200427214824.6890-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Mon, 27 Apr 2020 16:48:24 -0500")
Message-ID: <yq1368o9y8d.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> Commit ed830385a2b1 ("scsi: ibmvfc: Avoid loss of all paths during SVC
> node reboot") introduced a regression where when the client resets or
> re-enables its CRQ with the hypervisor there is a chance that if the
> server side doesn't issue its INIT handshake quick enough the client
> can issue an Implicit Logout prior to doing an NPIV Login. The server
> treats this scenario as a protocol violation and closes the CRQ on its
> end forcing the client through a reset that gets the client host state
> and next host action out of agreement leading to a BUG assert.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
