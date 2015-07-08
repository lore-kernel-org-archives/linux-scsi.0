From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 14:14:33 +0300
Message-ID: <559D0619.9040101@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org> <559CFD14.9090803@dev.mellanox.co.il>
 <20150708104955.GA20842@infradead.org> <559D0286.4070202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34139 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbbGHLOW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 07:14:22 -0400
Received: by wifm2 with SMTP id m2so86072890wif.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 04:14:21 -0700 (PDT)
In-Reply-To: <559D0286.4070202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>

On 7/8/2015 1:59 PM, Hannes Reinecke wrote:
> On 07/08/2015 12:49 PM, Christoph Hellwig wrote:
>> On Wed, Jul 08, 2015 at 01:36:04PM +0300, Sagi Grimberg wrote:
>>> We don't have any other information today, but sector is not the only
>>> information that is requires a descriptor format, so maybe it will be a
>>> bit awkward to condition the descriptor format on the sector info?
>>
>> The only reason why you'd want to support descriptor type sense data is
>> because you need to add a second descriptor.  If we have another case
>> that needs descriptor sense data it'll also need to add that additional
>> descriptor.  So we'll need a conditional for it in the sense data
>> generation anyway.
>>
> Actually it's controlled by the D_SENSE bit in the Control mode page
> (that's bit[2] of byte 2 in the control mode page).
> Which is currently set to '0', ie we will be returning fixed sense
> information.
> _If_ we were to report descriptor sense we will need to change that,
> too.

I missed that bit.

>
> And it's actually not true that you'd need descriptor sense to
> encode the sector information; it'll be stored in the 'information'
> section (byte 3-6) for fixed format sense.

But when I return the sector info in a fixed size format, the initiator
is not able to decode the faulty sector:

kernel: DIFv1 Type 1 reference failed on sector: 15 tag: 0xfffffff0 
sector MSB: 0x0000000f
kernel: sd 10:0:1:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
kernel: sd 10:0:1:0: [sdc] tag#0 Sense Key : Aborted Command [current]
kernel: sd 10:0:1:0: [sdc] tag#0 Add. Sense: No additional sense information
kernel: sd 10:0:1:0: [sdc] tag#0 CDB: Read(10) 28 20 00 00 00 00 00 00 10 00
kernel: blk_update_request: I/O error, dev sdc, sector 0

Is that a bug?
