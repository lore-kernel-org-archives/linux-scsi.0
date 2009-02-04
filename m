From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iscsi_add_session() warning
Date: Wed, 04 Feb 2009 01:40:11 -0600
Message-ID: <4989465B.9060109@cs.wisc.edu>
References: <20090203160900.38506c47.akpm@linux-foundation.org>	<20090204001238.GG19327@bombadil.infradead.org> <20090203162224.7c80d962.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54687 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZBDHkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2009 02:40:41 -0500
In-Reply-To: <20090203162224.7c80d962.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Tue, 3 Feb 2009 19:12:38 -0500
> Kyle McMartin <kyle@infradead.org> wrote:
> 
>> On Tue, Feb 03, 2009 at 04:09:00PM -0800, Andrew Morton wrote:
>>> : 	if (id == ISCSI_MAX_TARGET) {
>>> : 		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
>>> : 			err = device_for_each_child(&shost->shost_gendev, &id,
>> Possibly GCC just can't figure out that id was reinitialized, so it
>> thinks that the for loop won't be executed?
>>
> 
> Could be.  But that isn't the point...
> 
> The point, dear Kyle, is that I misread the code :(
> 
> In fact on that codepath the function _will_ return the most recent
> return value from device_for_each_child(iscsi_get_next_target_id), and
> that value will be non-zero (-EEXIST).  So it looks non-buggy, albeit
> rather obscure.
> 
> But did we intend to return -EEXIST in the "Too many iscsi targets" case?

I did not. The callers just check for non zero so it will work. It would 
be best to change it to something meaningful.

When there are no ids for some object left, what is the stadard Exxxx 
value to return? Would ENOSPC make sense? Here ENOSPC would mean no 
space in id space left instead of space on a device?
