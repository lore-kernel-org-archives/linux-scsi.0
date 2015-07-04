From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH RFC] target: Use scsi helpers to build the sense data
 correctly
Date: Sat, 4 Jul 2015 08:48:37 -0700
Message-ID: <55980055.3010007@sandisk.com>
References: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
 <20150703161236.GA32744@infradead.org> <5597B9E3.70901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:9682
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbbGEIds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 04:33:48 -0400
In-Reply-To: <5597B9E3.70901@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

On 07/04/2015 03:47 AM, Sagi Grimberg wrote:
> On 7/3/2015 7:12 PM, Christoph Hellwig wrote:
>> On Mon, Jun 29, 2015 at 06:05:25PM +0300, Sagi Grimberg wrote:
>>> Instead of open coding the sense buffer construction, use
>>> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
>>> helpers.
>>>
>>> This patch also fixes wrong setting of descriptor format sense data
>>> for t10-pi integrity errors.
>>
>> This looks good in general, but we'd need to move this functions to
>> the scsi common module first now that the target code doesn't use
>> scsi_mod.ko. (Oh, for some reason 4.2 still builds scsi_common.c into
>> scsi_mod.ko, but in the long run it shouldn't).
>
> Yes I figured that these functions need to move to scsi_common.[ch]
>
>>
>> Whie we're at it I'd also really love to Barts sense handling
>> updates to go in:
>>
>> https://github.com/bvanassche/linux/commit/c8e3ccce0753522cff50987db8e411be2b452cdd
>> https://github.com/bvanassche/linux/commit/50e0e2c6681091cda23e677fe9b6fbd2c70d99b1
>> https://github.com/bvanassche/linux/commit/02b27ec5c94117a976e16421556c1cb7287b6635
>>
>> Bart, any chance you could resend them?
>>
>
> Bart, would you prefer to re-send your changes on top of v1 of this one?
> It should be easy enough.
>
> The modification needed is that struct sense_info needs a desc_format
> bool to indicate if the sense data is constructed in a descriptor
> format sense data or not.

Hello Sagi,

Since Christoph asked you to rework your patch, let's start with the 
patches about which there is no discussion. I will post the first two 
patches referred to above next week. The third patch referred to by 
Christoph needs more thought before I can send it upstream.

BTW, I'm reworking my patch series for making ABORT handling synchronous 
and hope to repost that patch series soon.

Bart.
