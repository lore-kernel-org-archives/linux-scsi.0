From: Jens Axboe <axboe@kernel.dk>
Subject: Re: SCSI regression in 4.11
Date: Mon, 27 Feb 2017 19:16:49 -0700
Message-ID: <a7e5d98b-474a-04bc-e09d-2c2f29f77382@kernel.dk>
References: <20170227152955.1362aabb@xeon-e3>
 <20170227171931.30b9f619@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36514 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdB1CRJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 21:17:09 -0500
Received: by mail-pf0-f182.google.com with SMTP id x66so842824pfb.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 18:16:56 -0800 (PST)
In-Reply-To: <20170227171931.30b9f619@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com
Cc: linux-scsi@vger.kernel.org

On 02/27/2017 06:19 PM, Stephen Hemminger wrote:
> On Mon, 27 Feb 2017 15:30:30 -0800
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
>> Something in SCSI in 4.11 broke booting on Hyper-V Generation 2 VM with 8 VCPU and 4G of memory.
>> Both Linus's current tree (4.11 pre-rc1) and linux-next fail in a similar manner. It looks like some error
>> in SCSI device detection because there is only a single device.
>>
>> The offending commit causing the regression is:
>>
>> $ git bisect bad
>> e9c787e65c0c36529745be47d490d998b4b6e589 is the first bad commit
>> commit e9c787e65c0c36529745be47d490d998b4b6e589
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Mon Jan 2 21:55:26 2017 +0300
>>
>>     scsi: allocate scsi_cmnd structures as part of struct request
>>     
>>     Rely on the new block layer functionality to allocate additional driver
>>     specific data behind struct request instead of implementing it in SCSI
>>     itѕelf.
>>     
>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>>     Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>>     Reviewed-by: Hannes Reinecke <hare@suse.com>
>>     Signed-off-by: Jens Axboe <axboe@fb.com>
>>
>> :040000 040000 6ff016fcdae227efeb19c1c301b17ccd7ea35da6 70d79f99d9b79ecf4dccbe067fc697219f5c78da M	drivers
>> :040000 040000 a672ff52df8b2c211b3f98cae4a88d8a96ccde0b 1aaaed7de0994f597c7f8290c722a0b4a7789429 M	include
>>
>> I checked and tree is current and up to date and includes 
>> commit ee5242360424b9b967454e9183767323d10cf985
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Tue Feb 21 10:04:55 2017 +0100
>>
>>     scsi: zero per-cmd driver data before each I/O
>>
>> Kernel config is attached. It started with Ubuntu config, but then did localmodconfig and pruned
>> out unnecessary stuff.
>>
> 
> This problem I am seeing looks like the one addressed by:
> 
> Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each I/O")
> 
> but that is already in linux-next.
> 
> Noticed another place where memset(of the data was being done not the extra bits.
> Tried this, but didn't fix it either...

Yeah, that fix is already in Linus's tree. But it does look like a replica of
what Dexuan reported. Out of curiosity, does it boot if you enable
CONFIG_SCSI_MQ_DEFAULT?

Christoph, looks like the previous fix wasn't complete...

-- 
Jens Axboe
