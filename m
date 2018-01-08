From: Hannes Reinecke <hare@suse.com>
Subject: Re: Oops: NULL pointer dereference - RIP:
 isci_task_abort_task+0x30/0x3e0 [isci]
Date: Mon, 8 Jan 2018 11:51:12 +0100
Message-ID: <7d1717f2-0e84-bfeb-5e35-acd72ab39f88@suse.com>
References: <1515154428.30693.43.camel@debian.org>
 <20180108101104.GA5167@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:39951 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756423AbeAHK6A (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 8 Jan 2018 05:58:00 -0500
In-Reply-To: <20180108101104.GA5167@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Yves-Alexis Perez <corsac@debian.org>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 01/08/2018 11:11 AM, Christoph Hellwig wrote:
> Hannes said he was going to look into this, which makes sense
> given that he designed the async abort code.
> 
> On Fri, Jan 05, 2018 at 01:13:48PM +0100, Yves-Alexis Perez wrote:
>> Hi,
>>
>> since kernel 4.11 (sorry it took so long to report) I have a box failing to
>> boot with a NULL pointer dereference (the box is stuck there afterwards).
>>
>> The bug has also been reported to the Debian BTS (https://bugs.debian.org/cgi-
>> bin/bugreport.cgi?bug=882414) and a suggestion to revert 90965761 has been
>> made. I can confirm it fix the boot issue.
>>
>> I don't have the complete stack trace at hand but there's an example in the
>> Debian bug. The machine is a Dell Precision T5600 with the following SATA
>> controllers:
>>
>> 00:1f.2 SATA controller: Intel Corporation C600/X79 series chipset 6-Port SATA
>> AHCI Controller (rev 05)
>> 05:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset 4-Port 
>> SATA Storage Control Unit (rev 05)
>>
>> If you need more information or need me to test something, please ask.
>>
>> Regards,
>> -- 
>> Yves-Alexis
> 
> ---end quoted text---
> 
Looks like we're calling lldd_abort_task() with a NULL argument.
Will be sending a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
