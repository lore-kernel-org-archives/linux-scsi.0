From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI regression in 4.11
Date: Wed, 01 Mar 2017 15:09:44 -0800
Message-ID: <1488409784.2183.48.camel@HansenPartnership.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
         <1488301573.3046.9.camel@linux.vnet.ibm.com>
         <20170228105741.6253bb8a@xeon-e3>
         <1488325732.11610.9.camel@linux.vnet.ibm.com>
         <20170228172532.280811ed@xeon-e3>
         <1488349258.20321.11.camel@linux.vnet.ibm.com>
         <20170301104800.00322bd4@xeon-e3>
         <1488394620.2183.20.camel@linux.vnet.ibm.com>
         <1488396022.2183.26.camel@HansenPartnership.com>
         <20170301132741.7aa3eb96@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57196 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753540AbdCBADq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 19:03:46 -0500
In-Reply-To: <20170301132741.7aa3eb96@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, 2017-03-01 at 13:27 -0800, Stephen Hemminger wrote:
> Ok here is much better data, wasn't accounting for the offset in the
> payload

But now both responses are the same:

> Working 4.10
[...]
> [    1.048920] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0
> srb status 0x20 length 36
> [    1.048920] hv_storvsc:  payload size 288 count 1 offset 1024 len
> 36 pfn 0x1f15d7
> [    1.048921] hv_storvsc:  sg 0: phys 0x1f15d7000 virt
> ffff9270b15d7000 offset 0x400 length 36
> [    1.048922] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [    1.048923] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [    1.048923] data: 00000020: 00 00 00 00                           
>            ....
> [    1.048942] scsi host1: scsi scan: INQUIRY result too short (5),
> using 36
> 
> 
> Broken 4.11
[...]
> [    1.812926] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0
> srb status 0x20 length 36
> [    1.812927] hv_storvsc:  payload size 288 count 1 offset 2816 len
> 36 pfn 0x1f198b
> [    1.812928] hv_storvsc:  sg 0: phys 0x1f198b000 virt
> ffff9a42f198b000 offset 0xb00 length 36
> [    1.812953] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [    1.812953] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [    1.812954] data: 00000020: 00 00 00 00                           
>            ....
> [    1.813258] scsi host1: scsi scan: INQUIRY result too short (5),
> using 36

Hyper-v is returning a buffer of zeros for INQUIRY to the offline
device in both cases ... that means the problem isn't where I thought
it was.

James
