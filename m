Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B470FC4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7309C207C3
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LDInZQGB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgJHC0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:26:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbgJHC0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:26:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982OC2m077039;
        Thu, 8 Oct 2020 02:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=wnU28EFcIbJxso0n42g+3vGsqoAySFtYcnwF10mFpMA=;
 b=LDInZQGBzYPw0PkdFGTNkcu/fke6qda5Vs9FNy5bhXBvQyvA8b+d8gZZdz0rooWL8wi7
 Gm4EdIfaCwTPJ136W93WII+j4AysXRe0mt226/lXdzRunDQPKYYtSWHHaqDGOlA7/XE9
 3LpSxCRai175FG8yqt0BNibihxd8RLHOA7y71xncQRrDnKpM5+M4CjRZoX2WwwFu2OG4
 mN2r8UehDE2/0Kw/3ChcgFxd7YcWt9tG6zvjsWZ/FH9enlZAXigTyLgf/6M7muPAAwLs
 SXzhEIMLc7FGST3akZ9s+A2ZEdyCnUY6F7xqd2dWlVBl+i+D22vFo4MlWQ34lnHXcBLe Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34t8up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:26:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982LDtq090313;
        Thu, 8 Oct 2020 02:24:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33yyjj0k5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:24:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0982ONpt025197;
        Thu, 8 Oct 2020 02:24:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:24:22 -0700
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17ds1zc8y.fsf@ca-mkp.ca.oracle.com>
References: <20200919025202.17531-1-miaoqinglang@huawei.com>
        <68C6E741-9A58-4E4E-B746-4E810EA7D651@oracle.com>
Date:   Wed, 07 Oct 2020 22:24:20 -0400
In-Reply-To: <68C6E741-9A58-4E4E-B746-4E810EA7D651@oracle.com> (Himanshu
        Madhani's message of "Wed, 7 Oct 2020 08:35:42 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
