Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B7BC4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B8A7206FA
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:15:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IC3RiVMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJCBPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:15:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJCBPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:15:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931F98j019268;
        Sat, 3 Oct 2020 01:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=abE86DuzVPBoYXarI72XFmF5L0gOwK3lw7dIMJvC8k8=;
 b=IC3RiVMn+vJnSox7VKbbaXmukqRGZ0L7q5x64UFuNdBWXEGGv6B/4H6nTs13o2h2RbLW
 M/vPtMTETtK7dVlUnu0bclX99VDYuZEC2KDn/OMua1NjcehdnJN+idEvhxHYmpBrlbXG
 x74/Vi/dT9TEEc+sX73+ZfnW/WkkCWLhOFfDmnrBdlZmpxluZER2Pydp1if+UH6VOBOy
 GWjPoNYmk/xnXqduCVW0xLi8TXlkDzu615RY/9sB9kFHeRiQ9Y47klC3RaybntyDoYzy
 1Hqb3FpEfViZhmz38YlCJZmAmMTRzRorxQL/3kzXwF7WN2eciHy4uckPN7nBqlYVQXUx /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetag1td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:15:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931F1iU167551;
        Sat, 3 Oct 2020 01:15:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33xfb8g3f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:15:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0931F49K023571;
        Sat, 3 Oct 2020 01:15:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:15:04 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <kartilak@cisco.com>, <sebaddel@cisco.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: snic: Remove unnecessary condition to simplify
 the code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18scodsa8.fsf@ca-mkp.ca.oracle.com>
References: <20200925060754.156599-1-jingxiangfeng@huawei.com>
Date:   Fri, 02 Oct 2020 21:15:02 -0400
In-Reply-To: <20200925060754.156599-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Fri, 25 Sep 2020 14:07:54 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> ret is always zero or an error in this code path. So the assignment to
> ret is redundant, and the code jumping to a label is unneed.
> Let's remove them to simplify the code. No functional changes.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
