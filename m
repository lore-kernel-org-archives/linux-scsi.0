Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1546BC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A692177B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sQ40q3wR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIICR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:17:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgIICRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FS7f170492;
        Wed, 9 Sep 2020 02:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=CmZ3vEqIoazKsKNGG4kwsZZjuEWSdbFf5M7cTkE+ze8=;
 b=sQ40q3wRN1dJkh7sM5Mr87ADLw7dngtCoChYTMaf1mx24LqEOIhUn2MPJy0Tmcf5uW30
 cSrbZkU08F75fBh8agpp0jAN5NFODQf3swP2j0RvZwhllt7DUuYnIFfz90TU37y7hrtw
 i7RNWntB7kpaUXggdRPlJmW0JE9L832aPQo8joed70lT1mivzGUDUBTo37hAyKWeatSh
 WxCpgTsuhUN9sXyR2rt1qwqs49j7VPHSiRrMOMl/LyR7Vi8D/HyW/q3FKkQXInJpwqMV
 2+GLyqkpQreGk6LbtyFzGScri0uddvcbrNR5DR4UYAj5Jo1x+/Z92PgpVHWfLeRw3921 DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3amxuay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892F2Ko132112;
        Wed, 9 Sep 2020 02:17:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk53ymc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:46 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892Hkj3015295;
        Wed, 9 Sep 2020 02:17:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        Li Heng <liheng40@huawei.com>, sreekanth.reddy@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: Remove unneeded cast from memory allocation
Date:   Tue,  8 Sep 2020 22:17:30 -0400
Message-Id: <159961781204.6233.7965470333466838629.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1596014390-18605-1-git-send-email-liheng40@huawei.com>
References: <1596014390-18605-1-git-send-email-liheng40@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=924 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=930 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 17:19:50 +0800, Li Heng wrote:

> Remove casting the values returned by memory allocation function.
> 
> Coccinelle emits WARNING:
> 
> ./drivers/message/fusion/mptctl.c:2596:14-31: WARNING: casting value returned by memory allocation function to (SCSIDevicePage0_t *) is useless.
> ./drivers/message/fusion/mptctl.c:2660:15-32: WARNING: casting value returned by memory allocation function to (SCSIDevicePage3_t *) is useless.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: mptctl: Remove unneeded cast from memory allocation
      https://git.kernel.org/mkp/scsi/c/8fee79ed8ea2

-- 
Martin K. Petersen	Oracle Linux Engineering
