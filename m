From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] [Last Rites] fc transport: extensions for fast fail and
 dev loss
Date: Thu, 10 Aug 2006 12:17:34 -0400
Message-ID: <44DB5C1E.7070302@emulex.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44D8CFD3.9050408@emulex.com> <20060809173643.GA22969@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42676 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161416AbWHJQSF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 12:18:05 -0400
In-Reply-To: <20060809173643.GA22969@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



Christoph Hellwig wrote:
>>   at (b): Minimally, we should terminate all active i/o requests marked
>>           as type REQ_FASTFAIL. From an api perspective, driver support
>>           for this is optional. And we must also assume that there will
>>           be implementations which have to abort all i/o in order to
>>           terminate those marked REQ_FASTFAIL. Is this acceptable ?
>>           (it meets the "always" condition above)
>>
>>           Q: so far we've limited the io to those w/ REQ_FASTFAIL.
>>             Would we ever want to allow a user to fast fail all i/o
>>             regardless of the request flags ? (in case they flags
>>             weren't getting set on all the i/o the user wanted to
>>             see fail ?)
> 
> I think we should fail all.  It's not like an unprivilegued process could
> request FASTFAIL.  The administrator should know what she/he is doing.

Good.  All it is.

>>> - fast_loss_time recommendation:
>>>  In discussing how a admin should set dev_loss_tmo in a multipathing
>>>  environment, it became apparent that we expected the admin to know
>>>  a lot. They had to know the transport type, what the minimum setting
>>>  can be that still survives normal link bouncing, and they may even
>>>  have to know about device specifics.  For iSCSI, the proper loss time
>>>  may vary widely from session to session.
>>>
>>>  This attribute is an exported "recommendation" by the LLDD and transport
>>>  on what the lowest setting for dev_loss_tmo should be for a multipathing
>>>  environment. Thus, the admin only needs to cat this attribute to obtain
>>>  the value to echo into dev_loss_tmo.
>> The only objection was from Christoph - wanting a utility to get/set this
>> stuff. However, the counter was this attribute was still meaningful, as it
>> was the conduit to obtain a recommendation from the transport/LLD.
>>
>> So - I assume this proceeds as is - with a change in it's description.
> 
> I must say I'm still not happy with this.  It's really policy that we
> try to keep out of the kernel.

Ok. I'll drop this. I don't think it was that important for FC. Mike Christie
had some better arguments for iSCSI.

-- james
