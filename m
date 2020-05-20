Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C37C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA9720829
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H9rgqIVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgETB6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 21:58:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgETB6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 21:58:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1pbPZ078876;
        Wed, 20 May 2020 01:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/KpLfiF3yE04CnWO301FHWY+Pb0/izJPSpL1Ck1Oh3E=;
 b=H9rgqIVIO8tVMlKGHRMeKD6zV3D9RcXUiaLMlJDpth4bKowufEIkgg2NkSud4P76X/Z4
 bYmWn6dwvWv8cASbpNSIS74DP69/GLncfPNGAJScC+CYxPx/E9XFOK5fg5PqPJb1j5Um
 hw/17lZbJQezSw/J84qkWMMLGU56hEpl2CYmrWLQFx6q8MQqLH7rgG/reydpXpDMtCt2
 R3EPeRCV/yndL2KvpG121w+EWY5aSUHXr2euAnVQY45q6DcG0CmgLVDls8X9XKSHeTeg
 cd0XjwdIyfkUXQ3ANL1wtG5PYZhvgMtib0cZo7WuDqiBLPKbbx9hUmqpHPAZ/PJRVtHp 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tngfrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:57:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1sUOx095184;
        Wed, 20 May 2020 01:57:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 314gm64dpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:57:50 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1vmT4008030;
        Wed, 20 May 2020 01:57:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:57:47 -0700
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1d06zweqg.fsf@ca-mkp.ca.oracle.com>
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
        <7440e420-009b-20cc-e1e6-7e2a212f65fa@nvidia.com>
Date:   Tue, 19 May 2020 21:57:45 -0400
In-Reply-To: <7440e420-009b-20cc-e1e6-7e2a212f65fa@nvidia.com> (John Hubbard's
        message of "Tue, 19 May 2020 13:12:11 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Looks like I accidentally doubled a word on the subject line: "convert
> convert".
>
> I'd appreciate it a maintainer could remove one of those for me, while
> applying the patch, assuming that we don't need a v2 for other
> reasons.

I can fix that up. But I'll give Kai a chance to review before I apply.

-- 
Martin K. Petersen	Oracle Linux Engineering
