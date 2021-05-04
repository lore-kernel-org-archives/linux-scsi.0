Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E2CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3ED7613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEDM6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 08:58:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:39766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhEDM6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 08:58:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 17576AF21;
        Tue,  4 May 2021 12:57:27 +0000 (UTC)
Subject: Re: [PATCH 05/18] scsi: use real inquiry data when initialising
 devices
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-6-hare@suse.de> <20210504095551.GD25986@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <20e31039-e1af-5d47-bfd6-e24b70b1b4fd@suse.de>
Date:   Tue, 4 May 2021 14:57:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210504095551.GD25986@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 11:55 AM, Christoph Hellwig wrote:
> On Mon, May 03, 2021 at 05:03:20PM +0200, Hannes Reinecke wrote:
>> Use dummy inquiry data when initialising devices and not just
>> some 'nullnullnull' string.
> 
> Why?
> 
Because it's really weird if you start up scsi_debug with thousands of 
devices and then call 'lsscsi' repeatedly. That will print out several
devices with 'nullnullnull', only to be replaced with the 'real' inquiry 
data during device discovery.
I'd rather have a valid inquiry right from the start.

>> +/*
>> + * Dummy inquiry for virtual LUNs:
>> + *
>> + * standard INQUIRY: [qualifier indicates no connected LU]
>> + *  PQual=1  Device_type=31  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
>> + *  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>> + *  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
>> + *  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>> + *  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
>> + *    length=36 (0x24)   Peripheral device type: no physical device on this lu
>> + * Vendor identification: LINUX
>> + * Product identification: VIRTUALLUN
>> + * Product revision level: 1.0
>> + */
> 
> You don't juse set this up for virtual Luns, but as a default for all
> scsi_devices before calling inquirty.  I'd much helper with a helper
> to fill out fake inquiry data rather than having seemingly valid data
> for all devices before inquirty is called or if it fails.
> 
Right. Will be doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
