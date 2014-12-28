From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Sun, 28 Dec 2014 13:08:59 +0100
Message-ID: <549FF2DB.4000506@profihost.ag>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:38577 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaL1MOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Dec 2014 07:14:00 -0500
In-Reply-To: <20141223082805.GA2303@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Christoph,

Am 23.12.2014 um 09:28 schrieb Christoph Hellwig:
> On Mon, Dec 22, 2014 at 11:31:53AM +0100, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> since the below patch i've some problems with iscsi.
>>
>> The LIO based iscsi Server is full of messages like this:
>> SCSI OP 2ah with too big sectors 8344 exceeds fabric_max_sectors: 8192
>>
>> And the client says:
>> Buffer I/O error on device sdd, logical block 38861907
>> lost page write due to I/O error on sdd
>>
>> May be some code fixes for iscsi client is missing?
>
> No, the problem seems that the the target is enforcing a size limit
> without communicating it through the block limits EVPD page.
>
> Nic, can you fix LIO to expose the proper max xfer size?

some more problems while running this patch.

My crucial m500 and m550 ssds (i have around 60 in 30 different cases 
and motherboards but all attached as jbods at LSI HBAs) print those errors:

Dec 23 03:14:56 cloud2-1375 kernel: [585489.194158] Write(10): 2a 00 04 
f9 db f0 00 0c d8 00
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194162] scsi target0:0:7: 
handle(0x000a), sas_address(0x4433221107000000), phy(7)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194163] scsi target0:0:7: 
enclosure_logical_id(0x5003048016aee700), slot(5)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194178] sd 0:0:7:0: task 
abort: SUCCESS scmd(ffff88018c6b4700)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194178] sd 0:0:7:0: 
attempting task abort! scmd(ffff8807a12e6800)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194179] sd 0:0:7:0: [sdh] CDB:
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194180] Read(10): 28 00 15 
d4 f9 60 00 00 10 00
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194183] scsi target0:0:7: 
handle(0x000a), sas_address(0x4433221107000000), phy(7)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194184] scsi target0:0:7: 
enclosure_logical_id(0x5003048016aee700), slot(5)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194199] sd 0:0:7:0: task 
abort: SUCCESS scmd(ffff8807a12e6800)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194199] sd 0:0:7:0: 
attempting task abort! scmd(ffff88078d989800)
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194200] sd 0:0:7:0: [sdh] CDB:
Dec 23 03:14:56 cloud2-1375 kernel: [585489.194201] Read(10): 28 00 15 
aa d2 f9 00 00 20 00

Stefan
