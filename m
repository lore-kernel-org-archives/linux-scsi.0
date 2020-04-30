Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42B6C83009
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824AB2083B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uVdvH7xc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgD3CSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 22:18:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbgD3CSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 22:18:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2CtXT122330;
        Thu, 30 Apr 2020 02:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=fPwXYJHHR+W1NjWv4Qp1lUFGK+tT0/YvyWBS49A3w8A=;
 b=uVdvH7xc8nB8GW0v2enQ3JuDJtigWeUCf/UjIS+k91HHUYsUx6ib/bNO3ynKXHa99ll2
 comg/inARD5QvgyWcYAcCW6sLP0+t5c1chcOqQ2ODTpnWVRsYXr4RndVgWmMZSJMa9OA
 GpOng7ISeYTcaGbU7cJ5EDSMCIzTgl3Vw7qnN5uhDp10Ws3xrKyrzvBc42zPeRCuHUPs
 WuGftXL+GJiqt5biCsa0p42DmW5PMX5aUUKtmLv6UjsUvuhmnd6BLlz9r+mOBZPPFH4x
 DXHsNytxN+R3kT2UReSsTzFUk1wxy4NK9hvNd4FuIXN2chaQku04jiWONKoXx/htM0Jp Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg8wnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2Gl4X141087;
        Thu, 30 Apr 2020 02:18:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxpmf47e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U2I99r008462;
        Thu, 30 Apr 2020 02:18:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 19:18:09 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: dpt_i2o: Remove always false 'chan < 0' statement
Date:   Wed, 29 Apr 2020 22:18:04 -0400
Message-Id: <158821297687.28621.4212963275967150101.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588162218-61757-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1588162218-61757-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=788 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=859 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Apr 2020 20:10:18 +0800, Xiongfeng Wang wrote:

> The channel index is represented by an unsigned variable 'u32 chan'. We
> don't need to check whether it is less than zero. The following
> statement is always false and let's remove it.
> 	'chan < 0'

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: dpt_i2o: Remove always false 'chan < 0' statement
      https://git.kernel.org/mkp/scsi/c/6f41f08c88c5

-- 
Martin K. Petersen	Oracle Linux Engineering
