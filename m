From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Fri, 22 May 2015 17:10:44 +0200
Message-ID: <555F46F4.2090002@redhat.com>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net> <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net> <20150518152034.GC5404@twins.programming.kicks-ass.net> <20150518160345.GA18673@twins.programming.kicks-ass.net> <20150518161146.GB18673@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233AbbEVPLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 11:11:19 -0400
In-Reply-To: <20150518161146.GB18673@twins.programming.kicks-ass.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Oelke, Mark" <mark.oelke@hp.com>
Cc: "don.brace@pmcs.com" <don.brace@pmcs.com>, ISS StorageDev <iss_storagedev@hp.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/18/2015 06:11 PM, Peter Zijlstra wrote:
> On Mon, May 18, 2015 at 06:03:45PM +0200, Peter Zijlstra wrote:
>> On Mon, May 18, 2015 at 05:20:34PM +0200, Peter Zijlstra wrote:
>>> On Mon, May 18, 2015 at 01:57:39PM +0000, Oelke, Mark wrote:
>>>> The P212/P410/P411 firmware was recently spun to address an issue that sounds exactly like this problem.
>>>> Which version of controller firmware are you using?
>>>
>>> Smart Array P212 in Slot 1
>>>
>>>    Hardware Revision: C
>>>    Firmware Version: 6.60
>>
>> I've updated to 6.62 and it appears to be working now; or rather, it has
>> not locked up yet where I think it would've locked up by now earlier.
>>
>> I'll let it run for a few more hours before calling it fixed, I'll let
>> you know.
> 
> And right after sending this email it went...
> 
> [ 1119.052144] hpsa 0000:06:00.0: Controller lockup detected: 0x00150029
> 
> So sadly no dice.
> 
> Anything else I can do?
An older issue for mptsas seems to handle a similar case
2a1b7e575b [SCSI] mptsas: fix hangs caused by ATA pass-through
that might be for hpsa -
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1067,6 +1067,8 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
        if (sd != NULL)
                sdev->hostdata = sd;
        spin_unlock_irqrestore(&h->devlock, flags);
+
+       blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
        return 0;
 }
-tm
