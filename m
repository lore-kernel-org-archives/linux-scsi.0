Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E322FC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5C92087C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fCx4BGZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgIJCfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:35:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbgIJCdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:33:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2SWH3127504;
        Thu, 10 Sep 2020 02:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=an7L+UH4c4nfLl3pql5CjoOv/Ddb1mwYqyEWS3Cvcyk=;
 b=fCx4BGZUczIglj7jc1RleSkP1Uk1MKnS7WBWvEvM3C+PIEG5YjEErUSGNugY+u8VevXV
 vWf0b0eEZmtGm/mvU7cIQrUKsDxLaqD0g85JWx5p0fDIXD5X/7B291fW6XjHZrRAMt5u
 e78t9dE9iVxYXgwv6TPFSHY/yaRLzpknyTYYi5T1N6aoV7j5s5WEc0Qkgwa8zivfIbNf
 AG/MhvSZPWhnlyDQNkljeSrtjs0qt+MLqhq3sYiWyKxO6gu25PjAU1jt/Sh4sA6iXeDp
 kurY2NckGubMTnEJwF1hvrn5UEpbMwxrWkZQlH3dPEU6SKWD3t1stdXioGFBZ7opw5wO SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mm5868-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:32:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2UT2u140713;
        Thu, 10 Sep 2020 02:32:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmkyyw9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:32:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A2WlZF013885;
        Thu, 10 Sep 2020 02:32:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:32:47 -0700
To:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
        <1599099873-32579-2-git-send-email-cang@codeaurora.org>
        <1599627906.10803.65.camel@linux.ibm.com>
Date:   Wed, 09 Sep 2020 22:32:43 -0400
In-Reply-To: <1599627906.10803.65.camel@linux.ibm.com> (James Bottomley's
        message of "Tue, 08 Sep 2020 22:05:06 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=964 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=952
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can and Stanley,

> I can't reconcile this hunk:

Please provide a resolution for these conflicting commits in fixes and
queue:

307348f6ab14 scsi: ufs: Abort tasks before clearing them from doorbell

b10178ee7fa8 scsi: ufs: Clean up completed request without interrupt
notification

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
