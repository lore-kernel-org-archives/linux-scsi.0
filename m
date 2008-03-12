From: Fredric Isaman <iisaman@citi.umich.edu>
Subject: Re: [pnfs] [PATCH 05/28] pnfsblock: expose scsi interface
Date: Wed, 12 Mar 2008 14:10:03 -0400 (EDT)
Message-ID: <Pine.BSO.4.64.0803121400550.20573@citi.umich.edu>
References: <1205263929-8346-1-git-send-email-iisaman@citi.umich.edu>
 <1205263929-8346-2-git-send-email-iisaman@citi.umich.edu>
 <1205263929-8346-3-git-send-email-iisaman@citi.umich.edu>
 <1205263929-8346-4-git-send-email-iisaman@citi.umich.edu>
 <1205263929-8346-5-git-send-email-iisaman@citi.umich.edu>
 <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu>  <47D805DE.9000100@panasas.com>
 <20080312164306.GA3519@infradead.org> <2ea9cd5a0803121052p6569ff37l26a5448e588407ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from citi.umich.edu ([141.211.133.111]:5056 "EHLO citi.umich.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYCLSKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 14:10:04 -0400
In-Reply-To: <2ea9cd5a0803121052p6569ff37l26a5448e588407ad@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Glasgow <jglasgow@aya.yale.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Benny Halevy <bhalevy@panasas.com>, Andy Adamson <andros@umich.edu>, pnfs@linux-nfs.org, linux-scsi <linux-scsi@vger.kernel.org>



On Wed, 12 Mar 2008, Jason Glasgow wrote:

> Christoph,
>
> Putting device discovery in user space a valid alternative implementation,
> and we will pursue that model.
>
> -Jason
>
>
> On Wed, Mar 12, 2008 at 12:43 PM, Christoph Hellwig <hch@infradead.org>
> wrote:
>
>> On Wed, Mar 12, 2008 at 06:33:34PM +0200, Benny Halevy wrote:
>>> This calls for a layering violation.
>>>
>>> To fill-in more context, here's an excerpt from the next patch,
>>> showing how you use shost_class to scan all scsi disks:
>>

The referenced code is an adhoc hack that does what we need it to for now. 
We would *love* to be able to just call in to some scsi function that fits 
our needs

>> Yes, absolutely.  No one outside of few places in the core scsi code
>> should ever iterate over the scsi disks.
>>

Is this for locking reasons?

>>> My question is how should a proper API between the scsi layer and
>>> the block layout driver look like?
>>>
>>> Can you list your requirements, e.g.:
>>> - scanning all available devices,
>>>
>>> - discovering new devices on the fly
>>>
>>> - getting notified for new devices?
>>
>> Neither.  pnfs shouldn't open block devices from kernelspace at all,
>> but do it's disovery in userspace.
>>


Basically, we are given a disk signature, (an array of offset, byte
sequence pairs) and want to match it against some visible disk (ignoring
partitions), or know that it is not currently visible.

Thus our requirement are:

Scan all available block devices (though all available SCSI devices is a
workable substitute).

Notification of new devices would be a helpful in optimizing rescans for 
unmapped disk signatures.


As Jason mentions, we will pursue doing this in userspace.

 	Fred


