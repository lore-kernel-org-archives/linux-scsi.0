From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for
 PI errors
Date: Mon, 6 Jul 2015 09:22:55 -0700
Message-ID: <559AAB5F.4050209@sandisk.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <559A9EA0.80709@sandisk.com> <559AA964.9090405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:48384
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754256AbbGFQXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 12:23:00 -0400
In-Reply-To: <559AA964.9090405@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On 07/06/2015 09:14 AM, Sagi Grimberg wrote:
> On 7/6/2015 6:28 PM, Bart Van Assche wrote:
>> On 07/06/2015 06:15 AM, Sagi Grimberg wrote:
>>> diff --git a/drivers/target/target_core_transport.c
>>> b/drivers/target/target_core_transport.c
>>> index 0181f8b..79bb8d1 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -2625,6 +2625,7 @@ struct sense_info {
>>>        u8 asc;
>>>        u8 ascq;
>>>        bool add_sector_info;
>>> +    int desc_format;
>>>    };
>>
>> Something minor: has it been considered to use the data type "bool"
>> instead of "int" for desc_format ?
>
> I've considered that, but since scsi_build_sense_buffer() desc argument
> is an int, I figured it would be better than passing desc_format ? 1 : 0
>
> But I can change it if you prefer.

Hello Sagi,

The C language supports implicit conversion from bool to int so I think 
"? 1 : 0" is not necessary to convert a bool into an int.

Bart.
