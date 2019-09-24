Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FF2C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD3C207FD
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:56:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Etgj28s7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408836AbfIXC4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 22:56:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbfIXC4J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 22:56:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2sIVv085396;
        Tue, 24 Sep 2019 02:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=9U0z7wjO/IANLnpW2hcA4XZeE1R7he1kF5tqOrISwuo=;
 b=Etgj28s77nxnuu1NdXe+Zk3jYHtnF+JqSH8sb1gd3pW2mJ7NXNgr1ect8b4sWfvsR1Wt
 CwoGvWAZ3ROtPyjlnGHaOBTo4FoEfR5aB4vWR+QDYcHX57cMtSdY9uE30Sc2kAbK91r/
 feGF9aHldzV29Dj3P0SFKkQiVn0eBayzxlaO47FHoX535a5ckDoHYTc6iaFaGmfBsvUZ
 FcQiOnx5LxtLOy1DZvVD0XSdfSbIEyHNFdnhQzTODO0rIXowlJGEImbUNZlcVkZ1L/NF
 ifYJvu7ImKqd5INN/lhrkER06kCOStkueqhXPQnDTlk3q6UWGlV/s7NJpwOoBCfjTfY2 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btptyen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:55:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2sm7L173944;
        Tue, 24 Sep 2019 02:55:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v6yvqpfqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:55:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8O2tsMV030235;
        Tue, 24 Sep 2019 02:55:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 19:55:54 -0700
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <martin.petersen@oracle.com>, <linuxarm@huawei.com>,
        <linux-scsi@vger.kernel.org>, <john.garry@huawei.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: [RESEND PATCH] scsi: megaraid: disable device when probe failed after enabled device
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Mon, 23 Sep 2019 22:55:52 -0400
In-Reply-To: <1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Sat, 7 Sep 2019 09:07:30 +0800")
Message-ID: <yq1ftkm4d3b.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=714
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=812 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> For pci device, need to disable device when probe failed after enabled
> device.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
