Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B37C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 14:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A37420888
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 14:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732479AbhALOoJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 09:44:09 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2319 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbhALOoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 09:44:09 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFY8s5wMRz67TgM;
        Tue, 12 Jan 2021 22:38:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 15:43:27 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 14:43:26 +0000
Subject: Re: [PATCH v2 16/19] scsi: libsas: Switch back to original event
 notifiers API
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, <intel-linux-scu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-17-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <522737ea-ed28-72c0-b0b5-316e1ee9c404@huawei.com>
Date:   Tue, 12 Jan 2021 14:42:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210112110647.627783-17-a.darwish@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.61]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/01/2021 11:06, Ahmed S. Darwish wrote:
>   		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
>   				port_phy_el);
> -		sas_notify_port_event_gfp(sas_phy,
> +		sas_notify_port_event(sas_phy,
>   				PORTE_BROADCAST_RCVD, GFP_KERNEL);

nit: I think that this now fits on a single line, without exceeding 80 
characters

Thanks,
John
