Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EE2C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF3A2465E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kETNllEz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLSXtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:49:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLSXtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:49:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnBLX086593;
        Thu, 19 Dec 2019 23:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=PbxV0o+ZcW89DuRYoVd/6lmNOxjFjB6PlSy0cOYFy3I=;
 b=kETNllEzOOesxBGYTraO+e9Jg11OClcX/mav/qCOK5sq4CEqh9M8YbvpD+HKUJx4RDli
 VO1/rbk9GGvOy5AczbwTZUN6h7GhrfUHgcdt3kpzvvrIVG+JtCcFkS5Qj7RFIiIJTOAJ
 SxYX08tXrr4Rs1r4IShSgW+ju8zgiwA1Qvv1aZCoIAcAzxOrhuHKRzi+yy8B1sIjHOjI
 n2sf60Wct1NXhqvOMJJBoQcIEDVI2mZavBKHy3OmEpywgvHadTcG9lBRNGPMlhW/uomX
 Z0vw7a+QR+7ojxLbFEJBrbe3/QHUqzy5gNJvPHwsmaTSfLseXlduSn0ZIsqJcBaGYCnL +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x0ag12wmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:49:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnVQq013913;
        Thu, 19 Dec 2019 23:49:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x04ms8cuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:49:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJNmrOd010906;
        Thu, 19 Dec 2019 23:48:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:48:53 -0800
To:     Varun Prakash <varun@chelsio.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        dt@chelsio.com, ganji.aravind@chelsio.com
Subject: Re: [PATCH] scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1576676731-3068-1-git-send-email-varun@chelsio.com>
Date:   Thu, 19 Dec 2019 18:48:51 -0500
In-Reply-To: <1576676731-3068-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 18 Dec 2019 19:15:31 +0530")
Message-ID: <yq1v9qbanbw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=821
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=900 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Varun,

> If cxgb4i_ddp_init() fails then cdev->cdev2ppm will be NULL,
> so add a check for NULL pointer before dereferencing it.

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
