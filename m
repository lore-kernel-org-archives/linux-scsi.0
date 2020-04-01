Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08058C2D0F3
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D040D2072E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g+yFlm+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgDACYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 22:24:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731616AbgDACYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 22:24:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0312NCOf121187;
        Wed, 1 Apr 2020 02:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=eWtf71eTyi+Z8V/GP5KBYIJNVxz5B9sf7I93g8NoESk=;
 b=g+yFlm+8zugzvuFgf+SXD0xQpYTd8c25A6eyLnVSvkB6JSA5IhzVp9b/sKwv+HxDtAin
 4Nw59cX2cA8qPVTgDYeARBFd6FDbugK2CleSD+blTUFh8oby/UiVKYQQTpBM2IwU3RsK
 YzvzjbDPUcNWx33JuTHYkuTQrDtyMpmNw0nlJCEiGqAyis4uROdSgyJ3BgplFdEZ26Xi
 D6qKXW824o22XZUWTlYllFxzj8VeVgdY6SEMGsfvblSZMP8oHGZ+ZEr/vQmVTgTWb+8F
 UcnMFaJHHieg7TWkwbpv9v2Ax6/ionTwER8asXMI/WYK/1zwKIjS6iEnMJSb/6+jpgDf fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqhk93u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:24:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0312Mx9x156513;
        Wed, 1 Apr 2020 02:24:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 302gcedhke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:24:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0312Ofc8030345;
        Wed, 1 Apr 2020 02:24:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 19:24:40 -0700
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Joe Perches" <joe@perches.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>
Subject: Re: [PATCH] zfcp: use fallthrough;
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <d14669a67a17392490d3184117941123765db1a4.1585663010.git.bblock@linux.ibm.com>
Date:   Tue, 31 Mar 2020 22:24:38 -0400
In-Reply-To: <d14669a67a17392490d3184117941123765db1a4.1585663010.git.bblock@linux.ibm.com>
        (Benjamin Block's message of "Tue, 31 Mar 2020 16:21:48 +0200")
Message-ID: <yq1r1x854ex.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=781 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=836 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> Heiko C. applied the other changes from this series to the other parts
> of the s390x architecture, so we would like to have them for zfcp as
> well.
>
> I ran them through our regression suite with error-recovery and I/O,
> all looks well for us.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
