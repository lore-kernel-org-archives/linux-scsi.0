Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0678CC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B2020774
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JUulv6jf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgDXQtw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:49:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgDXQtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 12:49:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGmgJB071699;
        Fri, 24 Apr 2020 16:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=dTgEx1+Rl6VbiWKl5IX0KpeHdkjuU0+SeKoIyVnwCTs=;
 b=JUulv6jfLkd8rIT3I5OsAItx8rhw74N6TQYcGrGC5A7F4g4fLOgp78zjFvxA3/0coW6x
 SLlervw7cMgy0u1m+4ogOPrp08L2H/4J843BnQp28j+0tQhyahAMw1Mq5ynlBu6QYGcI
 6GUtS3Vz14sjyKhK5TzxIFS1gV6ppt9aJrYKI4QaeMYAt9eB3ZGKtIVW5u91zx9M7FfL
 ZZMykjIT/iRhfbAvaluVYvWjuZx7gcOoYvtp3X4fy/mFM1pfBf3aUmhkqtWrBv5V0vh7
 7/uM6md0ZyK/IlnCL/0YUOTPksU27Jb755mo+thWzEhXCq3y263xw9Jx0a8by2Mg6ZEF Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30jvq525mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:49:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGki3D095733;
        Fri, 24 Apr 2020 16:49:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbqm9g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:49:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OGnh0U003096;
        Fri, 24 Apr 2020 16:49:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 09:49:43 -0700
To:     Alex Dewar <alex.dewar@gmx.co.uk>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove unnecessary NULL checks before kfree
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403164712.49579-1-alex.dewar@gmx.co.uk>
Date:   Fri, 24 Apr 2020 12:49:41 -0400
In-Reply-To: <20200403164712.49579-1-alex.dewar@gmx.co.uk> (Alex Dewar's
        message of "Fri, 3 Apr 2020 17:47:11 +0100")
Message-ID: <yq1imhoesm2.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=876 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=950 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240131
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> There are a number of places in the aic7xxx driver where a NULL check
> is performed before a kfree(). However, kfree() already performs NULL
> checks so this is unnecessary. Remove the checks.
>
> Issue identified with Coccinelle.

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
