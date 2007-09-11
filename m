From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] Use bio markers for request callback
Date: Tue, 11 Sep 2007 16:27:46 +0200
Message-ID: <20070911162746.reiwz44hq8o80ck8@imap.suse.de>
References: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
	<20070911111133.GJ15405@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48163 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbXIKO1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 10:27:48 -0400
In-Reply-To: <20070911111133.GJ15405@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, k-ueda@ct.jp.nec.com

Am Tue 11 Sep 2007 01:11:34 PM CEST schrieb Jens Axboe  
<jens.axboe@oracle.com>:

> On Tue, Sep 11 2007, Hannes Reinecke wrote:
>> Hi all,
>>
>> this is a proposal for a different implementation of request callbacks. The
>> existing ->endio callback of a request is actually a destructor function,
>> to be called to terminate a request and free all structures.
>>
>> However, on certain occasions (like request-based multipathing) it is
>> desirable to have a callback function for a request which is called right
>> after the request is finished, ie in end_that_request_first() before any
>> bio->bi_endio callback is called.
>>
>> So a simple solution for this is to clone the request and add a new
>> 'marker' bio in front of the bio list of the request. This callback will be
>> attached a structure in bi_private which keeps a pointer to the cloned and
>> the original request, thus serving as a callback for the request itself.
>>
>> Proposed patch attached. As usual comments are welcome.
>
> Honestly, I think this approach is a much worse design than the NEC
> callback option. Exporting __make_request() (which is an INTERNAL
> function) aside, this looks like one big hack with pseudo bio attached
> to front of list, the enable/disable elevator stuff (does that even work
> on stacked devices?).
>
Hmm; agreed. Main reason for the patch was to show an alternative.
Having callbacks within callbacks is not the most straightforward way.
But if you're okay with it: you're the maintainer, you get to decide.

Exporting __make_request() is just for enabling elevator support based
on the target type. Of course this can be done differently.

Main point here was the marker bio idea. If that's rejected everything else
is moot to discuss.

Cheers,

Hannes
---
No .sig today, my .message went away ...
