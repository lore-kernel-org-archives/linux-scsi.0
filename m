Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19CAC3F2D1
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18F62468A
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evPEml/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB2Bq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:46:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2Bq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 20:46:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1giS2043130;
        Sat, 29 Feb 2020 01:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=541CdlYQ/NJwQN95TS6F7fpWNki9nNrg7JPjVEdd4L4=;
 b=evPEml/+g7EE1b7xKs7/jO+79Pekxs+VbB6Os8TU1+MKr2bxMCAVYtUspNPATsiEWqcY
 TcgWSx3JEzF7KOsfr7ejsEVTyxNQ4j+X/62SaNU1j5gdX9JZAppcoAlorD36UzpEh4h/
 i8NxxPbFB/XqrRDls18SCvtELAch4q2WCWG7Py0xKeXFKSfKPHvry5SwKDDUic25p+/d
 flVJtyhBHh1GvAEYhecbKTqIKoUys3ZzxQzSrWCpptW+bwAX808pGbG5+38A+kIwQAU2
 ePv+UZ+bqZ29lvs3cIIjfrw9XHO+1GfqKSFHwJ35CfP7Rphq9jFerRSJcTpHCO9R4OYb Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3p25h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:46:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1iOLw122368;
        Sat, 29 Feb 2020 01:44:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydj4sbna0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:44:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01T1iMr8015371;
        Sat, 29 Feb 2020 01:44:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:44:22 -0800
To:     guosongsu@gmail.com
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guosong Su <suguosong@xiaomi.com>
Subject: Re: [PATCH] SCSI: use kobj_to_dev
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225100411.10250-1-guosongsu@gmail.com>
Date:   Fri, 28 Feb 2020 20:44:19 -0500
In-Reply-To: <20200225100411.10250-1-guosongsu@gmail.com>
        (guosongsu@gmail.com's message of "Tue, 25 Feb 2020 18:04:11 +0800")
Message-ID: <yq14kva6ubw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=763 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=823 mlxscore=0 suspectscore=1 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guosong,

> Use kobj_to_dev to instead of open-coding it.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
