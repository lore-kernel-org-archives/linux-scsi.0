Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB264C32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1B712075C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:39:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NCQIyy3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfJACi5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:38:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfJACi4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 22:38:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912XjDK107669;
        Tue, 1 Oct 2019 02:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=UwCWSrCtfyji+mVQNM/WEgCjcZifhFl3CxAbjP/XvOM=;
 b=NCQIyy3mvNtcGryfYrMzK2GY22kfBxdsuq+rghWTke2pvOV0mSbptyFK/dGIZQY85PMm
 wLpFptrTrqJ64OjqePIgibt3Zkxc+Y6/g/pEVrPWNq+fXIstzl/T2hnVQ8zXlnf0tJwB
 K/j5qcYiZC10QJs1b0YkZTtgzEowKy2lW+GMSvx6lmH5BThFxbXA3rtG0O7HNNMn8/d7
 FHCMwtDtVEtHu841UFFZ3pvucdfvWReZ4EPdma7CCiwVwWFp+SN9+fwsZ9Rlwb1HDj5J
 uwjcxiOn5OVyT9Wwkv7TXbQ0Tb6EE/7CSGgWusm8hUI1QUzL4khTYSxr/qRJpc+ZhQl8 aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rjrj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:38:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912chXM081718;
        Tue, 1 Oct 2019 02:38:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqd011sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:38:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x912cV85022401;
        Tue, 1 Oct 2019 02:38:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 19:38:31 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Murthy Bhat <Murthy.Bhat@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] scsi: smartpqi: remove set but not used variable 'ctrl_info'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190831130348.20552-1-yuehaibing@huawei.com>
Date:   Mon, 30 Sep 2019 22:38:28 -0400
In-Reply-To: <20190831130348.20552-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Sat, 31 Aug 2019 13:03:48 +0000")
Message-ID: <yq1muelyyu3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=955
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/smartpqi/smartpqi_init.c: In function 'pqi_driver_version_show':
> drivers/scsi/smartpqi/smartpqi_init.c:6164:24: warning:
>  variable 'ctrl_info' set but not used [-Wunused-but-set-variable]

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
