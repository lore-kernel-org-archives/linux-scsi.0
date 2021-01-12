Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EC0C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 18:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFC120639
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 18:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405395AbhALSjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 13:39:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbhALSjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 13:39:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CIDWKk139880;
        Tue, 12 Jan 2021 18:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8KxyImXKDVv3i4kRA62ts8srdgqwl4yl8Hqk9cIzWw0=;
 b=V3DpagR4gri/p+U59UIkZUgcRBbCkx2Qgu0Fb+WpXHWV1V23Spy44fkismyWs5+9xG+z
 xSI1g/irj96UYi0U/0tnalGYxci8thh3KVDoD6PyuAL+dkqNuJjQ4XX9Bn7gzEqHg/TZ
 FxwfYiCt2TpKjerQLiAFr+zfCyGKgd1VhiSoJfc/p9mfcbIVC0ZSk+FZKUXgrdtm9S9P
 PqshMtRkxaCsPB+opMf2ciWrEBWBY0V/r4xlex1ls5/U+QEUfjXmkdBNh4g5DIkVJIa4
 XyqeC84ZG7qAl2SKL3fT7dKJh6zbugnecMXlS25UoCuANYGg16Ey6E4TQM+6e0Fm7UPa 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1quqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:38:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CIG28w140849;
        Tue, 12 Jan 2021 18:36:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 360key7acq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:36:25 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CIaPAs032717;
        Tue, 12 Jan 2021 18:36:25 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 10:36:25 -0800
Subject: Re: [PATCH] scsi: target: tcmu: Fix wrong uio handling causing big
 memory leak
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20201218141534.9918-1-bostroesser@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <73dc2d01-6398-c1d1-df47-66034d184eec@oracle.com>
Date:   Tue, 12 Jan 2021 12:36:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218141534.9918-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/18/20 8:15 AM, Bodo Stroesser wrote:
> tcmu calls uio_unregister_device from tcmu_destroy_device.
> After that uio will never call tcmu_release for this device.
> If userspace still had the uio device open and / or mmap'ed
> during uio_unregister_device, tcmu_release will not be called and
> udev->kref will never go down to 0.
> 

I didn't get why the release function is not called if you call
uio_unregister_device while a device is open. Does the device_destroy call in
uio_unregister_device completely free the device or does it set some bits so
uio_release is not called later?

Do other drivers hit this? Should uio have refcounting so uio_release is called
when the last ref (from userspace open/close/mmap calls and from the kernel by
drivers like target_core_user) is done?
