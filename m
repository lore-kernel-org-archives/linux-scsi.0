Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50D8CA9EC8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 01:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B749A21D7D
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 01:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPaVfOBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438932AbfJRB6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 21:58:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfJRB6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 21:58:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I1sJ5I117289;
        Fri, 18 Oct 2019 01:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=h5ktOrLNB3/BnArupqIcwmGShUepnVNMD+HpWUQUfn0=;
 b=EPaVfOBeQu1z4CF5mB/CZ9apV/MA0GNItqvOZfXwp1XYwiVZIRvezdegNk3HpUPnUs2N
 pLH6EOmILpI0F4nDJSPoZET1Oyro1ECidiwc844zt0BW9+xisEzLHXaZKwc9I8SURTtK
 0R+SiVlxWcLrSObn3Xb1bJKYBmiRUsKkEoMFqN5bx2CCR2lVhP90kRYOvhgM7Tei2AfB
 4JW1vH0MwtuJpTRq0VHlbqFEKd/MQNgbclK4TPV/JZdi8kRTJvvmMAvKVFN80ihjr007
 EO1SZHWCQWHNghdSM/WaSh7U7XGU5SU7jQGKgi05xqt/z/wBC/cUyCZyri2Jo0+n+oKA 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vq0q48q4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 01:58:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I1vRPw177087;
        Fri, 18 Oct 2019 01:58:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vq0ed2puk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 01:58:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9I1wCA5004654;
        Fri, 18 Oct 2019 01:58:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 01:58:11 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Yufen Yu <yuyufen@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: try to get module before removing devcie
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191015130556.18061-1-yuyufen@huawei.com>
        <2a4e5565-d1a1-514f-02a3-0fecb321f93b@acm.org>
Date:   Thu, 17 Oct 2019 21:58:09 -0400
In-Reply-To: <2a4e5565-d1a1-514f-02a3-0fecb321f93b@acm.org> (Bart Van Assche's
        message of "Wed, 16 Oct 2019 19:35:37 -0700")
Message-ID: <yq1imomke6m.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=830
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=932 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> We have a test case like block/001 in blktests, which will create a
>> scsi device by loading scsi_debug module and then try to delete the
>> device by sysfs interface. At the same time, it may remove the
>> scsi_debug module.

Applied to 5.4/scsi-fixes, thanks!

> Please consider to contribute the test case to the blktests project.

Yes, please do!

-- 
Martin K. Petersen	Oracle Linux Engineering
