Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1CBC49ED9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5492168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HzH/UkSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfIKCWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 22:22:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55734 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfIKCWO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 22:22:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2Jcrt185318;
        Wed, 11 Sep 2019 02:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=cVGwn5U2Mx2pYkevQFIPf3ztfW2/qOngodYNdWoK8Mg=;
 b=HzH/UkSizBwkmXM9LaQuYDbfYtH2NpuVaMBXbZMTB3FqSUUGpn7B4o8P7U42alfqW3bz
 HZKY6jnOIuCsuL4lOIYhAd42BgBtAOD6Qq4wK42nAzic6idZ733mjnzZjzRaprDf31V3
 uY3ZczpiCGrpNlb8/DPqJJemSzHBPdqJvkPEUP1gYj9UhLgM77TtolDp8tNFAtcCQu+1
 4MHoTcF9RFEmhRNYWIG1bsfnN4d34m+yFIZG0GRzI5fpiJ3pTBPthah4THDMIoJ+30KF
 +1sTj2CvzC+HhdJCUT24WlJYTT0LT+VieB92fnTDLAUOgEYdUDpYp8pjwRJfNI6hjxdc tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uw1m8y08c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:22:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2IdT2075941;
        Wed, 11 Sep 2019 02:22:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uxd6dcw4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:22:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8B2M15f028529;
        Wed, 11 Sep 2019 02:22:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 19:22:01 -0700
To:     Laurence Oberman <loberman@redhat.com>
Cc:     QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or TASK_SET_FULL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568030756-17428-1-git-send-email-loberman@redhat.com>
Date:   Tue, 10 Sep 2019 22:21:59 -0400
In-Reply-To: <1568030756-17428-1-git-send-email-loberman@redhat.com> (Laurence
        Oberman's message of "Mon, 9 Sep 2019 08:05:56 -0400")
Message-ID: <yq136h3fu7s.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Laurence,

> The qla2xxx driver had this issue as well when the newer array
> firmware returned the retry_delay_timer in the fcp_rsp.  The bnx2fc is
> not handling the masking of the scope bits either so the
> retry_delay_timestamp value lands up being a large value added to the
> timer timestamp delaying I/O for up to 27 Minutes.  This patch adds
> similar code to handle this to the bnx2fc driver to avoid the huge
> delay.

Does not apply to 5.4/scsi-queue.

When you resubmit, please use git send-email -v3 [...] and put the
changelog commentary after a "---" separator.

> V2. Indent comments as suggested
>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
