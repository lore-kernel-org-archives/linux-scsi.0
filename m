From: "Lance Gropper" <lance.gropper@qosserver.com>
Subject: Re[2]: [PATCH 1/2] target: Don't arbitrary limit I/O size to
 fabric_max_sectors
Date: Wed, 07 Jan 2015 16:21:12 +0000
Message-ID: <embc6e53bf-ecfc-4c20-b933-9917efa28e4d@ngon>
References: <1420647107.12144.8.camel@haakon3.risingtidesystems.com>
Reply-To: "Lance Gropper" <lance.gropper@qosserver.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53330 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbAGQVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 11:21:20 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so3833227obc.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2015 08:21:19 -0800 (PST)
In-Reply-To: <1420647107.12144.8.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hello Nicholas:

My vote is for 1MB. This is because it offers plenty of headroom for an 
OS/X-based client (which I think have defaults around 32KB), and is the 
default for many Linux and Windows distributions. 8MB is great, but it 
doesn't track back to anything in my industry - the next limit above 1MB 
would be about 55MB, the next above that would be 4 times that. But the 
initiator should be able to break the I/O down to smaller I/Os for the 
target.

Lance

------ Original Message ------
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: "target-devel" <target-devel@vger.kernel.org>; "linux-scsi" 
<linux-scsi@vger.kernel.org>; "Christoph Hellwig" <hch@lst.de>; "Roland 
Dreier" <roland@purestorage.com>; "Martin K. Petersen" 
<martin.petersen@oracle.com>
Sent: 1/7/2015 8:11:47 AM
Subject: Re: [PATCH 1/2] target: Don't arbitrary limit I/O size to 
fabric_max_sectors

>Hey Christoph,
>
>Adding CC' for MKP.
>
>On Wed, 2015-01-07 at 00:24 +0000, Nicholas A. Bellinger wrote:
>>  From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>>  This patch avoids the arbitrary limiting of I/O size to 
>>fabric_max_sectors,
>>  which currently has a hardcoded max of 8192 (4 MB for 512 byte sector
>>  devices).
>>
>>  This is problematic because Linux initiators have only recently 
>>started
>>  to honor block limits MAXIMUM TRANSFER LENGTH, and other non-Linux 
>>based
>>  initiators (eg: Fibre Channel) can also generate I/Os larger than 4 
>>MB.
>>
>>  Currently when this happens, the following message will appear on the
>>  target resulting in I/Os being returned with non recoverable status:
>>
>>    SCSI OP 28h with too big sectors 16384 exceeds fabric_max_sectors: 
>>8192
>>
>>  Instead, use the existing hw_max_sectors value to determine the 
>>maximum
>>  sized I/O the backend is capable of supporting. Also, change IBLOCK
>>  backend driver to set hw_max_sectors based on queue_max_hw_sectors(),
>>  instead of UINT_MAX.
>>
>>  Reported-by: Lance Gropper <lance.gropper@qosserver.com>
>>  Reported-by: Stefan Priebe <s.priebe@profihost.ag>
>>  Cc: Christoph Hellwig <hch@lst.de>
>>  Cc: Roland Dreier <roland@purestorage.com>
>>  Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>>  ---
>>   drivers/target/target_core_device.c | 8 ++++----
>>   drivers/target/target_core_iblock.c | 2 +-
>>   drivers/target/target_core_sbc.c | 7 -------
>>   drivers/target/target_core_spc.c | 5 +----
>>   4 files changed, 6 insertions(+), 16 deletions(-)
>>
>
><SNIP>
>
>>  diff --git a/drivers/target/target_core_iblock.c 
>>b/drivers/target/target_core_iblock.c
>>  index 3efff94..5795cd8 100644
>>  --- a/drivers/target/target_core_iblock.c
>>  +++ b/drivers/target/target_core_iblock.c
>>  @@ -124,7 +124,7 @@ static int iblock_configure_device(struct 
>>se_device *dev)
>>    q = bdev_get_queue(bd);
>>
>>    dev->dev_attrib.hw_block_size = bdev_logical_block_size(bd);
>>  - dev->dev_attrib.hw_max_sectors = UINT_MAX;
>>  + dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
>>    dev->dev_attrib.hw_queue_depth = q->nr_requests;
>>
>>    /*
>
>After thinking about this a bit more, I'm starting to have second
>thoughts about using queue_max_hw_sectors() to set hw_max_sectors for
>IBLOCK.
>
>IIRC, most modern hardware is reporting a large enough value for
>queue_max_hw_sectors() to support 8 MB I/Os, but I'm thinking that this
>could end up being problematic for older hardware that is reporting 
>much
>smaller values.
>
>Is there any reason why the underlying queue_max_hw_sectors() is going
>to trigger an -EIO failure in generic_make_request_checks() when a
>IBLOCK dispatched bio exceeds the reported size..?
>
>What are your thoughts for a sane default here..?
>
>--nab
>
>--
>To unsubscribe from this list: send the line "unsubscribe target-devel" 
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at http://vger.kernel.org/majordomo-info.html

