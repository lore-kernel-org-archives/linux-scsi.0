Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5A1C6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 23:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbjHXXx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjHXXxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 19:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634ED19BE;
        Thu, 24 Aug 2023 16:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83F56489F;
        Thu, 24 Aug 2023 23:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D07C433C7;
        Thu, 24 Aug 2023 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692921185;
        bh=3bs3IPpdPfpkdufp55y+iXPOfspF5GeBZAESxD31aDw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KvtSqFqBJKbQyk9BxaCc+UAqJJtZSn7fKuJ/EWQowG7Vc9TnIWdAZnEjb5264Jot8
         m/JzehvoK4gDYwX3m+gvbz8p3pAzPrJ5zP/mpZ0muqyP/ofzcAAfxDPnkhBG5szwDB
         HimPC5lVDzta/vdLobSW5GVG1Aj5AO05Hd0BJJvC4BmKy4MaZlOWaBkx3C21EVS1wg
         PEYwJbYvLzsJoCJ1a9LktycG0iffjAjNG6Ff+DbXqkJt9WbohuS/YklTl2WIxRQVxh
         Hv0z481iTLva4rPguhi1KtFEDc9MOcs/hbOyhj49c7UeMFRvSvxtYp1Y/4Y7mxbeR1
         tYMPjv27QGnyg==
Message-ID: <5b94bd2d-78a0-b94b-621c-1732e2cce58c@kernel.org>
Date:   Fri, 25 Aug 2023 08:53:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
 <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
 <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
 <5c36ae01-a806-a36b-0196-41c217f78307@suse.de>
 <1e54cf7a-4e8f-4539-6677-d6bf0ec88ea5@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <1e54cf7a-4e8f-4539-6677-d6bf0ec88ea5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/25/23 01:52, Bart Van Assche wrote:
> On 8/24/23 09:44, Hannes Reinecke wrote:
>> On 8/24/23 16:47, Bart Van Assche wrote:
>>> Thanks for the feedback. I agree that it would be great to have zone 
>>> append
>>> support in F2FS. However, I do not agree that switching from regular 
>>> writes
>>> to zone append in F2FS would remove the need for sorting SCSI commands 
>>> by LBA in the SCSI error handler. Even if F2FS would submit zoned writes
>>> then the following mechanisms could still cause reordering of the zoned
>>> write after these have been translated into regular writes:
>>> * The SCSI protocol allows SCSI devices, including UFS devices, to 
>>> respond
>>> with a unit attention or the SCSI BUSY status at any time. If multiple 
>>> write commands are pending and some of the pending SCSI writes are not
>>> executed because of a unit attention or because of another reason, this
>>> causes command reordering.
>>
>> Yes. But the important thing to remember is that with 'zone append' the 
>> resulting LBA will be returned on completion, they will _not_ be 
>> specified in the submission. So any command reordering doesn't affect 
>> the zone append commands as they heven't been written yet.
>>
>>> * Although the link between the UFS controller and the UFS device is 
>>> pretty
>>> reliable, there is a non-zero chance that a SCSI command is lost. If this
>>> happens the SCSI timeout and error handlers are activated. This can cause
>>> reordering of write commands.
>>>
>> Again, reordering is not an issue with zone append. With zone append you 
>> specify in which zone the command should land, and upon completion the 
>> LBA where the data is written will be returned.
>>
>> So if there is an error the command has not been written, consequently 
>> there is no LBA to worry about, and you can reorder at will.
> 
> Hi Hannes,
> 
> I agree that reordering is not an issue for NVMe zone append commands.
> It is an issue however with SCSI devices because there is no zone append
> command in the SCSI command set. The sd_zbc.c code translates zone
> appends (REQ_OP_ZONE_APPEND) into regular WRITE commands. If these WRITE
> commands are reordered, the ZBC standard requires that these commands
> fail with an UNALIGNED WRITE error. So I think for SCSI devices what you
> wrote is wrong.

I think that Hannes point was that if you ensure that the rejected regular write
commands used to emulate zone append when requeued go through the sd driver
again when resubmitted, they will be changed again to emulate the original zone
append using the latest wp location, which is assumed correct. And that does not
depend on the ordering. So requeuing these regular writes does not need sorting.
It can be in any order. The constraint is of course that they must be re-preped
from the original REQ_OP_ZONE_APPEND every time they are requeued.

-- 
Damien Le Moal
Western Digital Research

