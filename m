From: Michael Reed <mdr@sgi.com>
Subject: Re: [RFC] [Last Rites] fc transport: extensions for fast fail and
 dev loss
Date: Wed, 09 Aug 2006 10:31:26 -0500
Message-ID: <44D9FFCE.4040702@sgi.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44D8CFD3.9050408@emulex.com> <44D90878.7000903@sgi.com> <44D90CE8.70006@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:14476 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751017AbWHIPbe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 11:31:34 -0400
In-Reply-To: <44D90CE8.70006@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com



Michael Reed wrote:

...snip...

>>>> - fast_io_fail_tmo and LLD callback:

>>>
>>>   at (b): Minimally, we should terminate all active i/o requests marked
>>>           as type REQ_FASTFAIL. From an api perspective, driver support
>>>           for this is optional. And we must also assume that there will
>>>           be implementations which have to abort all i/o in order to
>>>           terminate those marked REQ_FASTFAIL. Is this acceptable ?
>>>           (it meets the "always" condition above)
>>>
>>>           Q: so far we've limited the io to those w/ REQ_FASTFAIL.
>>>             Would we ever want to allow a user to fast fail all i/o
>>>             regardless of the request flags ? (in case they flags
>>>             weren't getting set on all the i/o the user wanted to
>>>             see fail ?)
>> REQ_FAILFAST appears to influence retries during error recovery so
>> there may be unexpected side effects of doing this.  But, that said,
>> I'd say yes.  From my perspective, I'd make this the default behavior.
>>
>> In talking with our volume manager people, the question raised was
>> "Why would you want some i/o to fail quickly and some not?"
>> They even considered non-i/o scsi commands.
>>
...snip...

> 

In thinking about this over night, I would like to withdraw my previous
comments.  (Hence the snip!)

Let's take the case of real time capture from a device and
post processing of that data.  The capture operation would
likely want a fast fail to avoid dropping data.  The post
processing of that data would like to wait for the device
to return to avoid disruption and potential premature termination
of the job.

Under the above scenario, assuming it's a valid scenario, are there
mechanisms in place to allow an application to tag an i/o stream
for fast fail?

Mike
