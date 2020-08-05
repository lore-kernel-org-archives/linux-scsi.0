Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C996C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6AF20792
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CitZheOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHEBhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:37:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:37:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751W3t9172507;
        Wed, 5 Aug 2020 01:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5Eu7L9altjruEWUTdGR7Z491/l/hXA9PH6iXAcYgRmM=;
 b=CitZheObdqyg0Z3cy9CYRpsToxWCGLKmZx4HYYg74BtwpY+I65ApPxJ0Jd8/GA6Ld4TG
 eJW7OGJx6N1+0/0Jj+XjASVK4wiau8+tE4qi9jJLU3LzpS890oiNKxZxVGOcpPJ25n6Y
 8MeDx7QaXo1DhrHnrMLGLXgSfZArrkMOL7WZ4ZNCjlK0p2hVuYuoWomvPPHGMxP+aZst
 j0d/CMFOz1jDPJtpR/pqajJhiqI9pNpHAg1DcRueYrsuEPeh2zASVJJEK6itkJJ7WtO6
 dk4wh/Vvyz87VmSS6zgH19tWwKXty+fH1YKJXKBdr0FS1mm1clozuzQ7KmncGcxD9tuT fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32n11n7c0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:37:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751X9Xf179356;
        Wed, 5 Aug 2020 01:37:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32p5gt2ee5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:37:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0751bWf5024472;
        Wed, 5 Aug 2020 01:37:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:37:32 -0700
To:     "Alim Akhtar" <alim.akhtar@samsung.com>
Cc:     "'Randy Dunlap'" <rdunlap@infradead.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfitzxgf.fsf@ca-mkp.ca.oracle.com>
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com>
        <20200721172021.28922-1-alim.akhtar@samsung.com>
        <857eba45-475e-e2ea-86ba-e495794ae74c@infradead.org>
        <005b01d66ac8$429b8460$c7d28d20$@samsung.com>
Date:   Tue, 04 Aug 2020 21:37:29 -0400
In-Reply-To: <005b01d66ac8$429b8460$c7d28d20$@samsung.com> (Alim Akhtar's
        message of "Wed, 5 Aug 2020 07:02:15 +0530")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=1 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alim,

> I don=E2=80=99t see this patch in your tree, let me know if I need to -re=
send
> this.

I postponed the Exynos update to 5.10 since there were a few zeroday
warnings and it looked like the 5.8 release was imminent.

--=20
Martin K. Petersen	Oracle Linux Engineering
