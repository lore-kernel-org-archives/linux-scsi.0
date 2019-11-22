Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A1DC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 01:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C50F82068F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 01:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EhbyVJD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKVBsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 20:48:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKVBsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 20:48:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM1iFCO128056;
        Fri, 22 Nov 2019 01:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SNgm4BbWhnsLzBcjJXaM8if4RgmU/BKYbkviXRJN6FA=;
 b=EhbyVJD29S1QcUxkvgTBPwhpFNNvDM6uhZUcBWGjxVBg39B3WlJ2SqjWTSV9YozawQ+u
 wvsGDhprVEd1gXWORWkk5XPRgO/NkvGWMrRxSzoRASoSePzEO6MuPKmBSPvNpN+Ewqme
 ma/oF8jioOHb+BzfDSvxOZ1O81C3cAcAKgCw8cVJzBv1pUoVD9GhhxcS0xieLWQx5p0E
 UUgNqDSXqWVOpAfKxt6cCkTooDN9FKVXT/4yv/kBujUcSwQMH+lRYVBunmLEC6GDUoPU
 mLz1EGunv28I8Wqn7IOxXUjsrjCywXFWv+DODr0F/ZrN2CAaYl13zxhmRT3CqWfKIC3c hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hu7vsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 01:48:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM1m2xr075618;
        Fri, 22 Nov 2019 01:48:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wd47y0eas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 01:48:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAM1mWvL018791;
        Fri, 22 Nov 2019 01:48:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 17:48:31 -0800
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        mikecyr@linux.ibm.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Remove unneeded variable rc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191101120407.GA9369@saurav>
        <25de88a9-b013-f5cc-06c2-3efb1f3f0001@gmail.com>
Date:   Thu, 21 Nov 2019 20:48:29 -0500
In-Reply-To: <25de88a9-b013-f5cc-06c2-3efb1f3f0001@gmail.com> (Tyrel
        Datwyler's message of "Wed, 20 Nov 2019 17:11:12 -0800")
Message-ID: <yq1blt4d6ky.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=957
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Variable rc is not modified in ibmvscsis_srp_i_logout function.  So
>> remove unneeded variable rc.
>> 
>> Issue found using coccicheck tool.
>> 
>> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
>
> Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>

Applied to 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
