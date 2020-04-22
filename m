Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AADC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC0B206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jzSyMvcL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgDVEOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:14:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVEOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 00:14:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M4Dw51075757;
        Wed, 22 Apr 2020 04:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ucC4SQGpg8AtAMnoug7+Z1P1JXUP8GL7Tu3/FiY8vXc=;
 b=jzSyMvcLrLfHpKlCn7/QMMO560S1Uz5rLb+z0Wv/09No3IY0COZW03Eps6kpsSOFWVDq
 m8EYTf4zXOLU06XPul0Z8L2rE537E8MD0JtXbGwQBzo81SxC+cnVj0ypdBoF6elkFxl7
 uF3sy8upsEZU+pjiq71OzuTlRbZThOWY+duOXPbJbUimj7e2l90Z/gvKNZVPgaWzRMuz
 hpXUD7Fvz6z+iSIwf7mgMMfymARW/Fh7jk5gMb7gSTX3ScGVnmUvF+iSN+Opd3AZsTSI
 dcMYvhgetjV5WyfK1FoDFJmQwM/Gp9MGIxQr8v9Fd+yj4w1ckkMNzAOYBE7dNsnlMRkk Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n8afb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:14:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M4Bbu1165841;
        Wed, 22 Apr 2020 04:12:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3t8006-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:12:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M4C9pf032024;
        Wed, 22 Apr 2020 04:12:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 21:12:09 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] lpfc: remove duplicate unloading checks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200421203354.49420-1-jsmart2021@gmail.com>
Date:   Wed, 22 Apr 2020 00:12:07 -0400
In-Reply-To: <20200421203354.49420-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 21 Apr 2020 13:33:54 -0700")
Message-ID: <yq1r1wggnvs.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=893 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=954 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> During code reviews several instances of duplicate module unloading checks
> were found.
>
> Remove the duplicate checks.

Applied to 5.8/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
