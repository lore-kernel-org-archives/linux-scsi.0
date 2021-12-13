Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902CCC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 11:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhLMLCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 06:02:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4258 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhLMLCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 06:02:52 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJQZ3fP7z67w69;
        Mon, 13 Dec 2021 18:58:30 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 12:02:50 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 11:02:50 +0000
Subject: Re: [PATCH 07/15] scsi: libsas: Send event PORTE_BROADCAST_RCVD for
 valid ports
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-8-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <39179771-6422-ff6c-deed-27b204081e28@huawei.com>
Date:   Mon, 13 Dec 2021 11:02:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-8-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.94]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please consider these points:

About "Send event PORTE_BROADCAST_RCVD for valid ports":

Maybe say "Insert PORTE_BROADCAST_RCVD event for resuming host", as 
"valid ports" is a little vague. And the point is that we can to rescan 
when we resume.

On 17/11/2021 02:45, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> If inserting a new disk for expander, the disk will not be revalidated
> as the topology is not re-scanned during the resume process. So send event
> PORTE_BROADCAST_RCVD to identify some new inserted disks for expander.

If a new disk is inserted through an expander when the host was 
suspended, they will not necessarily be detected as the topology is not 
re-scanned during resume.

To detect possible changes in topology during suspension, insert a 
PORTE_BROADCAST_RCVD event per port when resuming to trigger a revalidation.

> 
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
> Reviewed-by: John Garry<john.garry@huawei.com>

