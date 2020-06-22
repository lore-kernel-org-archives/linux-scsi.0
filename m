Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73527C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9E220760
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgFVO0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:26:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:46458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgFVO03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 10:26:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBE19C1B5;
        Mon, 22 Jun 2020 14:26:26 +0000 (UTC)
Subject: Re: fix ATAPI support for libsas drivers
To:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>
Cc:     martin.petersen@oracle.com, brking@us.ibm.com,
        jinpu.wang@cloud.ionos.com, mpe@ellerman.id.au,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200615064624.37317-1-hch@lst.de>
 <d3459f71-501e-3fea-d5dc-a5599758459d@huawei.com>
 <20200618152848.GA30919@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bed58e53-2019-cbb6-2ebe-93d0e404c90a@suse.de>
Date:   Mon, 22 Jun 2020 08:28:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618152848.GA30919@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/20 5:28 PM, Christoph Hellwig wrote:
> On Thu, Jun 18, 2020 at 10:02:58AM +0100, John Garry wrote:
>> On 15/06/2020 07:46, Christoph Hellwig wrote:
>>> Hi all,
>>>
>>> this series fixes the ATAPI DMA drain refactoring for SAS HBAs that
>>> use libsas.
>>> .
>>>
>>
>> Something I meant to ask before and was curious about, specifically since
>> ipr doesn't actually use libsas: Why not wire up other SAS HBAs, like
>> megaraid_sas?
> 
> megaraid_sas and mpt3sas don't use the libata code at all.  ipr actually
> is a special case and uses libata directly instead of libsas (something
> I hadn't realized, but which doesn't change anything for the patches
> itself, just possibly the commit log).
> 
More to the point, megaraid_sas and mpt3sas have their own SATL in 
firmware so there is no need to use libata here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
