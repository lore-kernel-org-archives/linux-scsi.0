Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6C2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 15:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2A864DE8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 15:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhBJPpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:45:16 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2532 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhBJPpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 10:45:15 -0500
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DbP9c2h96z67mpT;
        Wed, 10 Feb 2021 23:40:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Feb 2021 16:44:33 +0100
Received: from [10.210.168.117] (10.210.168.117) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Feb 2021 15:44:31 +0000
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
To:     <Don.Brace@microchip.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <buczek@molgen.mpg.de>, <gregkh@linuxfoundation.org>,
        <ming.lei@redhat.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
 <SN6PR11MB2848ECDD666F0BF867AE04DFE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6fea70bb-1718-ad02-789b-8e908f57951e@huawei.com>
Date:   Wed, 10 Feb 2021 15:42:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848ECDD666F0BF867AE04DFE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.117]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2021 15:27, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: John Garry [mailto:john.garry@huawei.com]
> Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
> 
> 
> I think that this can alternatively be solved by setting .host_tagset flag.
> 
> Thanks,
> John
> 
> Don: John, can I add a Suggested-by tag for you for my new patch smartpqi-use-host-wide-tagspace?

I don't mind. And I think that Ming had the same idea.

Thanks,
John
