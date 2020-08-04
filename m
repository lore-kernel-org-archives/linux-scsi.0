Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FE8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11780206DA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgHDJPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:15:47 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2563 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbgHDJPr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Aug 2020 05:15:47 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2A6947843C89EC4EBBC9;
        Tue,  4 Aug 2020 10:15:45 +0100 (IST)
Received: from [127.0.0.1] (10.47.11.189) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 4 Aug 2020
 10:15:43 +0100
Subject: Re: [PATCH V6 2/2] pm80xx : Staggered spin up support.
To:     <Deepak.Ukey@microchip.com>, <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        "luojiaxing@huawei.com" <luojiaxing@huawei.com>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
 <20200804060235.GA28428@infradead.org>
 <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1d09bf1a-f555-b5de-a369-9797f96b2e9d@huawei.com>
Date:   Tue, 4 Aug 2020 10:13:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.11.189]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/08/2020 07:33, Deepak.Ukey@microchip.com wrote:
> Hi Christoph,
> 
> Yes, It is better to be implemented in libsas. Since the out of box pm80xx driver has this support, we would like to push this for the time being. We will see how this can be moved to libsas.
> 

Other libsas users may like this feature. And libsas does already 
support SATA spin-up hold events - as does pm8001 - but there's not 
really much to that in libsas.

Question: why have a module param to enable this feature? Why not solely 
rely on the seeprom spin-up interval, whereby a value of 0 means no 
staggered spin-up?

thanks

> Regards,
> Deepak
> 
> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, August 4, 2020 11:33 AM
> To: Deepak Ukey - I31172 <Deepak.Ukey@microchip.com>
> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664 <Vasanthalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667 <Viswas.G@microchip.com>; jinpu.wang@profitbricks.com; martin.petersen@oracle.com; yuuzheng@google.com; auradkar@google.com; vishakhavc@google.com; bjashnani@google.com; radha@google.com; akshatzen@google.com
> Subject: Re: [PATCH V6 2/2] pm80xx : Staggered spin up support.
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> As mentioned before - this should be a libsas or transport class policy, and not a module parameter hack in one driver.
> .
> 

