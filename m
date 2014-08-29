From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Date: Thu, 28 Aug 2014 21:42:03 -0500
Message-ID: <53FFE87B.9040802@cs.wisc.edu>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com> <1408244988-27456-1-git-send-email-kys@microsoft.com> <1408244988-27456-2-git-send-email-kys@microsoft.com> <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48978 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaH2CnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 22:43:13 -0400
In-Reply-To: <53FDEBB9.5070704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 08/27/2014 09:31 AM, Hannes Reinecke wrote:
> On 08/19/2014 07:54 PM, Christoph Hellwig wrote:
>> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
>>> The host asks the guest to scan when a LUN is removed or added.
>>> The only way a guest can identify the removed LUN is when an I/O is
>>> attempted on a removed LUN - the SRB status code indicates that the LUN
>>> is invalid. We currently handle this SRB status and remove the device.
>>>
>>> Rather than waiting for an I/O to remove the device, force the
>>> discovery of
>>> LUNs that may have been removed prior to discovering LUNs that may have
>>> been added.
>>
>> This looks pretty reasonable to me, but I wonder if we should move this
>> up to common code so that it happens for any host rescan triggered by
>> sysfs or other drivers as well.
>>
> Not without proper testing.
> Currently we cannot rescan existing devices; the inquiry string is
> nailed to the sdev structure. The only way to really refresh the
> information is to delete it and rescan it again.

How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
gets passed to userspace? Is everyone kicking off a new full (add and
delete) scan to handle this or logging it? Is the driver returning this
when the LUNs change?

Also is the driver getting a 0x5/0x25/0 (invalid LUN) when the LUN does
not exist, or is it just getting that SRB_STATUS_INVALID_LUN error code?
