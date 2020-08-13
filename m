Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0349C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8433A208A9
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r9Dys0FW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHMC1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:27:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgHMC1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 22:27:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2NSLi115590;
        Thu, 13 Aug 2020 02:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=fFi9BYcRYyg6fOruuniRWLxsNZto2JjicCeax6zPFNs=;
 b=r9Dys0FWSmLTpF892wABRxbNUX/zRVFyBHnnCEf/L95HQbVG621Z66aEGFAvsWZUviiB
 0nB4Mhs86pWlH7gLSGGohD7IqFcXvVgXZ2x1aJdrIPOIzVqOGzyS7rIpMztL+3kvInxX
 cI/lHmpzte15Et4emDrL32lR1oErrsKS0wOhKvO5CwOt4nYo7XtP4MFvJE9w0Pft2c27
 2UVKpBmLySgyiGQ23kvYI/4aJ9y7fKMS73j+cwPH94kx2+b0vZCLX0mFajaNTnO1vfkx
 JjGngd6wO92EaMMbxnuUf3jDRr46STFqi1zskt7RCpxJ/rT1nL7zXziw6JWSuyAeuH15 aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mx0t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 02:26:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2NNkA061924;
        Thu, 13 Aug 2020 02:26:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32t5y8fmne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 02:26:54 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07D2Qqh9010389;
        Thu, 13 Aug 2020 02:26:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 02:26:52 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v11 0/9] Fix up and simplify error recovery mechanism
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kp7jnag.fsf@ca-mkp.ca.oracle.com>
References: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
Date:   Wed, 12 Aug 2020 22:26:50 -0400
In-Reply-To: <1596975355-39813-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Sun, 9 Aug 2020 05:15:46 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=669 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=1 mlxlogscore=665 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> The changes have been tested with error injections of multiple error
> types (and all kinds of mixture of them) during runtime, e.g. hibern8
> enter/ exit error, power mode change error and fatal/non-fatal error
> from IRQ context. During the test, error injections happen randomly
> across all contexts, e.g. clk scaling, clk gate/ungate, runtime
> suspend/resume and IRQ.

Applied to my staging tree. You'll get a formal merge message once 5.10
opens.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
