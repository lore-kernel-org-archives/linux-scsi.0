From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 4 Mar 2015 11:23:55 +0100
Message-ID: <54F6DD3B.4030207@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
	 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
	 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
	 <54F1ADAF.90808@sandisk.com>
 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:18112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757590AbbCDKYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2015 05:24:05 -0500
In-Reply-To: <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/02/15 07:59, Nicholas A. Bellinger wrote:
> On Sat, 2015-02-28 at 12:59 +0100, Bart Van Assche wrote:
>> On 02/27/15 22:58, Nicholas A. Bellinger wrote:
>>> Looking at how your attempting to drive creation + removal of struct
>>> config_group from within kernel code here:
>>>
>>> target: Add target port registration API
>>> https://github.com/bvanassche/linux/commit/dbb8bf32db3428ede6ecc688ede1e5e01fc59d88
>>>
>>> is the exactly the wrong approach to take.
>>>
>>> The creation and deletion of struct config_group must be driven by
>>> user-space, and by user-space only.  No exceptions will be made.
>>
>> There exists an approach that preserves the ABI of both SCST and LIO,
>> namely:
>> * Add empty transport_register_wwn() and transport_unregister_wwn()
>>   functions in the LIO core.
>> * Add calls to these functions at the appropriate place in the FC
>>   and SRP target drivers.
>> * In the SCST implementation of the unified target driver API, route
>>   calls to transport_register_wwn() and transport_unregister_wwn() to
>>   scst_register_target() and scst_unregister_target() respectively.
> 
> NAK.
> 
> I'll not consider any hooks in upstream target code.

If you do not agree with what I proposed in my previous e-mail that's
fine. But the companies who maintain SCSI target drivers and I would
appreciate it if you would propose and alternative approach that allows
SCSI target driver unification. I think the LIO users would also
appreciate such a unification. As an example, the SCST FCoE target
driver works much more reliably than the LIO FCoE target driver. The
only way to motivate the SCST maintainers to improve the LIO FCoE target
driver is by unifying the target driver API.

Bart.

