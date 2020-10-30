Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A67FC2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 01:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B028220756
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 01:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UGqKo3vY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJ3Byt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 21:54:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ3Byt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 21:54:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U1p1mn195227;
        Fri, 30 Oct 2020 01:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9BwIeQoynB864aanJXPNY53QHQixtwGUBJ8VvBjvPy0=;
 b=UGqKo3vYLw/Zyj51N8hNzIcI8Jmp7POHk+8JBD2SkijIKlRvun0D/r77Gec596/BwVLS
 Gm1m1tN6B4E6vuibk3oF7O0pi6UXt1zha2PAeKx2tu1kStRyRId4JkQydEPq3lrk2FOb
 6DrCCgYW053Fxm6+ZNLg+bKhPzvhaCRj2Www4rXR+s4yYf0+eZDMclGg698UjhmvHOTv
 usvaIqMgx+emHY/LP/yPw1pjB1Gs+jE5EOtBJd45MB+VNLdf+quPRssasLYOWQJnt6+X
 uyBTTrAeZXKqhvOIukGSU6tMMOeA92Rn855Tj6vC5leBLGdEERZnAdLzMRi2wWEzAK+l Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7m7pd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 01:54:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U1oXsD189072;
        Fri, 30 Oct 2020 01:52:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwuqf0t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 01:52:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09U1qYLU031468;
        Fri, 30 Oct 2020 01:52:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 18:52:34 -0700
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libfc: move scsi/fc_encode.h to libfc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2jo1nvx.fsf@ca-mkp.ca.oracle.com>
References: <20201026160705.3706396-1-arnd@kernel.org>
Date:   Thu, 29 Oct 2020 21:52:30 -0400
In-Reply-To: <20201026160705.3706396-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Mon, 26 Oct 2020 17:06:12 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> Most of this file is only used inside of libfc, so move it to where it
> is actually used, with only fc_fill_fc_hdr() left inside of the
> header.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
