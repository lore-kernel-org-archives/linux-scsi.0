Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF45CC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A617B2080C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GXojmETY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIICRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:17:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIICRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892Fxtg148720;
        Wed, 9 Sep 2020 02:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HSckqXznoaMXUv4GDxENUhHmF3BMRSMtV+ynXbTnyTU=;
 b=GXojmETYcj8oZPtdDGQ8lnFdMG0hYQBr5w3e8UfkkSBfot0lwZdkwBRAEzcfKr31d8J3
 /3MCBtE7lcwBXxlrHqZTHY604MiUc/03ijq7lhZ1CwsmDW5OQ/8kSyEAVeP5TIj2cmta
 /0z+PxizSSeeJLdb1MTldmGHnojVRtBknWyrSywTRouo27Szt+nqjnbOGpICftbPudvS
 A8wfzQVa9w4GQorwnCzap0BdRBVuKCJrruAWV0ijFz7kj5GoG/TmAFgnC7UF4+6MKIDN
 d0Owt9nOd0EIdLID5B7F0ZI1bzgVDkD8xpkswE1zvKEPenTBeMYTZdCX1kM8wkzZt34c 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23qy0w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FQje026543;
        Wed, 9 Sep 2020 02:17:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33cmerxmm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0892HdsQ025680;
        Wed, 9 Sep 2020 02:17:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Denis Efremov <efremov@linux.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] scsi: libcxgbi: use kvzalloc instead of opencoded kzalloc/vzalloc
Date:   Tue,  8 Sep 2020 22:17:25 -0400
Message-Id: <159961781205.6233.8525039192106571238.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200801133123.61834-1-efremov@linux.com>
References: <20200731215524.14295-1-efremov@linux.com> <20200801133123.61834-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=978 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=992 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 1 Aug 2020 16:31:23 +0300, Denis Efremov wrote:

> Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
> and use kvzalloc/kvfree instead. __GFP_NOWARN added to kvzalloc()
> call because we already print a warning in case of allocation fail.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: libcxgbi: Use kvzalloc instead of opencoded kzalloc/vzalloc
      https://git.kernel.org/mkp/scsi/c/ee9108fedf63

-- 
Martin K. Petersen	Oracle Linux Engineering
