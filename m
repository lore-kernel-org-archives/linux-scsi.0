From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 12:23:47 +0300
Message-ID: <4A7166A3.70509@panasas.com>
References: <20090729111114.GA15239@redhat.com>	 <1248875763.3900.1.camel@mulgrave.site>	 <20090729162844.GA22561@merkur.ravnborg.org> <1248885456.3900.48.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:23448
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751057AbZG3JXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 05:23:49 -0400
In-Reply-To: <1248885456.3900.48.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/29/2009 07:37 PM, James Bottomley wrote:
> On Wed, 2009-07-29 at 18:28 +0200, Sam Ravnborg wrote:
>> On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
>>> On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
>>>> scsi/scsi.h is exported to userspace, so it should
>>>> use __u8 instead of u8 as other userspace-visible headers do.
>>> Actually, can we just put a hold on this until we decide what we're
>>> doing with exporting include/scsi.
>>>
>>> Arguments so far are
>>>
>>>      1. Don't export and let glibc supply the headers (as it does now)
>>>      2. Move headers to be exported to include/linux
>>>      3. Take over include/scsi export from glibc: this will necessitate
>>>         comparing our current headers and those of glibc and moving
>>>         stuff around.
>> 2 + 3...
>> Let include/scsi be kernel internal stuff.
>> And have the exported headers in include/linux.
> 
> I don't quite understand what you're saying here.  I think 2 and 3 are
> either/or options.  Either we move the exported files to include/linux
> or we export from include/scsi.
> 
> I have to say I don't like option 2 because the breakage is visible to
> user level programs (unless we can persuade glibc people to #include
> <linux/scsi.h> in scsi/scsi.h).
> 

This is, to me, a definition of a mess. Please (very strongly) don't do that.
The file is scsi/scsi.h and that's it.

I don't know for a fact but I can imagine that there was a time that Kernel
did not export any headers and glibc would sample a set every release. At some
point in time a kind soul decided that Kernel Headers should be exported from
the Kernel package and the rest is history. But he forgot that include/scsi/ is
also included. Lets just fix his simple mistake and fix this by taking back
control of Kernel headers.

>> This is how net/ handle their headers.
>>

If it was done so originally, but now these headers are scsi/*.h, it's
to late.

>> I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
>> >From a quick look it seems that we have more in the kernel version
>> than the glibc version - and no obvious conflicts.
>>

exactly it is original Kernel headers from the time they where sampled
last by glibc.

>> But agree with Boaz that we should do this in one go.
> 

> James
> 
> 

Boaz
