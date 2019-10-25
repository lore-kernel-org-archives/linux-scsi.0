Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF0ECA9EAF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1778821D71
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZCKmAd+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbfJYBOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:14:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388026AbfJYBOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 21:14:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1EC3C120999;
        Fri, 25 Oct 2019 01:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=1a+MHjbyOCcpVZeUj7J63HR5g8QMONO9Ccgv5cfa9+E=;
 b=ZCKmAd+4VrzkQCACdmPZHmoTwwlQZi1Xkay7AbJNagnBQazXDmyo+6ljMOCtE6q6Wilo
 5uU9i1DhIyJeEbL+sD/LsF/ni77fciO9bRHXEDAjzT3tfh79T4LAhg/LtW9PfD1BudqX
 XgUIkYrJWH+5xKwtPMyjayGGHe2dcN6AHNVG/Vhsi7ZnRNa6BoJDGRzOAg7020I/677n
 vEwLvPAwcIhPcdPTia/KodnbQXt6Jq3cEyiTil/GCn5x+eob7in3HPQIKEDuSfngldTW
 f8BugCiBm5+sDsc2i9Tsj9a4kFKN3U4P1MF2YxCfWSwtwO1FhdtYn7rDlZETbhZiw0r1 hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteq75n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:14:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1DP7t137995;
        Fri, 25 Oct 2019 01:14:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vtsk6ash5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:14:15 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P1EEvF024314;
        Fri, 25 Oct 2019 01:14:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 18:14:13 -0700
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Naresh Kumar Inna <naresh@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: Don't enable IRQs too early
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191019085913.GA14245@mwanda>
Date:   Thu, 24 Oct 2019 21:14:11 -0400
In-Reply-To: <20191019085913.GA14245@mwanda> (Dan Carpenter's message of "Sat,
        19 Oct 2019 11:59:13 +0300")
Message-ID: <yq1pnilbp98.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=611
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=710 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> These are called with IRQs disabled from csio_mgmt_tmo_handler() so we
> can't call spin_unlock_irq() or it will enable IRQs prematurely.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
