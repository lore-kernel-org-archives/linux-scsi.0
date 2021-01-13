Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11801C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB29C23343
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbhANCSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:18:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbhAMVE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 16:04:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10DL44TQ070614;
        Wed, 13 Jan 2021 21:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GJ7vjga36dfwoDDtErzjuJmGMnm3mXTdnriFHhqccJo=;
 b=xZblP0O94OAJW/MKDqJKYtMairWXPCLwbAPGyLxnVFTKXYWWQeoCuz7zkSy/6XZSHWz8
 D2NhjLUJO+GmPKmnBI2IgpZSXMx2tAOFkCy1sp/o+TTtzXsgaOQa0+EpL/IOQtFz9DYA
 b7ar80vRzkF7rdE0il6J2PQ8z4XO5oPXolVG6cjEIECTZWHlIltXxuVvh/DyAB6UHNvu
 8JrNmapVnKYdRoPQ+BpyJrnRt2/LBCFjgb0glYeVcdC0TeokOfO99uB/MVwTVIRWHRtv
 Eb6JtO79G0DgtAg7f68ZSY0LfZrHl7Q7IQlIaOCBf0lZHgP9yaQya0P6BUIrPSTTNF8n dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kcywhvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 21:04:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10DKtfo3018286;
        Wed, 13 Jan 2021 21:04:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 360ke91nyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 21:04:05 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10DL44Lq026541;
        Wed, 13 Jan 2021 21:04:04 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Jan 2021 13:04:04 -0800
Subject: Re: [PATCH] scsi: target: tcmu: Fix wrong uio handling causing big
 memory leak
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20201218141534.9918-1-bostroesser@gmail.com>
 <73dc2d01-6398-c1d1-df47-66034d184eec@oracle.com>
 <aa95b4db-ca88-e38c-3871-fb935f1e2212@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <3caa89ba-47b8-d85c-e7a5-54d84d1471f0@oracle.com>
Date:   Wed, 13 Jan 2021 15:04:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aa95b4db-ca88-e38c-3871-fb935f1e2212@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/21 11:59 AM, Bodo Stroesser wrote:
> On 12.01.21 19:36, Mike Christie wrote:
>> On 12/18/20 8:15 AM, Bodo Stroesser wrote:
>>> tcmu calls uio_unregister_device from tcmu_destroy_device.
>>> After that uio will never call tcmu_release for this device.
>>> If userspace still had the uio device open and / or mmap'ed
>>> during uio_unregister_device, tcmu_release will not be called and
>>> udev->kref will never go down to 0.
>>>
>>
>> I didn't get why the release function is not called if you call
>> uio_unregister_device while a device is open. Does the device_destroy call in
>> uio_unregister_device completely free the device or does it set some bits so
>> uio_release is not called later?
> 
> uio_unregister_device() resets the pointer (idev->info) to the struct uio_info which tcmu provided in uio_register_device().
> The uio device itself AFAICS is kept while it is open / mmap'ed.
> But no matter what userspace does, uio will not call tcmu's callbacks
> since info pointer now is NULL.
> 
> When userspace finally closes the uio device, uio_release is called, but
> tcmu_release can not be called.
> 
>>
>> Do other drivers hit this? Should uio have refcounting so uio_release is called
>> when the last ref (from userspace open/close/mmap calls and from the kernel by
>> drivers like target_core_user) is done?
>>
> 
> To be honest I don't know exactly.
> tcmu seems to be a special case in that is has it's own mmap callback.
> That allows us to map pages allocated by tcmu.
> As long as userspace still holds the mapping, we should not unmap those
> pages, because userspace then could get killed by SIGSEGV.
> So we have to wait for userspace closing uio before we may unmap and
> free the pages.


If we removed the clearing of idev->info in uio_unregister_device, and
then moved the idev->info->release call from uio_release to
uio_device_release it would work like you need right? The release callback
would always be called and called when userspace has dropped it's refs.
You need to also fix up the module refcount and some other bits because
it looks like uio uses the uio->info check to determine if the device is
being removed.

I don't know if that is the correct approach. It looks like non
target_core_user drivers could hit a similar issue. It seems like drivers
like qedi/bnx2i could hit the issue if their port is removed from the
kernel before their uio daemon closes the device. However, they also
could do a driver specific fix and handle the issue by adding some extra
kernel/userspace bits to sync the port removal.
