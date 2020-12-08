Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0724C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2342080C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgLHFPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 00:15:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLHFPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 00:15:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B855Mpw093033;
        Tue, 8 Dec 2020 05:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=RJynadRoF9lbcZoAF6x5sdOliEixJ3isAzY2rVKyzBg=;
 b=fBFYV5pEwyLtjBSoql5HxhH4IPrMMbFeUvpVSv6224rlQbnCGinRlUR98LqN6PykrzEk
 T7If9hpBcRfPIg4oxNdTqz4026se2nORCq9eqUiIrfzEzowvrqMq5gUoQKVlNw9jOGVT
 bQquveEJmimSVmSUepGGd4GV2nH5EogEy/xUtuyKmLwmBNlLAH5uewyn5+Nslw0brEI9
 2licIr+6KuTNpRKMOP09avTYhJJYGdIyYifsT5BRFtUFvJww3/C4iI8M+GlQB2MQqSd/
 6uKzDGThGyt4aAzI52iViTvceilYFqf0HVstZgP/jFYL7zItsfK+BfqtJBNylR3jSgaP wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m0ua2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 05:14:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B854SuG002330;
        Tue, 8 Dec 2020 05:14:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m3x843b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 05:14:58 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B85EuUp014331;
        Tue, 8 Dec 2020 05:14:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 21:14:56 -0800
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Hannes Reinecke <hare@suse.de>, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v7 0/5] scsi: Support to handle Intermittent errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfe8yjcd.fsf@ca-mkp.ca.oracle.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
        <962c402e28d9183caef263f9fac215b3@mail.gmail.com>
Date:   Tue, 08 Dec 2020 00:14:54 -0500
In-Reply-To: <962c402e28d9183caef263f9fac215b3@mail.gmail.com> (Muneendra
        Kumar M.'s message of "Tue, 8 Dec 2020 10:30:21 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=865
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=892 clxscore=1011 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Muneendra,

> Could you please let us know if the patch series can get committed to
> the scsi tree .  This patch series has been reviewed by Hannes,Ewan
> and Himanshu.

Core SCSI changes need to land in the early -rc releases so your series
will be a candidate for 5.12. Please rebase on top of 5.11-rc1 when that
is out in a couple of weeks.

-- 
Martin K. Petersen	Oracle Linux Engineering
