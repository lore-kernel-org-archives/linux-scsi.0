Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285B2C678DC
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 00:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351210AbjHRAHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 20:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356615AbjHRAGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 20:06:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B85226AD
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 17:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF1562FEB
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 00:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D069C433C7;
        Fri, 18 Aug 2023 00:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692317183;
        bh=R3wBIAVRyPC6AMeIWj+pXZd+YsKbPdndJSy40BCuZZo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=snwpc9n8AnsU/3IUbpVjcZ0YQz4oyZkDRyXhuOrvO7nEKpnP9WI2wEZrofyIljyZs
         lJWQFuiAtfnR3KXT4DEGGbECllRLsI6PdkP5HDc6OZC5GAJWAFeEPbv98UjcYxTjhK
         Yv4lx4QyryyP4nNpjF6Uyyf/7fRkXNE9RAGagxTE/juTzX9XVYQJteEJQvzWVi5Sdc
         f0kUljF9ItBuy2b/NnOiQ/1LZmofwwwEEiWVAWRtSPNX9yG2Bdexrp5O+RazzswRgs
         x7WUbkaLJheU70bTTbIxZRGjczI/w7OX79x02ySwn6gVTlEspCNLxXBAjIL0Q0cpKm
         FaD9ui/XHM5DQ==
Message-ID: <153bb4c2-68fa-8e9e-3c34-6664f35b8ea8@kernel.org>
Date:   Fri, 18 Aug 2023 09:06:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com>
 <1a3f8cbb-9d2c-08c1-d1ea-4d9898eb0e23@kernel.org>
 <ZN6yO8Zcd6BXqKrX@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZN6yO8Zcd6BXqKrX@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/18 8:50, Niklas Cassel wrote:
> On Fri, Aug 18, 2023 at 08:12:02AM +0900, Damien Le Moal wrote:
>> On 2023/08/18 6:41, Igor Pylypiv wrote:
>>> For Command Duration Limits policy 0xD (command completes without
>>> an error) libata needs FIS in order to detect the ATA_SENSE bit and
>>> read the Sense Data for Successful NCQ Commands log (0Fh).
>>>
>>> Set return_fis_on_success for commands that have a CDL descriptor
>>> since any CDL descriptor can be configured with policy 0xD.
>>>
>>> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
>>> ---
>>>  drivers/scsi/libsas/sas_ata.c | 3 +++
>>>  include/scsi/libsas.h         | 1 +
>>>  2 files changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>>> index 77714a495cbb..da67c4f671b2 100644
>>> --- a/drivers/scsi/libsas/sas_ata.c
>>> +++ b/drivers/scsi/libsas/sas_ata.c
>>> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>>>  	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
>>>  	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
>>>  
>>> +	/* CDL policy 0xD requires FIS for successful (no error) completions */
>>> +	task->ata_task.return_fis_on_success = ata_qc_has_cdl(qc);
>>
>> From the comments on patch 1, this should be:
>>
>> 	if (qc->flags & ATA_QCFLAG_HAS_CDL)
>> 		task->ata_task.return_sdb_fis_on_success = 1;
>>
>> Note the renaming to "return_sdb_fis_on_success" to be clear about the FIS type.
> 
> I'm not sure if I agree with this comment.
> 
> According to the pm80xx programmers manual,
> setting the RETFIS bit enables the HBA to return a FIS for a successful
> command:
> 
> PIO Read: Nothing is returned
> PIO Write: Device To Host FIS received from the device.
> DMA Read: Device To Host FIS received from the device.
> DMA Write: Device To Host FIS received from the device.
> FPDMA Read: Set Device Bit FIS received from the device.
> FPDMA Write: Set Device Bit FIS received from the device.
> Non-Data: Device To Host FIS received from the device.
> 
> So the FIS you get back can also be e.g. a D2H FIS, if you send
> e.g. a DMA read command.

Right. Forgot about non NCQ commands :)
So no need for renaming to sdb_fis. Apologies for the noise.

> 
> If the RETFIS bit is not set, and the command was successful,
> no FIS will be returned.
> 
> So if you really want to rename this bit, then we would also need to
> change the logic in pm80xx to be something like:
> if (ata_is_ncq() && task->ata_task.return_sdb_fis_on_success)
> 	set_RETFIS_bit;
> 
> Doesn't it make more sense for this generic libsas flag to keep its
> current name, i.e. it means that we enable FIS reception for successful
> commands, regardless of FIS type?

Yes.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

