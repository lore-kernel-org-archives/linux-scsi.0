Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387DAC35247
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D1A21744
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BYwAMglq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBECaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 21:30:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgBECaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 21:30:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0152O7Kn194564;
        Wed, 5 Feb 2020 02:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Zg0+DiwI/K8/E+WQiW0JH09laZKD8erQQWdHWq52yFM=;
 b=BYwAMglqvTSNmTV4K9POC+0F49mrfGG8uo8WdQb4tzi3Npk5NQjSuWI7q3HE1y2KQPX0
 6a5urVogIHmhvy1g6eKXtWCnFkoorkHQMS683MwCYedH4Dw5Cg8Mlyb1LM/tev5hbUWI
 aaeumizI5aCinFoaTty9BL3WBLG45tUPLNhDfCl0+FWxzZ1Sk9Blm56I+/vvpRjM/EDh
 wwjzSMy++ED6nJcHmdV31h11RZ3qndkjfvXoBuV9fO+pmCV5gMof6wlFimwEGd1SXFHO
 7cNV/fPM2/4B5Gjj3TpfOWyoZaxdBvfjcAOdbDolGc59HK2pRnX589PSaxB0WEjC7hRh 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xykbp09kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 02:30:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0152OFK3188262;
        Wed, 5 Feb 2020 02:30:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xykbqnh2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 02:30:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0152U5YX025424;
        Wed, 5 Feb 2020 02:30:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 18:30:04 -0800
To:     AlexChen <alex.chen@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <zhengchuan@huawei.com>,
        <jiangyiwen@huawei.com>, <robin.yb@huawei.com>
Subject: Re: [PATCH V2] scsi: add a new flag to set whether SCSI disks support WRITE_SAME_16 by default
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <5E28118F.3070706@huawei.com> <5E3520A7.5030501@huawei.com>
Date:   Tue, 04 Feb 2020 21:30:02 -0500
In-Reply-To: <5E3520A7.5030501@huawei.com> (AlexChen's message of "Sat, 1 Feb
        2020 14:54:31 +0800")
Message-ID: <yq14kw522c5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Alex,

> When the SCSI device is initialized, check whether it supports
> WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If the
> back-end storage device does not support queries, it will not set
> sdkp->ws16 as 1.

Your proposed code change is fine and to the point. However, I'd like to
understand why you are adding a workaround to the kernel instead of
fixing the affected device?

Implementing support for either WRITE SAME(10) or REPORT SUPPORTED
OPERATION CODES is easy. And the latter in particular is beneficial for
discovering several other SCSI protocol features. It's a good command to
support in general.

Also, we generally don't add features to the kernel without any
users. So if you add a blacklist flag, I would expect to see a set of
device strings to be added to scsi_devinfo.c.

-- 
Martin K. Petersen	Oracle Linux Engineering
