Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5361C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0212081A
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aWxjc7xA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgF0R5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 13:57:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgF0R5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 13:57:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05RHo6ln064903;
        Sat, 27 Jun 2020 17:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HLOz9kDIzLCFVGuef2bWdtwPRWQv/R1O3VG3deV5rYo=;
 b=aWxjc7xAxaKRoF23k/UL92NwiTbHNf38/b5EdWI4wbgb9X0K+UvPmdLifd18X+sRopce
 UeIA2I7Z65c6bcm6kdop95ydVT4rdbQwjt3Juo1KSycDb3wEA2Geq87NYQM9neZMVEUS
 cwP22BzoI+99E1yIvfoIh9kFvCbgAwiKh43HCVLBIFT/m3C/0x9lFs8cQKlui1LgN4Ik
 PiEogSoQ30/Sy5vF9/vNkE83yeqY/ZO1jd2PG3FUMSA2JCEn1giAKIkY9BKymuM7KayU
 1QlDl1FYf0nnfB7ApUqhbNmAWP0sTyebYQbulMOVoP0DMkmy2y9AZaWJgSs42T0r/wE2 +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrmsb72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 17:56:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05RHsOfs026954;
        Sat, 27 Jun 2020 17:54:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31wwehp5nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 17:54:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05RHstx8019373;
        Sat, 27 Jun 2020 17:54:55 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 17:54:55 +0000
Date:   Sat, 27 Jun 2020 20:54:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Kukjin Kim'" <kgene@kernel.org>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Wei Yongjun'" <weiyongjun1@huawei.com>,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: Remove an unnecessary NULL check
Message-ID: <20200627175445.GG2571@kadam>
References: <CGME20200626105156epcas5p191d18d66af6bd09a10635559461c0bc0@epcas5p1.samsung.com>
 <20200626105133.GF314359@mwanda>
 <041701d64ca7$70bafb80$5230f280$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041701d64ca7$70bafb80$5230f280$@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9665 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9665 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jun 27, 2020 at 10:51:44PM +0530, Alim Akhtar wrote:
> Hi Dan
> 
> > -----Original Message-----
> > The "head" pointer can't be NULL because it points to an address in the
> middle
> > of a ufs_hba struct.  Looking at this code, probably someone would wonder
> if
> > the intent was to check whether "hba" is NULL, but "hba"
> > isn't NULL and the check can just be removed.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> Please add Fixes: tag
> With that
> Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

It's not a bug fix it's just a cleanup.

regards,
dan carpenter

