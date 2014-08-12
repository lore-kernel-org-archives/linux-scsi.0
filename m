From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V4 2/4] Introduce xen-scsifront module
Date: Tue, 12 Aug 2014 13:32:53 +0200
Message-ID: <53E9FB65.6080404@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>	<1407484194-31876-3-git-send-email-jgross@suse.com>	<20140811095424.GB5952@infradead.org> <53E89A91.20203@suse.com> <20140811175042.GA6078@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaHLLc6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2014 07:32:58 -0400
In-Reply-To: <20140811175042.GA6078@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

On 08/11/2014 07:50 PM, Christoph Hellwig wrote:
> On Mon, Aug 11, 2014 at 12:27:29PM +0200, Juergen Gross wrote:
>> What do you mean with "unusual"? You mean transferring the EH action to
>> Dom0?
>
> Yes.  Note that hyperv tries something similar and they've run into
> timeout issues, you might want to read up the recent thread on that.
>
>>>> +				} else {
>>>> +					xenbus_printf(XBT_NIL, dev->nodename,
>>>> +						      state_str, "%d",
>>>> +						      XenbusStateConnected);
>>>> +				}
>>>
>>> Just print this message in ->slave_configure.
>>
>> This is calling for problems, I think. xenbus_printf() is not just a
>> printing function, but it changes an entry in the xenstore. And this
>> requires locking, switching threads, ...
>>
>> I doubt doing this while holding SCSI-internal locks is a good idea.
>
> Oh, I thought xenbus_printf was just a logging wrapper.
>
> Doing major work in the slave_* callouts is not a problem, that's what
> they were designed for.

Okay.

>
> For the successful case the xenbus_printf should be done in
> ->slave_configure.  For the failure case you probably want to do it
> from ->slave_destroy based on the absence of a flag set in ->slave_configure,
> e.g. in slave_configure:
>
> 	sdev->hostdata = (void *)1UL;
>
> and in ->slave_destroy:
>
> 	if (!sdev->hostdata)

I don't think I'll need the flag. The action is the same if the device
is being destroyed again because of already existing or when it is
really removed.

> 		...
>
> although you might see something like this based on external scanning
> through procfs/sysfs as mentioned earlier, so please take a look at
> how all these corner cases could effect you.

I'll add a check if .slave_configure() and .slave_destroy() are running
in the same task as scsi_add_device() or scsi_remove_device(). This
should rule out all of these corner cases.


Juergen

