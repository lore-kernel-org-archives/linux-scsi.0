Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB62C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 12:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BABD20684
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 12:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aImeZQdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgIDMq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 08:46:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgIDMqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 08:46:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084Chih1114038;
        Fri, 4 Sep 2020 12:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9vGfymTnmHsk7TPLlnrlRO7Y1Sia4j3BTe+tJcTEs1w=;
 b=aImeZQdCiswCqrKsQJCpBHhiyBIE5/Y/PiACu6re7yNHGKK7h1V4/wJdrG+d2EdvcoUJ
 fyCLzc/uWLL5K2wOw+97Ui8b4g09tDEe7XaCGB6XyFI7Fv0dC5b2oyK75YdfdI0VYYlq
 J/zSL3nuoSK0u96cjLXh0vyoDKkv1H8c+UO9yn9jIgPbZuI7eiA5Rrz/GddyGZtnbloX
 lVQwgJ8U8j23ygK+mq6XNYU8Zuf41x3D+3DZ2ZTGJjBJlGpbj55cdst4bT6UFjDn2veO
 p438zznOsMxVf+8sm3M4IL6AS+RGBEubLP9keDkc6ZVQeZstiEfXLx7JJ8b5pFemylMf SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 339dmncqdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Sep 2020 12:44:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084Cdpko183302;
        Fri, 4 Sep 2020 12:44:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33b7v2jaqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Sep 2020 12:44:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 084Cih2X020576;
        Fri, 4 Sep 2020 12:44:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 05:44:43 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>,
        <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
        <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
        <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
Date:   Fri, 04 Sep 2020 08:44:39 -0400
In-Reply-To: <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com> (John Garry's
        message of "Fri, 4 Sep 2020 10:09:27 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=887 phishscore=0 bulkscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=899 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040115
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Martin/James may want more review of the SCSI core bits, though.

I'll take a look later today.

-- 
Martin K. Petersen	Oracle Linux Engineering
