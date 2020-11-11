Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91325C55ABD
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F776216C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:30:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UVQrlxJi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgKKDay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 22:30:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKDay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 22:30:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3TuM4129981;
        Wed, 11 Nov 2020 03:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jDerpKf8AvkzfHzelgGuD88DpUMODbhHW59HrCLw2DQ=;
 b=UVQrlxJi2pKgW6k4t6W9MRAQnQJXrUJwQiQkpiPk3dl2HklSMN7ToVxLWNGOkupO6Jyf
 HBQzsyIAbLqaxd3qIXFhqqOV1AyYLJv4V6frN4lj/HKdAGrpCtsW342MLUl/Qb5cd17m
 rWalfry65kwlJD/2gSTshNkUjAUSjAycGssbrRLelzIXlNUkDCtS0lrn15Ko6FrYEDL+
 Yc3qIlAPF7PhSmi2fp29rOCtxij6c0p5ZkSxp+vE7vZOPJxxAzkE0DLsdeM61tjkG88J
 vKhld3NQ68hgg8h6PBwC1oO8H+ek2Bq2VnfvtA4vUXm3FZGxpYR1afo5Lbeuir0DZLYs vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72en67h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 03:30:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3P6Wp068201;
        Wed, 11 Nov 2020 03:30:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34qgp7qhjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 03:30:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB3UnvO004224;
        Wed, 11 Nov 2020 03:30:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 19:30:49 -0800
To:     Lee Jones <lee.jones@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RESEND 00/19] Rid W=1 warnings in SCSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2j8fu44.fsf@ca-mkp.ca.oracle.com>
References: <20201102142359.561122-1-lee.jones@linaro.org>
Date:   Tue, 10 Nov 2020 22:30:47 -0500
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org> (Lee Jones's
        message of "Mon, 2 Nov 2020 14:23:40 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.

Applied 1-18 to 5.11/scsi-staging, thanks! Patch 19 didn't build.

-- 
Martin K. Petersen	Oracle Linux Engineering
